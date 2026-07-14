# ── Cached inits (skip subprocess on every tab) ────────────────────────────────
$_T = $env:TEMP

$_zox_cache = "$_T\zoxide_init.ps1"
if (-not (Test-Path $_zox_cache)) {
    zoxide init powershell | Set-Content $_zox_cache -Encoding UTF8
}
. $_zox_cache

if (-not $env:FNM_MULTISHELL_PATH) {
    $_fnm_cache = "$_T\fnm_env.ps1"
    if (-not (Test-Path $_fnm_cache)) {
        fnm env --use-on-cd | Out-String | Set-Content $_fnm_cache -Encoding UTF8
    }
    . $_fnm_cache
}

# ── PSReadLine ──────────────────────────────────────────────────────────────────
if ($Host.UI.SupportsVirtualTerminal -and [Environment]::UserInteractive) {
    Set-PSReadLineOption -EditMode Emacs -BellStyle None -PredictionSource History -PredictionViewStyle ListView
    Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar

    # Record command start time so the prompt can show execution duration
    Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
        $global:__cmdStart = [DateTime]::UtcNow
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}

# ── Git branch (reads .git/HEAD directly — zero subprocesses) ──────────────────
function global:__GitBranch {
    $p = $PWD.Path
    while ($p) {
        $headFile = Join-Path $p '.git\HEAD'
        if (Test-Path $headFile -PathType Leaf) {
            $content = [System.IO.File]::ReadAllText($headFile).Trim()
            if ($content -match '^ref: refs/heads/(.+)$') { return $matches[1] }
            return $content.Substring(0, [Math]::Min(7, $content.Length))  # detached HEAD
        }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { break }
        $p = $parent
    }
    return $null
}

# ── Prompt (matches cobalt theme: path  branch ✗ [time] ❯) ────────────────────
function global:prompt {
    # Capture exit state first — any call below will overwrite $? / $LASTEXITCODE
    $ok   = $?
    $code = $LASTEXITCODE

    # Execution time (only shown when ≥ 100ms)
    $timeStr = ''
    if ($global:__cmdStart) {
        $ms = ([DateTime]::UtcNow - $global:__cmdStart).TotalMilliseconds
        $global:__cmdStart = $null
        if ($ms -ge 100) {
            $timeStr = if ($ms -ge 60000) {
                " $([math]::Floor($ms / 60000))m$([math]::Floor(($ms % 60000) / 1000))s"
            } elseif ($ms -ge 1000) {
                " $([math]::Round($ms / 1000, 1))s"
            } else {
                " $([int]$ms)ms"
            }
        }
    }

    # OSC 9;9 — tells Windows Terminal the CWD so Ctrl+Shift+T opens in same dir
    [Console]::Write("`e]9;9;`"$($PWD.Path)`"`a")

    # Cobalt palette
    $blue   = "`e[38;2;95;170;232m"   # #5FAAE8  path
    $red    = "`e[38;2;241;78;50m"    # #f14e32  git branch
    $orange = "`e[38;2;244;91;64m"    # #f45b40  error ✗
    $green  = "`e[38;2;152;195;121m"  # #98C379  ❯
    $dim    = "`e[38;2;128;128;128m"  #          timing
    $rst    = "`e[0m"

    # Path — leaf folder only, ~ for home (matches cobalt "folder" style)
    $leaf = Split-Path $PWD.Path -Leaf
    $displayPath = if ($PWD.Path -eq $HOME)               { '~' }
                   elseif ($PWD.Path.StartsWith($HOME))    { "~/$leaf" }
                   else                                    { $leaf }

    $out = "$blue$displayPath$rst"

    # Git branch
    $branch = __GitBranch
    if ($branch) { $out += "  $red$branch$rst" }

    # Error indicator
    if (-not $ok -or ($code -and $code -ne 0)) { $out += "  $orange`u{2717}$rst" }

    # Execution time (dim, inline)
    if ($timeStr) { $out += "$dim$timeStr$rst" }

    # Prompt character
    $out += "  $green`u{276F}$rst "

    return $out
}

# ── Deferred heavy modules ──────────────────────────────────────────────────────
if ($Host.UI.SupportsVirtualTerminal -and [Environment]::UserInteractive) {
    $deferredProfileTimer = [System.Timers.Timer]::new()
    $deferredProfileTimer.Interval = 1
    $deferredProfileTimer.AutoReset = $false
    $null = Register-ObjectEvent -InputObject $deferredProfileTimer -EventName Elapsed -Action {
        Import-Module PSFzf -ErrorAction SilentlyContinue
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PsReadlineChordReverseHistory 'Ctrl+r'
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
        $Event.MessageData.Dispose()
    } -MessageData $deferredProfileTimer
    $deferredProfileTimer.Start() | Out-Null
}

# ── Utilities ───────────────────────────────────────────────────────────────────
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
