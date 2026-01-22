# ============================================
# Minimal Ultra-Fast ZSH Config
# Target: <50ms startup
# ============================================

# Homebrew (cached path instead of eval)
export HOMEBREW_PREFIX="/opt/homebrew"
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"

# TMPDIR
[[ -z "$TMPDIR" || ! -w "$TMPDIR" ]] && export TMPDIR="/tmp"

# ============================================
# Lazy-load NVM with .nvmrc auto-switch
# ============================================
export NVM_DIR="$HOME/.nvm"
[[ -f "$NVM_DIR/alias/default" ]] && export PATH="$NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default)/bin:$PATH"

_nvm_loaded=0
_load_nvm() {
  [[ $_nvm_loaded -eq 1 ]] && return
  unset -f nvm node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  _nvm_loaded=1
}
nvm() { _load_nvm && nvm "$@"; }
node() { _load_nvm && node "$@"; }
npm() { _load_nvm && npm "$@"; }
npx() { _load_nvm && npx "$@"; }

# Auto-switch node version based on .nvmrc
_nvmrc_hook() {
  local nvmrc_path
  nvmrc_path="$(pwd)"
  while [[ "$nvmrc_path" != "" && ! -f "$nvmrc_path/.nvmrc" ]]; do
    nvmrc_path="${nvmrc_path%/*}"
  done
  if [[ -f "$nvmrc_path/.nvmrc" ]]; then
    local nvmrc_version=$(cat "$nvmrc_path/.nvmrc")
    local current_version=$(node -v 2>/dev/null)
    if [[ "$current_version" != "$nvmrc_version" && "$current_version" != "v$nvmrc_version" ]]; then
      _load_nvm
      nvm use --silent 2>/dev/null || nvm install
    fi
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _nvmrc_hook

# ============================================
# Completions
# ============================================
# Add Homebrew completions to fpath
fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

# Fast compinit (once per day)
autoload -Uz compinit
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
[[ -d "${ZSH_COMPDUMP%/*}" ]] || mkdir -p "${ZSH_COMPDUMP%/*}"

if [[ -f "$ZSH_COMPDUMP" && $(find "$ZSH_COMPDUMP" -mtime -1 2>/dev/null) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -i -d "$ZSH_COMPDUMP"
fi

# ============================================
# Prompt (oh-my-zsh robbyrussell style)
# ============================================
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{blue}git:(%F{red}%b%F{blue})%f'
setopt PROMPT_SUBST
PROMPT='%F{green}➜%f  %F{cyan}%1~%f${vcs_info_msg_0_} '

# ============================================
# History
# ============================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY

# ============================================
# Key bindings
# ============================================
bindkey -e  # emacs mode
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ============================================
# Autosuggestions
# ============================================
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Try oh-my-zsh location first, then homebrew
if [[ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi


# ============================================
# Aliases
# ============================================
alias ll="eza -la --icons"
alias la="eza -A --icons"
alias ls="eza --icons"
alias tree="eza --tree --icons"
alias ..="cd .."
alias ...="cd ../.."
alias cat="bat"
alias find="fd"

# Git aliases (what you'd use from oh-my-zsh git plugin)
alias g="git"
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gl="git pull"
alias gp="git push"
alias gst="git status"
alias gb="git branch"
alias glog="git log --oneline --graph"

# ============================================
# Lazy-load tools
# ============================================
_load_zoxide() { unset -f z zi; eval "$(zoxide init zsh)"; }
z() { _load_zoxide && z "$@"; }
zi() { _load_zoxide && zi "$@"; }

# fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ============================================
# PATH (nvm node should come before pnpm)
# ============================================
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$HOME/.local/bin:$BUN_INSTALL/bin:$PNPM_HOME:$PATH"
