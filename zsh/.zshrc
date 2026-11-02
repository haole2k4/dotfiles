# ============================================================
# PATH (typeset -U tự động loại bỏ đường dẫn trùng lặp)
# ============================================================
typeset -U path PATH

export PNPM_HOME="$HOME/.local/share/pnpm"
[ -d "/usr/lib/jvm/java-25-openjdk" ] && export JAVA_HOME="/usr/lib/jvm/java-25-openjdk"

path=(
  "$HOME/.local/bin"
  "$HOME/.opencode/bin"
  ${JAVA_HOME:+"$JAVA_HOME/bin"}
  "$PNPM_HOME/bin"
  $path
)

# ============================================================
# ZINIT & PLUGINS
# ============================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# 1. Nạp completions TRƯỚC compinit
zinit light zsh-users/zsh-completions

# 2. compinit có cache: chỉ quét lại .zcompdump nếu cũ hơn 24h (bật extendedglob cục bộ)
autoload -Uz compinit
() {
  setopt local_options extendedglob
  if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
}

# 3. autosuggestions nạp sau compinit
zinit light zsh-users/zsh-autosuggestions

# ============================================================
# STYLING & HISTORY
# ============================================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

HISTSIZE=2500
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ============================================================
# NODE: dùng fnm mặc định, nvm chỉ nạp khi gõ lệnh `nvm` (lazy-load)
# ============================================================
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  path=("$FNM_PATH" $path)
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ============================================================
# PROMPT (Starship)
# ============================================================
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

# ============================================================
# SYNTAX HIGHLIGHTING (Luôn nạp ở cuối file để bọc mọi widget)
# ============================================================
zinit light zsh-users/zsh-syntax-highlighting
