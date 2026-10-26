-- ================================================================================================
-- TITLE: Neovim Options
-- ABOUT: Các thiết lập cơ bản cho giao diện, chỉnh sửa, tìm kiếm, folding và xử lý file
-- ================================================================================================

local opt = vim.opt -- Viết ngắn gọn thay cho việc lặp lại `vim.opt`


-- ------------------------------------------------------------------------------------------------
-- UI / Giao diện
-- ------------------------------------------------------------------------------------------------

opt.number = true -- Hiển thị số dòng tuyệt đối ở dòng hiện tại
opt.relativenumber = true -- Hiển thị số dòng tương đối để di chuyển nhanh bằng 5j, 10k...
opt.cursorline = true -- Làm nổi bật dòng chứa con trỏ hiện tại
opt.scrolloff = 8 -- Luôn giữ tối thiểu 8 dòng phía trên và dưới con trỏ
opt.sidescrolloff = 8 -- Luôn giữ tối thiểu 8 cột bên trái và phải con trỏ
opt.wrap = false -- Không tự động xuống dòng khi nội dung dài hơn cửa sổ
opt.signcolumn = "yes" -- Luôn hiện cột sign để giao diện không bị giật khi có diagnostic
opt.colorcolumn = "100" -- Đánh dấu cột 100 để nhắc giới hạn độ dài dòng
opt.termguicolors = true -- Bật màu 24-bit cho colorscheme và terminal hiện đại
opt.showmatch = true -- Làm nổi bật dấu ngoặc tương ứng khi con trỏ đi qua
opt.matchtime = 2 -- Hiện dấu ngoặc tương ứng trong 0,2 giây
opt.showmode = false -- Không hiện mode vì statusline có thể đảm nhận chức năng này
opt.pumheight = 10 -- Giới hạn menu completion tối đa 10 dòng
opt.pumblend = 10 -- Đặt độ trong suốt nhẹ cho menu completion
opt.synmaxcol = 300 -- Không chạy syntax highlighting truyền thống sau cột 300


-- ------------------------------------------------------------------------------------------------
-- Indentation / Thụt lề
-- ------------------------------------------------------------------------------------------------

opt.tabstop = 2 -- Một ký tự Tab được hiển thị tương đương 2 khoảng trắng
opt.shiftwidth = 2 -- Các lệnh thụt lề như `>>`, `<<` sử dụng 2 khoảng trắng
opt.softtabstop = 2 -- Khi chỉnh sửa, phím Tab và Backspace hoạt động theo nhóm 2 khoảng trắng
opt.expandtab = true -- Chuyển phím Tab thành khoảng trắng thay vì ký tự tab thật
opt.autoindent = true -- Sao chép mức thụt lề từ dòng hiện tại sang dòng mới
opt.smartindent = true -- Tự động tăng hoặc giảm thụt lề theo cấu trúc code cơ bản


-- ------------------------------------------------------------------------------------------------
-- Search / Tìm kiếm
-- ------------------------------------------------------------------------------------------------

opt.ignorecase = true -- Không phân biệt chữ hoa và chữ thường khi tìm kiếm
opt.smartcase = true -- Phân biệt hoa thường nếu từ khóa tìm kiếm chứa chữ hoa
opt.incsearch = true -- Hiển thị kết quả ngay trong lúc nhập từ khóa tìm kiếm
opt.hlsearch = false -- Không giữ highlight tất cả kết quả sau khi tìm kiếm


-- ------------------------------------------------------------------------------------------------
-- Completion / Gợi ý code
-- ------------------------------------------------------------------------------------------------

opt.completeopt = { "menuone", "noinsert", "noselect" }
-- menuone: luôn mở menu ngay cả khi chỉ có một kết quả
-- noinsert: không tự động chèn kết quả vào buffer
-- noselect: không tự động chọn kết quả đầu tiên


-- ------------------------------------------------------------------------------------------------
-- Editing behavior / Hành vi chỉnh sửa
-- ------------------------------------------------------------------------------------------------

opt.mouse = "a" -- Cho phép sử dụng chuột trong tất cả các mode
opt.clipboard:append("unnamedplus") -- Đồng bộ thao tác yank, delete và paste với clipboard hệ thống
opt.autoread = true -- Đọc lại file khi phát hiện file đã bị chương trình khác thay đổi
opt.autowrite = false -- Không tự động lưu file khi thực hiện một số lệnh chuyển buffer
opt.backspace = { "indent", "eol", "start" } -- Cho phép Backspace qua indent, xuống dòng và điểm bắt đầu Insert mode
opt.selection = "inclusive" -- Visual selection bao gồm cả ký tự cuối cùng được chọn


-- ------------------------------------------------------------------------------------------------
-- File recovery / Sao lưu và khôi phục
-- ------------------------------------------------------------------------------------------------

opt.backup = false -- Không giữ lại file backup vĩnh viễn sau khi lưu thành công
opt.writebackup = true -- Tạo backup tạm trong lúc ghi file để tránh hỏng dữ liệu
opt.swapfile = true -- Tạo swap file để khôi phục nội dung chưa lưu nếu Neovim bị crash
opt.undofile = true -- Lưu undo history để có thể undo sau khi đóng và mở lại file

local undodir = vim.fn.stdpath("state") .. "/undo" -- Lấy thư mục state chuẩn theo XDG
vim.fn.mkdir(undodir, "p") -- Tạo thư mục undo nếu thư mục chưa tồn tại
opt.undodir = undodir -- Chỉ định nơi lưu các file persistent undo


