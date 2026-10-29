# Dotfiles

Kho lưu trữ cấu hình cá nhân quản lý bằng **GNU Stow**, dùng chung được trên **Linux** (Fedora, Ubuntu/Debian, Arch...) và **macOS**.

## Cấu trúc thư mục

```text
dotfiles/
├── Makefile             # Tự động cài đặt stow và quản lý symlink
├── .gitignore           # Chặn file rác, cache, history và secret/token
├── .stow-local-ignore   # Ngăn GNU Stow symlink các file quản lý của repo
│
├── zsh/                 # ~/.zshrc (Zinit, Starship, Git Worktree helpers)
├── ghostty/             # ~/.config/ghostty/ (config & themes)
├── starship/            # ~/.config/starship.toml
├── tmux/                # ~/.tmux.conf
├── git/                 # ~/.gitconfig
├── mpv/                 # ~/.config/mpv/ (mpv.conf & uosc.conf)
├── vim/                 # ~/.vimrc
└── nvim/                # ~/.config/nvim/
```

## Cách sử dụng

### 1. Cài mới (tạo symlink vào `~/`)

```bash
git clone https://github.com/haole2k4/dotfiles.git ~/dotfiles
cd ~/dotfiles
make stow
```

> `Makefile` sẽ tự động kiểm tra và cài `stow` qua `dnf`, `apt`, `pacman` hoặc `brew` nếu máy chưa có.

### 2. Khi máy đã có sẵn file cấu hình thật (`adopt`)

Nếu trong `~/` đã tồn tại các file thật (ví dụ `~/.zshrc`), dùng `adopt` để thu nhận file hiện có vào repo và tạo symlink, sau đó dùng `git diff` để kiểm tra:

```bash
cd ~/dotfiles
make adopt
git diff
# Nếu muốn giữ bản của repo thay vì bản vừa adopt trên máy:
# git checkout .
```

### 3. Gỡ bỏ symlink hoặc bật lẻ từng module

```bash
# Gỡ toàn bộ symlink do repo tạo trong ~/
make unstow

# Hoặc chỉ stow lẻ một vài module:
stow -v -R -t ~ zsh ghostty
```
