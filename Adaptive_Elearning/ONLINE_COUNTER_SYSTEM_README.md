# Hệ thống đếm người dùng Online - Real-time

## Tổng quan
Hệ thống đếm số người dùng đang hoạt động trên website theo thời gian thực với các tính năng:
- ✅ Tự động +1 khi user truy cập
- ✅ Tự động -1 khi user logout, đóng browser, hoặc hết session
- ✅ Cập nhật số liệu mỗi 5 giây (real-time)
- ✅ Heartbeat giữ session khi user đang active
- ✅ Phát hiện user rời khỏi trang (beforeunload)

## Cấu hình

### 1. Session Timeout
**File:** `src/main/webapp/WEB-INF/web.xml`
```xml
<session-config>
    <session-timeout>2</session-timeout>
</session-config>
```
- **Timeout:** 2 phút (120 giây)
- User không hoạt động trong 2 phút → Session hết hạn → Counter -1

### 2. Components

#### A. SessionCounterListener
**File:** `src/main/java/listener/SessionCounterListener.java`
- **Chức năng:** Đếm session được tạo/hủy
- **Thread-safe:** Sử dụng `AtomicInteger`
- **Events:**
  - `sessionCreated()` → Counter +1
  - `sessionDestroyed()` → Counter -1
  
**Log Format:**
```
✅ NEW USER CONNECTED | Online: 5 | Session: ABC123...
❌ USER DISCONNECTED (Browser Closed/Tab Closed) | Online: 4 | Session: ABC123...
❌ USER DISCONNECTED (Session Timeout/Logout) | Online: 3 | Session: DEF456...
```

#### B. OnlineCountApiServlet
**File:** `src/main/java/servlet/OnlineCountApiServlet.java`
**Endpoints:**

1. **GET `/api/online-count`** - Lấy số người online
   ```json
   {
     "count": 5,
     "timestamp": 1730678400000
   }
   ```

2. **POST `/api/heartbeat`** - Giữ session alive
   - Gửi từ browser mỗi 60 giây nếu user active
   - Response:
   ```json
   {
     "status": "ok",
     "sessionId": "ABC123..."
   }
   ```

3. **POST `/api/user-leaving`** - User đóng browser/tab
   - Gửi qua `navigator.sendBeacon()` khi `beforeunload`
   - Đặt session timeout = 10 giây để nhanh chóng cleanup

#### C. Footer Component
**File:** `src/main/webapp/WEB-INF/includes/footer.jsp`
**JavaScript Functions:**

1. **Activity Tracking:**
   - Lắng nghe: `mousemove`, `keypress`, `click`, `scroll`
   - Đánh dấu user active/inactive

2. **Heartbeat (60s):**
   ```javascript
   setInterval(() => {
       if (isUserActive) {
           fetch('/api/heartbeat', { method: 'POST' });
       }
   }, 60000);
   ```
   - Chỉ gửi khi user active trong 90 giây gần nhất

3. **Counter Update (5s):**
   ```javascript
   setInterval(() => {
       fetch('/api/online-count')
           .then(response => response.json())
           .then(data => {
               document.querySelector('.online-count').textContent = data.count;
           });
   }, 5000);
   ```
   - Cập nhật số liệu mỗi 5 giây
   - Animation khi số thay đổi

4. **Beforeunload Event:**
   ```javascript
   window.addEventListener('beforeunload', () => {
       navigator.sendBeacon('/api/user-leaving');
   });
   ```
   - Phát hiện khi user đóng tab/browser
   - `sendBeacon()` đảm bảo request được gửi

## Workflow

### Khi user truy cập:
```
1. Browser → Server (GET /home)
2. Server tạo new HttpSession
3. SessionCounterListener.sessionCreated() được trigger
4. AtomicInteger.incrementAndGet() → Counter +1
5. Footer hiển thị: "X người đang online"
6. JavaScript bắt đầu heartbeat timer
```

### Khi user đang hoạt động:
```
Mỗi 60 giây:
1. JavaScript kiểm tra lastActivityTime
2. Nếu user active (< 90s không hoạt động):
   → Gửi POST /api/heartbeat
3. Server refresh session lastAccessedTime
4. Session không bị timeout

Mỗi 5 giây:
1. JavaScript gửi GET /api/online-count
2. Server trả về count hiện tại
3. Footer cập nhật số liệu + animation
```

### Khi user đóng browser/tab:
```
1. Browser trigger 'beforeunload' event
2. JavaScript gửi navigator.sendBeacon('/api/user-leaving')
3. Server đặt session.setMaxInactiveInterval(10)
4. Sau 10 giây:
   → SessionCounterListener.sessionDestroyed()
   → Counter -1
   → Log: "USER DISCONNECTED (Browser Closed/Tab Closed)"
```

### Khi user logout:
```
1. User click Logout
2. POST /logout
3. LogoutServlet: session.invalidate()
4. SessionCounterListener.sessionDestroyed()
5. Counter -1
6. Log: "USER DISCONNECTED (Session Timeout/Logout)"
7. Redirect → /home?logout=success
```

