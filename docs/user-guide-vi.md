# 📱 Hướng dẫn sử dụng ccpoke

> Điều khiển AI agent từ Telegram — tất cả thao tác được chia thành **Mac** và **Telegram**.

---

## Mục lục

1. [Cài đặt ban đầu (1 lần duy nhất)](#1-cài-đặt-ban-đầu)
2. [Thao tác hàng ngày](#2-thao-tác-hàng-ngày)
3. [Quản lý sessions](#3-quản-lý-sessions)
4. [Chat 2 chiều](#4-chat-2-chiều)
5. [Xử lý sự cố](#5-xử-lý-sự-cố)

---

## 1. Cài đặt ban đầu

> Chỉ cần làm **1 lần**. Sau đó chỉ cần `ccpoke` để khởi động.

### 🖥️ Mac

```bash
# Bước 1: Cài ccpoke
npm i -g ccpoke

# Bước 2: Chạy setup
ccpoke setup
```

Setup sẽ hỏi:

| Bước | Bạn nhập |
|------|----------|
| Language | English hoặc Tiếng Việt |
| Bot Token | Lấy từ Telegram [@BotFather](https://t.me/BotFather) |
| Quét QR | Mở link trên điện thoại |
| Chọn agents | Claude Code, Codex CLI, Cursor CLI, Gemini CLI |

### 📱 Telegram

1. Mở link QR hoặc tìm bot bạn vừa tạo
2. Gửi `/start` → Bot xác nhận kết nối ✅

### 🖥️ Mac — Đăng ký project

```bash
ccpoke project

# Ví dụ:
# Tên: ios-knowledge
# Đường dẫn: /Volumes/Workspace/0-Working/bkplus/ios-knowledge
```

> **Mẹo:** Đăng ký cùng đường dẫn nhiều lần với tên khác nhau để phân biệt mục đích:
> - `KL - Memory Feature` → cùng path
> - `KL - Bug Fix` → cùng path

---

## 2. Thao tác hàng ngày

### 🖥️ Mac — Khởi động

```bash
ccpoke
```

Output khi thành công:

```
tmux: found X Claude Code session(s)
📱 2-way chat: enabled
hook server listening on localhost:9377
telegram bot started ✅
```

> **Lưu ý:** ccpoke phải chạy liên tục. Đừng tắt terminal chạy ccpoke.

### 📱 Telegram — Tạo session mới

```
/projects
```

```
📂 ios-knowledge      ← Bấm chọn
📂 Q_Agents
📂 ios010-gps-camera
```

→ Chọn agent:

```
[Claude Code]  [Codex CLI]  [Cursor CLI]
```

→ ✅ Agent khởi chạy trong ô tmux mới trên Mac.

**Tạo nhiều session:** Lặp lại `/projects` → chọn project → chọn agent.

### 📱 Telegram — Nhận notification

Khi agent hoàn thành task, bạn nhận tin:

```
📦 ios-knowledge
🐾 Claude Code

Đã cập nhật Memory Viewer với sorting...

🤖 claude-opus-4-6

[View Details]  [💬 Chat]
```

---

## 3. Quản lý sessions

### 📱 Telegram — Xem tất cả sessions

```
/sessions
```

```
🟢 ios-knowledge · opus 4.6      ← Idle (sẵn sàng nhận lệnh)
🟡 Q_Agents · opus 4.6           ← Busy (đang xử lý)
⚪ ios010-gps-camera              ← Unknown
```

Bấm vào session → hiện menu:

```
[💬 Chat]  [🗑 Close]
```

### 🖥️ Mac — Xem sessions trên terminal (tuỳ chọn)

```bash
# Xem tất cả ô tmux
tmux attach

# iTerm2 — mỗi ô thành 1 tab
tmux -CC attach
```

Phím tắt tmux:

| Phím | Chức năng |
|------|-----------|
| `Ctrl+B` rồi `o` | Chuyển ô tiếp theo |
| `Ctrl+B` rồi `q` rồi **số** | Nhảy đến ô theo số |
| `Ctrl+B` rồi `d` | Thoát (detach) — sessions vẫn chạy |
| `Ctrl+B` rồi `z` | Phóng to/thu nhỏ 1 ô |

> ⚠️ **KHÔNG** gõ `exit` hay `Ctrl+D` trong tmux — sẽ kill session.

---

## 4. Chat 2 chiều

### 📱 Telegram → Mac (gửi yêu cầu cho agent)

**Cách 1: Từ notification**

1. Agent gửi notification xong task
2. Bấm **💬 Chat**
3. Gõ yêu cầu mới → Gửi
4. ✅ Tin nhắn được inject vào agent

**Cách 2: Từ danh sách sessions**

1. Gõ `/sessions`
2. Chọn session
3. Bấm **💬 Chat**
4. Gõ yêu cầu → Gửi

### Trạng thái khi gửi tin

| Phản hồi Telegram | Ý nghĩa |
|---|---|
| ✅ Message sent to **project** | Gửi thành công, agent bắt đầu xử lý |
| ⏳ Queued (position X) | Agent đang busy, tin nhắn xếp hàng |
| ❌ Session not found | Session đã đóng, tạo cái mới |
| ⌨️ User is typing on desktop | Bạn đang gõ trên máy, bỏ qua |

### Cơ chế queue

- Tối đa **20 tin nhắn** chờ mỗi session
- Agent xong task → tự lấy tin tiếp theo trong queue
- Queue chỉ lưu trong RAM — restart ccpoke sẽ mất

---

## 5. Xử lý sự cố

### Không nhận notification trên Telegram

| Kiểm tra | Lệnh trên Mac |
|----------|---------------|
| ccpoke có đang chạy? | Xem terminal chạy `ccpoke` |
| Server có healthy? | `curl http://127.0.0.1:9377/health` |
| Hook có cài đúng? | `cat ~/.claude/settings.json \| grep Stop` |
| Chat ID có đăng ký? | `cat ~/.ccpoke/state.json` |

### Lỗi "query is too old"

```
ETELEGRAM: 400 Bad Request: query is too old...
```

→ **Bình thường.** Xảy ra khi restart ccpoke, các nút cũ trên Telegram hết hạn. Không ảnh hưởng gì.

### Sessions cũ không biến mất

```bash
# Xem sessions hiện tại
cat ~/.ccpoke/sessions.json

# Xóa tất cả sessions (ccpoke sẽ scan lại sau 15s)
echo '{"sessions":[]}' > ~/.ccpoke/sessions.json
```

Hoặc trên Telegram: `/sessions` → chọn session → **🗑 Close**.

### Agent không nhận tin nhắn từ Telegram

1. Kiểm tra agent có **đang chờ input** không: `tmux attach` → xem ô agent
2. Nếu agent đang busy → tin nhắn tự xếp queue
3. Nếu ô tmux trống/chết → tạo session mới từ `/projects`

---

## Tóm tắt nhanh

| Muốn làm gì | Ở đâu | Thao tác |
|---|---|---|
| Khởi động ccpoke | 🖥️ Mac | `ccpoke` |
| Đăng ký project | 🖥️ Mac | `ccpoke project` |
| Tạo session mới | 📱 Telegram | `/projects` → chọn |
| Xem sessions | 📱 Telegram | `/sessions` |
| Chat với agent | 📱 Telegram | Bấm 💬 Chat |
| Đóng session | 📱 Telegram | `/sessions` → 🗑 Close |
| Xem tmux trên máy | 🖥️ Mac | `tmux attach` |
| Thoát tmux (giữ sessions) | 🖥️ Mac | `Ctrl+B` rồi `d` |
| Kiểm tra health | 🖥️ Mac | `curl localhost:9377/health` |
| Reset sessions | 🖥️ Mac | Xóa `~/.ccpoke/sessions.json` |
