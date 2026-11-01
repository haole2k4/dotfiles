# Danh sách các module GNU Stow quản lý dotfiles trong ~/
STOW_MODULES := zsh ghostty starship tmux git mpv vim nvim niri dms
TARGET_DIR   := $(HOME)

.PHONY: help stow adopt unstow

define ensure_stow
	@if ! command -v stow >/dev/null 2>&1; then \
		echo "[INFO] Chưa cài đặt GNU Stow. Đang tự động cài đặt..."; \
		if command -v dnf >/dev/null 2>&1; then \
			sudo dnf install -y stow; \
		elif command -v apt >/dev/null 2>&1; then \
			sudo apt update && sudo apt install -y stow; \
		elif command -v pacman >/dev/null 2>&1; then \
			sudo pacman -S --noconfirm stow; \
		elif command -v brew >/dev/null 2>&1; then \
			brew install stow; \
		else \
			echo "[ERR] Không tìm thấy trình quản lý gói hỗ trợ (dnf, apt, pacman, brew). Vui lòng tự cài đặt GNU Stow."; \
			exit 1; \
		fi; \
	fi
endef

help:
	@echo "=================================================================="
	@echo "  DOTFILES (GNU STOW) - BẢNG ĐIỀU KHIỂN"
	@echo "=================================================================="
	@echo "  make stow   : Symlink toàn bộ dotfiles vào ~/ (stow -R)"
	@echo "  make adopt  : Đồng bộ ngược từ ~/ vào repo & tạo symlink (stow --adopt)"
	@echo "  make unstow : Gỡ bỏ toàn bộ symlink khỏi ~/ (stow -D)"
	@echo "=================================================================="

stow:
	$(ensure_stow)
	@echo "[INFO] Đang tạo symlink cho các module: $(STOW_MODULES) -> $(TARGET_DIR)"
	stow -v -R -t "$(TARGET_DIR)" $(STOW_MODULES)
	@echo "[OK] Hoàn tất symlink toàn bộ dotfiles!"

adopt:
	$(ensure_stow)
	@echo "[INFO] Đang adopt & tạo symlink cho các module: $(STOW_MODULES) -> $(TARGET_DIR)"
	stow -v --adopt -t "$(TARGET_DIR)" $(STOW_MODULES)
	@echo "[OK] Đã adopt và tạo symlink thành công! Kiểm tra thay đổi bằng 'git diff'."

unstow:
	stow -v -D -t "$(TARGET_DIR)" $(STOW_MODULES)
