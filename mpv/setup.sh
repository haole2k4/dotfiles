# cú pháp
mpv "link video" 


# nghiệp vụ nếu muốn xem ở web khác
mpv --http-header-fields="Referer: link_web" "Link_video"
# chú ý: 
# - link web : là trang web mà video được nhúng vào, có thể là youtube, facebook, vimeo, ...
# - link video : là link trực tiếp đến video, có thể lấy bằng cách inspect element trên trình duyệt, hoặc sử dụng các công cụ hỗ trợ như youtube-dl, streamlink...
# ở đây nếu muốn dò link video thì mò vào tab inspect xong qua phần network, xem các request get 200 và có đuôi video như mp4, m3u8, ... thì đó chính là link video cần tìm.
# khi coppy lưu ý copy cả auth_key vào link luôn để xem được nhé

# ví dụ 
mpv --http-header-fields="Referer: https://xxx.com/" "https://xxx.xxx.live/live/stream-3636363636_lsd.m3u8?auth_key=3636363636363636"