-- ------------------------------------------------------------------------------------------------
-- Timing / Thời gian phản hồi
-- ------------------------------------------------------------------------------------------------

opt.updatetime = 300 -- Kích hoạt CursorHold và cập nhật swap sau 300 mili giây
opt.timeoutlen = 500 -- Chờ tối đa 500 mili giây để hoàn thành một tổ hợp phím mapping
opt.ttimeoutlen = 50 -- Chờ tối đa 50 mili giây để nhận đầy đủ escape sequence từ terminal


-- ------------------------------------------------------------------------------------------------
-- Ripgrep integration / Tích hợp ripgrep
-- ------------------------------------------------------------------------------------------------

if vim.fn.executable("rg") == 1 then -- Chỉ thiết lập khi hệ thống đã cài ripgrep
  opt.grepprg = "rg --vimgrep --smart-case" -- Dùng ripgrep cho lệnh `:grep`
  opt.grepformat = "%f:%l:%c:%m" -- Đọc kết quả theo file:dòng:cột:nội dung
end


-- ------------------------------------------------------------------------------------------------
-- Wildcard completion / Tự động hoàn thành đường dẫn
-- ------------------------------------------------------------------------------------------------

opt.wildmenu = true -- Hiển thị menu completion khi nhập lệnh
opt.wildmode = "longest:full,full" -- Hoàn thành phần chung trước rồi hiển thị toàn bộ kết quả
opt.wildignorecase = true -- Không phân biệt chữ hoa và chữ thường khi hoàn thành tên file

opt.wildignore:append({
  "*/.git/*", -- Bỏ qua dữ liệu nội bộ của Git
  "*/node_modules/*", -- Bỏ qua dependency của Node.js
  "*/target/*", -- Bỏ qua output Maven, Gradle hoặc Rust
  "*/build/*", -- Bỏ qua thư mục build chung
  "*/.gradle/*", -- Bỏ qua cache và dữ liệu nội bộ Gradle
})


-- ------------------------------------------------------------------------------------------------
-- Diff / So sánh file
-- ------------------------------------------------------------------------------------------------

opt.diffopt:append({
  "vertical", -- Mở các cửa sổ diff theo chiều dọc
  "algorithm:patience", -- Dùng thuật toán patience để tạo diff dễ đọc hơn
  "linematch:60", -- Cải thiện việc ghép và highlight các dòng đã thay đổi
})


-- ------------------------------------------------------------------------------------------------
-- Split behavior / Cách mở cửa sổ
-- ------------------------------------------------------------------------------------------------

opt.splitbelow = true -- Mở horizontal split mới ở phía dưới
opt.splitright = true -- Mở vertical split mới ở phía bên phải


-- ------------------------------------------------------------------------------------------------
-- Folding / Thu gọn code
-- ------------------------------------------------------------------------------------------------

opt.foldmethod = "expr" -- Xác định fold bằng một biểu thức
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Dùng Tree-sitter để phân tích vùng có thể fold
opt.foldlevel = 99 -- Mở gần như toàn bộ fold trong cửa sổ hiện tại
opt.foldlevelstart = 99 -- Mở gần như toàn bộ fold khi bắt đầu chỉnh sửa buffer
opt.foldenable = true -- Cho phép sử dụng chức năng folding


-- ------------------------------------------------------------------------------------------------
-- Cursor / Hình dạng con trỏ
-- ------------------------------------------------------------------------------------------------

opt.guicursor = {
  "n-v-c:block", -- Dùng con trỏ dạng khối trong Normal, Visual và Command mode
  "i-ci-ve:block", -- Dùng con trỏ dạng khối trong Insert và Visual Exclusive mode
  "r-cr:hor20", -- Dùng con trỏ ngang cao 20% trong Replace mode
  "o:hor50", -- Dùng con trỏ ngang cao 50% trong Operator-pending mode
  "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor", -- Thiết lập hiệu ứng nhấp nháy chung
  "sm:block-blinkwait175-blinkoff150-blinkon175", -- Con trỏ khi Neovim hiển thị dấu ngoặc tương ứng
}


-- ------------------------------------------------------------------------------------------------
-- Language-specific indentation / Thụt lề theo ngôn ngữ
-- ------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java", "python", "c", "cpp" }, -- Áp dụng cho Java, Python, C và C++
  callback = function()
    vim.opt_local.tabstop = 4 -- Hiển thị một Tab tương đương 4 khoảng trắng
    vim.opt_local.shiftwidth = 4 -- Các lệnh thụt lề sử dụng 4 khoảng trắng
    vim.opt_local.softtabstop = 4 -- Tab và Backspace hoạt động theo nhóm 4 khoảng trắng
    vim.opt_local.expandtab = true -- Sử dụng khoảng trắng thay cho ký tự tab thật
  end,
})


-- ------------------------------------------------------------------------------------------------
-- Markdown / Obsidian
-- ------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown", -- Chỉ áp dụng cho file Markdown
  callback = function()
    vim.opt_local.conceallevel = 2 -- Ẩn một phần ký hiệu Markdown để nội dung dễ đọc hơn
    vim.opt_local.concealcursor = "" -- Hiện lại markup tại dòng đang đặt con trỏ
    vim.opt_local.iskeyword:append("-") -- Xem từ có dấu gạch ngang là một từ hoàn chỉnh
  end,
})