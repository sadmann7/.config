# Skip system-wide compinit (we run our own cached version)
skip_global_compinit=1

# uv / user binaries
export PATH="$HOME/.local/bin:$PATH"

# All git clones live here
export CODE_HOME="$HOME/code"

# Put a real nvm `node` on PATH. pnpm/tsx shims run under /bin/sh and cannot
# see zsh functions, and alias/default is often "lts/*" (not a folder name).
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -d "$NVM_DIR/versions/node" ]]; then
  _nvm_ver=""
  if [[ -f "$NVM_DIR/alias/default" ]]; then
    _nvm_ver="${$(<"$NVM_DIR/alias/default")%%$'\n'}"
    while [[ -n "$_nvm_ver" && -f "$NVM_DIR/alias/$_nvm_ver" ]]; do
      _nvm_ver="${$(<"$NVM_DIR/alias/$_nvm_ver")%%$'\n'}"
    done
  fi
  _nvm_bin=""
  if [[ -x "$NVM_DIR/versions/node/${_nvm_ver}/bin/node" ]]; then
    _nvm_bin="$NVM_DIR/versions/node/${_nvm_ver}/bin"
  elif [[ -x "$NVM_DIR/versions/node/v${_nvm_ver#v}/bin/node" ]]; then
    _nvm_bin="$NVM_DIR/versions/node/v${_nvm_ver#v}/bin"
  else
    _nvm_bin=($NVM_DIR/versions/node/v*/bin(N[-1]))
  fi
  if [[ -n "$_nvm_bin" && -x "$_nvm_bin/node" ]]; then
    export PATH="$_nvm_bin:$PATH"
  fi
  unset _nvm_ver _nvm_bin
fi
