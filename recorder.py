import time
import json
import os
from pynput import mouse, keyboard

# --- CẤU HÌNH ---
OUTPUT_FILE = "macro.json"
macro_data = []
start_time = None

print("--------------------------------------------------")
print("🔴 HƯỚNG DẪN GHI MACRO TRONG DOCKER:")
print("1. Sau khi chạy, hãy thực hiện các bước bạn muốn.")
print("2. Nhấn phím 'ESC' để dừng ghi và lưu file.")
print("3. File macro.json sẽ được tạo ngay tại thư mục này.")
print("--------------------------------------------------")

def record_event(event_type, details):
    global start_time
    if start_time is None:
        start_time = time.time()
    
    macro_data.append({
        "time": time.time() - start_time,
        "type": event_type,
        "details": details
    })

# Ghi lại sự kiện Click chuột
def on_click(x, y, button, pressed):
    if pressed:
        # Lưu tọa độ x, y chính xác trong Docker
        record_event("click", {"x": x, "y": y, "button": str(button)})
        print(f"🖱 Đã ghi Click: ({x}, {y})")

# Ghi lại sự kiện Bàn phím
def on_press(key):
    try:
        # Các phím chữ cái/số thông thường
        record_event("key_press", {"key": key.char})
        print(f"⌨️ Đã ghi phím: {key.char}")
    except AttributeError:
        # Các phím đặc biệt (Enter, Esc, Ctrl,...)
        key_str = str(key).replace("Key.", "")
        record_event("key_press", {"key": key_str})
        print(f"⌨️ Đã ghi phím đặc biệt: {key_str}")

# Lắng nghe sự kiện
def start_recording():
    with mouse.Listener(on_click=on_click) as m_listener, \
         keyboard.Listener(on_press=on_press) as k_listener:
        
        # Hàm con để dừng khi nhấn ESC
        def stop_on_esc(key):
            if key == keyboard.Key.esc:
                print("\n🛑 Đang dừng và lưu dữ liệu...")
                return False
        
        with keyboard.Listener(on_release=stop_on_esc) as stopper:
            stopper.join()

if __name__ == "__main__":
    start_recording()
    
    # Xuất dữ liệu ra JSON
    with open(OUTPUT_FILE, "w") as f:
        json.dump(macro_data, f, indent=4)
    
    print(f"✅ HOÀN TẤT! File đã lưu tại: {os.path.abspath(OUTPUT_FILE)}")
    print("Bây giờ bạn có thể dùng 'docker cp' để lấy file này ra ngoài VPS.")
