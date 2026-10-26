#ZINIT CONFIGURATIONS
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

#zinit plugins
zinit light zsh-users/zsh-syntax-highlighting #load syntax-highlighting
zinit light zsh-users/zsh-autosuggestions #load auto-suggestions
zinit light zsh-users/zsh-completions #load completions

#load completions
autoload -U compinit && compinit

# STARSHIP CONFIGURATIONS
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

#HISTORY
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

#STYLING
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME='/home/haole2k4/.local/share/pnpm'
case ":$PATH:" in
  ":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

#java 
export JAVA_HOME="/usr/lib/jvm/java-25-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
#java end

export PATH="$HOME/.local/bin:$PATH"

# fnm
FNM_PATH="/home/haole2k4/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

# opencode
export PATH=/home/haole2k4/.opencode/bin:$PATH
export PATH="$HOME/.opencode/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="/home/haole2k4/.local/bin:$PATH"

# --- GIT WORKTREE HELPERS ---
alias wtls="git worktree list"

wta() {
  if [ -z "$1" ]; then
    print -P "%F{yellow}[USAGE]%f wta <branch-name> %F{242}(e.g., wta feat/login)%f"
    return 1
  fi

  local branch="$1"
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -z "$repo_root" ]; then
    print -P "%F{red}%B[ERR]%b%f Not inside a git repository."
    return 1
  fi

  local repo_name=$(basename "$repo_root")
  local dir_name="${branch//\//-}"
  local target_dir="$(dirname "$repo_root")/${repo_name}.worktrees/${dir_name}"

  mkdir -p "$(dirname "$target_dir")"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    print -P "%F{blue}[INFO]%f Checking out existing branch %B${branch}%b..."
    git worktree add "$target_dir" "$branch"
  else
    print -P "%F{blue}[INFO]%f Creating new branch %B${branch}%b..."
    git worktree add -b "$branch" "$target_dir"
  fi

  # Copy .env files nếu có (bật null_glob của zsh để không báo lỗi khi không có file .env)
  setopt local_options null_glob
  local env_files=("$repo_root"/.env*)
  if (( ${#env_files[@]} > 0 )); then
    cp "${env_files[@]}" "$target_dir"/
    print -P "%F{green}[ENV]%f Copied ${#env_files[@]} .env file(s) -> %F{cyan}${dir_name}%f"
  fi

  cd "$target_dir" || return
  print -P "%F{green}%B[OK]%b%f Switched to worktree: %F{magenta}${target_dir}%f"
}

wtdone() {
  local current_wt=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -z "$current_wt" ]; then
    print -P "%F{red}%B[ERR]%b%f Not inside a git repository."
    return 1
  fi

  local common_dir=$(git rev-parse --git-common-dir)
  local main_repo=$(cd "$(dirname "$common_dir")" && pwd)
  local branch=$(git rev-parse --abbrev-ref HEAD)

  if [ "$current_wt" = "$main_repo" ]; then
    print -P "%F{yellow}%B[WARN]%b%f Already in MAIN worktree (%F{cyan}${main_repo}%f). Aborting."
    return 1
  fi

  print -P "%F{blue}[INFO]%f Removing worktree %F{magenta}${current_wt}%f..."
  cd "$main_repo" || return

  if git worktree remove "$current_wt"; then
    git worktree prune
    git branch -d "$branch" 2>/dev/null
    print -P "%F{green}%B[CLEAN]%b%f Removed worktree & branch %B${branch}%b. Back in %F{cyan}MAIN%f."
  else
    print -P "%F{red}%B[ERR]%b%f Failed to remove worktree (uncommitted changes?). Use %F{yellow}git worktree remove -f%f if sure."
    cd "$current_wt" || return
    return 1
  fi
}
