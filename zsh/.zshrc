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
# Lazy-load NVM
# ============================================
export NVM_DIR="$HOME/.nvm"
[[ -f "$NVM_DIR/alias/default" ]] && export PATH="$NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default)/bin:$PATH"

_load_nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}
nvm() { _load_nvm && nvm "$@"; }
node() { _load_nvm && node "$@"; }
npm() { _load_nvm && npm "$@"; }
npx() { _load_nvm && npx "$@"; }

# ============================================
# Fast compinit (once per day, skip security check)
# ============================================
autoload -Uz compinit
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
[[ -d "${ZSH_COMPDUMP%/*}" ]] || mkdir -p "${ZSH_COMPDUMP%/*}"

# Always use -C (skip check) if dump exists and is from today
if [[ -n "$ZSH_COMPDUMP"(#qN.mh-24) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -i -d "$ZSH_COMPDUMP"  # -i skips insecure directory warnings
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
# Autosuggestions (loaded after line editor init)
# ============================================
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST="${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$ZSH_AUTOSUGGEST" ]] && source "$ZSH_AUTOSUGGEST"

# Syntax highlighting (must be last)
ZSH_SYNTAX="${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$ZSH_SYNTAX" ]] && source "$ZSH_SYNTAX"

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
# PATH
# ============================================
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$BUN_INSTALL/bin:$PNPM_HOME:$HOME/.local/bin:$PATH"