### Khi session timeout (2 phút không hoạt động):
```
1. User không tương tác trong 2 phút
2. Không có heartbeat được gửi
3. Server tự động invalidate session
4. SessionCounterListener.sessionDestroyed()
5. Counter -1
6. Log: "USER DISCONNECTED (Session Timeout/Logout)"
```

## Testing

### Test 1: Multiple Users
```
1. Mở browser 1 → Truy cập /home → Xem counter = 1
2. Mở browser 2 → Truy cập /home → Xem counter = 2
3. Mở browser 3 → Truy cập /home → Xem counter = 3
4. Đóng browser 1 → Đợi 15s → Counter = 2
5. Đóng browser 2 → Đợi 15s → Counter = 1
```

### Test 2: Active vs Inactive
```
1. Mở /home → Counter = 1
2. Giữ tab active (di chuyển chuột) → Heartbeat gửi mỗi 60s
3. Để yên không tương tác 2 phút → Session timeout → Counter = 0
4. Mở lại /home → Counter = 1
```

### Test 3: Logout
```
1. Mở /home → Login → Counter = 1
2. Click Logout → Counter = 0 (ngay lập tức)
3. Check server log: "USER DISCONNECTED (Session Timeout/Logout)"
```

### Test 4: Real-time Update
```
1. User A mở /home → Counter hiển thị = 1
2. User B mở /home → Counter của A tự động cập nhật = 2 (sau 5s)
3. User B đóng browser → Counter của A cập nhật = 1 (sau 15s)
```

## Server Logs

### Successful Connection
```
INFO: ✅ NEW USER CONNECTED | Online: 5 | Session: 3F2A1B9C...
FINE: Heartbeat received for session: 3F2A1B9C...
FINE: Heartbeat received for session: 3F2A1B9C...
```

### Browser Closed
```
INFO: User leaving detected for session: 3F2A1B9C...
INFO: ❌ USER DISCONNECTED (Browser Closed/Tab Closed) | Online: 4 | Session: 3F2A1B9C...
```

### Logout
```
INFO: User logout: john_doe (Session: 3F2A1B9C...)
INFO: Session invalidated successfully for user: john_doe
INFO: ❌ USER DISCONNECTED (Session Timeout/Logout) | Online: 3 | Session: 3F2A1B9C...
```

## Troubleshooting

### Counter không giảm khi đóng browser
**Nguyên nhân:** Browser không trigger `beforeunload` event
**Giải pháp:** Session sẽ tự timeout sau 2 phút

### Counter tăng quá nhanh
**Nguyên nhân:** Mỗi tab mới = 1 session mới
**Giải pháp:** Đây là behavior đúng, mỗi tab = 1 user online

### Heartbeat không hoạt động
**Kiểm tra:**
1. F12 Developer Console → Network tab
2. Tìm request `/api/heartbeat` mỗi 60s
3. Check response status = 200

### Counter không cập nhật real-time
**Kiểm tra:**
1. F12 Console → Check error messages
2. Verify `/api/online-count` request mỗi 5s
3. Check CORS/network issues

## Performance

### Tài nguyên sử dụng:
- **Memory:** ~100 bytes per session (AtomicInteger + session tracking)
- **CPU:** Minimal (chỉ increment/decrement operations)
- **Network:** 
  - Heartbeat: ~200 bytes/60s per user
  - Counter update: ~100 bytes/5s per user

### Scalability:
- **1,000 users:** ~3.3 KB/s network traffic
- **10,000 users:** ~33 KB/s network traffic
- Thread-safe với `AtomicInteger` → No locking issues

## Security Notes

1. **Session Hijacking Prevention:**
   - Session ID trong cookie (HttpOnly, Secure)
   - Server-side session validation

2. **DDoS Protection:**
   - Rate limiting có thể thêm vào `/api/heartbeat`
   - Session timeout ngăn zombie sessions

3. **Privacy:**
   - Chỉ đếm số lượng, không track user info
   - Không lưu IP/browser fingerprint

## Tùy chỉnh

### Thay đổi Session Timeout
**File:** `web.xml`
```xml
<session-timeout>5</session-timeout> <!-- 5 phút -->
```

### Thay đổi Heartbeat Interval
**File:** `footer.jsp`
```javascript
}, 30000); // 30 giây thay vì 60 giây
```

### Thay đổi Counter Update Frequency
**File:** `footer.jsp`
```javascript
}, 10000); // 10 giây thay vì 5 giây
```

### Thêm Counter vào trang khác
Thêm vào cuối file `.jsp`:
```jsp
<%@ include file="/WEB-INF/includes/footer.jsp" %>
```

## Tích hợp hiện tại

Footer đã được thêm vào:
- ✅ `home.jsp`
- ✅ `about.jsp`
- ✅ `contact.jsp`

Để thêm vào trang khác, copy dòng include vào cuối file trước `</body>`.
