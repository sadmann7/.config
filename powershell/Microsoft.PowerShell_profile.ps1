# oh-my-posh (async theme renders prompt immediately, fills in git/etc after)
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\cobalt.omp.json" | Invoke-Expression

# PSReadLine
if ($Host.UI.SupportsVirtualTerminal -and [Environment]::UserInteractive) {
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineOption -BellStyle None
    Set-PSReadLineKeyHandler -Chord "Ctrl+d" -Function DeleteChar
    # History is faster than HistoryAndPlugin at startup; fzf still works once PSFzf loads
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
}

# Zoxide
Invoke-Expression (zoxide init powershell | Out-String)

# fnm (Out-String required — piping lines directly breaks multiline function defs)
if (-not $env:FNM_MULTISHELL_PATH) {
    fnm env --use-on-cd | Out-String | Invoke-Expression
}

# Defer heavy modules so the prompt appears first
if ($Host.UI.SupportsVirtualTerminal -and [Environment]::UserInteractive) {
    $deferredProfileTimer = [System.Timers.Timer]::new()
    $deferredProfileTimer.Interval = 1
    $deferredProfileTimer.AutoReset = $false
    $null = Register-ObjectEvent -InputObject $deferredProfileTimer -EventName Elapsed -Action {
        Import-Module PSFzf -ErrorAction SilentlyContinue
        Set-PsFzfOption -PSReadlineChordProvider "Ctrl+f" -PsReadlineChordReverseHistory "Ctrl+r"
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
        $Event.MessageData.Dispose()
    } -MessageData $deferredProfileTimer
    $deferredProfileTimer.Start() | Out-Null
}

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
