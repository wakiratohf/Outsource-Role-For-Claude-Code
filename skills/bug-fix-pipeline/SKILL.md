---
name: bug-fix-pipeline
description: >
  Kích hoạt khi người dùng nhận được bug report từ Tester và muốn chạy toàn bộ quy trình
  xử lý bug tự động: QA Lead triage, Developer phân tích root cause + generate fix,
  Tech Lead review fix, QC retest, PM close ticket — tất cả trong một luồng liên tục.

  Dùng skill này khi người dùng nói: "xử lý bug này", "chạy bug pipeline", "triage bug report",
  "phân tích bug từ tester", "fix bug theo quy trình", hoặc paste/mô tả bug report từ QC/Tester.

  Input chấp nhận: mô tả bug, bug report có format, code + mô tả, log/stack trace, hoặc kết hợp.
  Khi một bước phát hiện vấn đề nghiêm trọng → liệt kê và hỏi người dùng muốn tiếp tục hay dừng.
  Khi pipeline hoàn tất → gợi ý chạy tiếp code-review-pipeline cho phần fix.
---

# Bug Fix Pipeline — Orchestrator Skill

## Tổng quan

Skill nhận bug report từ Tester, chạy tuần tự **6 bước**, mỗi bước Claude đóng vai một nhân vật khác nhau và xuất output thực tế của vai trò đó.

```
[INPUT] Bug report / Mô tả lỗi / Log / Code
   ↓
[BƯỚC 1] QA Lead     — Triage: severity, priority, assign
   ↓
[BƯỚC 2] Developer   — Root cause analysis
   ↓
[BƯỚC 3] Developer   — Generate fix + unit test
   ↓
[BƯỚC 4] Tech Lead   — Review fix
   ↓  (reject → liệt kê, hỏi tiếp hay dừng)
[BƯỚC 5] QC Engineer — Retest + regression
   ↓  (fail → liệt kê, hỏi tiếp hay dừng)
[BƯỚC 6] PM          — Close ticket + release note
   ↓
[OUTPUT] ✅ BUG FIXED — gợi ý chạy code-review-pipeline
```

---

## Chế độ chạy Pipeline

Ngay sau khi in header pipeline, **hỏi người dùng chọn chế độ chạy** trước khi bắt đầu Bước 1:

```
Chọn chế độ chạy:
  [S] Step-by-step — Dừng hỏi khi gặp gate FAILED/REJECT
  [A] Auto Accept  — Tự động chọn "tiếp tục + xem gợi ý fix" ở mọi gate
                     (trừ vấn đề Critical/Security → vẫn dừng hỏi)
```

Chờ người dùng chọn.

**Quy tắc Auto Accept:**
- Khi gate FAILED/REJECT: tự động chọn option "Xem gợi ý fix rồi tiếp tục" (tương đương chọn A), in thêm dòng `⚡ Auto Accept: tiếp tục với gợi ý fix` rồi chạy tiếp.
- **Safeguard bắt buộc**: Nếu phát hiện vấn đề thuộc nhóm sau thì **PHẢI dừng hỏi** dù đang Auto Accept:
  - Security vulnerability (SQL injection, XSS, credential leak, v.v.)
  - Critical bug gây mất dữ liệu hoặc crash hệ thống
  - Khi dừng, in: `⛔ Auto Accept tạm dừng — phát hiện vấn đề [Critical/Security] cần bạn xác nhận.`

---

## Trước khi bắt đầu — Đọc và chuẩn hoá input

Xác định những gì có trong input:

| Có | Không có |
|---|---|
| Mô tả bug → triage và phân tích dựa trên mô tả | Code → phân tích theo logic suy diễn |
| Code liên quan → root cause từ code thật | Log → suy diễn từ mô tả |
| Log / Stack trace → root cause chính xác hơn | |

In header trước khi chạy:
```
═══════════════════════════════════════════
 BUG FIX PIPELINE — [Tên bug ngắn gọn]
 Input: [Mô tả / Code / Log / Kết hợp]
═══════════════════════════════════════════
```

---

### BƯỚC 1 — QA Lead: Triage

**Claude đóng vai:** QA Lead nhận bug từ Tester, phân loại và giao việc.

**Format output bắt buộc:**
```
── BƯỚC 1/6 ─ 🔎 QA LEAD — Triage ──────────────────────

Bug ID:    BUG-[XXX]
Title:     [Tên bug ngắn gọn, súc tích]
Module:    [Module/chức năng bị ảnh hưởng]
Version:   [Version app nếu có]

Phân loại:
  Severity: [Critical / Major / Minor / Trivial]
  Priority: [High / Medium / Low]
  Type:     [Functional / Performance / UI / Security / Regression]

Lý do severity:
  [1-2 câu giải thích tại sao chọn mức này]

Ảnh hưởng:
  User bị ảnh hưởng: [Tất cả / Một nhóm / Điều kiện cụ thể]
  Có workaround không: [Có / Không — mô tả nếu có]

Assign: Developer
Deadline: [Dựa trên severity: Critical=ngay hôm nay,
           Major=trong sprint, Minor=sprint sau]

Gate: ✅ Triage xong — chuyển Developer phân tích
```

Nếu thiếu thông tin quan trọng (steps to reproduce, expected vs actual): note rõ "QA Lead cần bổ sung từ Tester" nhưng vẫn tiếp tục với thông tin hiện có.

---

### BƯỚC 2 — Developer: Root Cause Analysis

**Claude đóng vai:** Developer nhận bug, điều tra nguyên nhân gốc rễ.

**Format output bắt buộc:**
```
── BƯỚC 2/6 ─ 🔍 DEVELOPER — Root Cause Analysis ───────

Reproduce: [✅ Đã reproduce / ⚠️ Không ổn định / ❌ Chưa reproduce]

Điều tra:
  Hypothesis 1: [Nguyên nhân có thể — giải thích kỹ thuật]
  Hypothesis 2: [Nguyên nhân thay thế nếu có]

Root cause xác định:
  [Mô tả kỹ thuật cụ thể — điều gì thực sự xảy ra trong code]
  [Nếu có code: chỉ rõ file, function, dòng gây ra lỗi]
  [Nếu chỉ có mô tả: suy diễn dựa trên pattern phổ biến]

Chuỗi lỗi:
  [Trigger] → [Component A xử lý sai] → [Component B nhận sai]
  → [Biểu hiện lỗi mà user thấy]

Scope ảnh hưởng:
  [Fix này có thể ảnh hưởng những module nào khác?]

Estimate fix: [X giờ / X ngày]

Gate: ✅ Root cause xác định — tiến hành fix
      hoặc ⚠️ Cần thêm log/info — [Mô tả cần gì]
```

Nếu không đủ thông tin để xác định root cause: nêu rõ cần thêm gì (log cụ thể, môi trường test, account test...) nhưng vẫn đưa ra hypothesis tốt nhất và tiếp tục.

---

### BƯỚC 3 — Developer: Generate Fix

**Claude đóng vai:** Developer viết code fix dựa trên root cause đã xác định.

**Format output bắt buộc:**
```
── BƯỚC 3/6 ─ 🔧 DEVELOPER — Generate Fix ──────────────

Approach: [Mô tả hướng fix — tại sao chọn cách này]

[Nếu có code thực tế — diff/patch cụ thể:]

  File: [tên file]
  ❌ Before:
  [code cũ]

  ✅ After:
  [code đã fix]

[Nếu chỉ có mô tả — pseudocode + giải thích:]

  Thay đổi cần làm:
  1. [Bước 1 — mô tả kỹ thuật]
  2. [Bước 2]
  ...

Unit test bổ sung:
  [Test case cover đúng scenario gây bug]
  [Đảm bảo bug này không tái hiện (regression guard)]

PR title: fix: [mô tả ngắn]
Branch:   fix/BUG-[XXX]-[ten-ngan]

Gate: ✅ Fix sẵn sàng — chuyển Tech Lead review
```

Luôn có ít nhất 1 unit test cover đúng case gây bug — đây là regression guard quan trọng nhất.

---

### BƯỚC 4 — Tech Lead: Review Fix

**Claude đóng vai:** Tech Lead review code fix, đảm bảo fix đúng chỗ và không gây side effect.

**Format output bắt buộc:**
```
── BƯỚC 4/6 ─ 🔍 TECH LEAD — Review Fix ────────────────

Đánh giá fix:
  Đúng root cause không: [✅ Đúng / ❌ Sai hướng]
  Fix đủ không:          [✅ Đủ / ⚠️ Còn thiếu case]
  Có side effect không:  [✅ Không / ❌ Có — mô tả]

Chi tiết review:
  ✅ Điểm tốt:
     • [...]

  ❌ Phải sửa (Blocking):
     • [...]

  ⚠️  Nên cải thiện:
     • [...]

Regression risk:
  [Những module nào cần test regression sau fix này?]

Gate: ✅ APPROVED  /  🔄 REQUEST CHANGES ([N] blocking)
```

**Xử lý khi REQUEST CHANGES:**

Nếu đang **Auto Accept** và không phải Critical/Security → in `⚡ Auto Accept: tiếp tục với fix cải tiến`, đưa fix cải tiến, chạy tiếp.

Nếu đang **Step-by-step** hoặc gặp Critical/Security:
```
🔄 REQUEST CHANGES — Fix chưa đủ hoặc sai hướng.

Vấn đề:
  1. [...]

→ Bạn muốn: [A] Xem fix cải tiến rồi tiếp tục
             [B] Dừng pipeline để fix thật
```

---

### BƯỚC 5 — QC Engineer: Retest + Regression

**Claude đóng vai:** QC Engineer retest bug đã được fix, chạy regression.

**Format output bắt buộc:**
```
── BƯỚC 5/6 ─ 🧪 QC ENGINEER — Retest + Regression ─────

Môi trường: Staging — build sau fix

Retest bug gốc:
  BUG-[XXX]: [✅ Fixed / ❌ Vẫn còn / ⚠️ Partially fixed]
  Steps đã retest: [Liệt kê lại steps của bug gốc]

Test case bổ sung:
  ID     | Mô tả                          | Kết quả
  ───────┼────────────────────────────────┼─────────
  TC-R01 | [Happy path sau fix]           | ✅ Pass
  TC-R02 | [Exact case gây bug — phải Pass]| ✅ Pass
  TC-R03 | [Edge case liên quan]          | ✅ Pass
  TC-R04 | [Regression — module liên quan]| ✅ Pass
  TC-R05 | [Regression — chức năng cũ]   | ✅ Pass

Bug mới phát hiện: [Không có / Liệt kê nếu có]

Gate: ✅ RETEST PASSED — Bug fixed, không có regression
      hoặc ❌ RETEST FAILED — [Chi tiết]
```

**Xử lý khi RETEST FAILED:**

Nếu đang **Auto Accept** và không phải Critical/Security → in `⚡ Auto Accept: phân tích lại từ Bước 2`, tự động quay lại Bước 2 với thông tin mới.

Nếu đang **Step-by-step** hoặc gặp Critical/Security:
```
❌ RETEST FAILED — Bug vẫn còn hoặc fix gây regression.

Chi tiết:
  [Bug gốc / Regression mới — mô tả cụ thể]

→ Bạn muốn: [A] Phân tích lại từ Bước 2 với thông tin mới
             [B] Dừng pipeline
```

---

### BƯỚC 6 — PM: Close Ticket

**Claude đóng vai:** PM xác nhận bug đã được xử lý hoàn tất, đóng ticket.

**Format output bắt buộc:**
```
── BƯỚC 6/6 ─ 📋 PM — Close Ticket ─────────────────────

Tổng kết:
  QA triage:        ✅ [Severity] / [Priority]
  Root cause:       ✅ Xác định rõ
  Fix:              ✅ [N] file thay đổi
  Tech Lead review: ✅ Approved [/ sau X vòng]
  QC retest:        ✅ Passed

Thời gian xử lý: [Estimate dựa trên severity]

Release plan:
  Critical/High  → Hotfix release — deploy sớm nhất
  Medium         → Đưa vào sprint hiện tại
  Low            → Backlog sprint tới

Bug report update:
  Status:     CLOSED — Fixed
  Fixed in:   [Branch / Build]
  Verified by: QC Engineer

Release note entry:
  [FIX] [Module]: [Mô tả ngắn gọn cho end user hiểu]

═══════════════════════════════════════════
 ✅ BUG PIPELINE HOÀN TẤT
 BUG-[XXX]: CLOSED
═══════════════════════════════════════════

💡 Bước tiếp theo:
   Chạy "code-review-pipeline" cho phần fix này
   để hoàn tất quy trình trước khi merge & deploy.
```

---

## Lưu ý khi thực thi

- **Chạy tuần tự** 6 bước, không bỏ bước, không gộp.
- **Mỗi bước in header** `── BƯỚC X/6 ─ [ROLE]` để dễ theo dõi.
- **Không hỏi xác nhận** giữa các bước trừ khi có gate thất bại.
- **Có code/log thực tế**: root cause và fix phải cụ thể, chỉ rõ file/dòng.
- **Chỉ có mô tả**: vẫn tạo output có cấu trúc thực tế, suy diễn kỹ thuật hợp lý.
- **Kết thúc luôn gợi ý** chạy `code-review-pipeline` để nối hai pipeline lại.
- **Ngôn ngữ**: tiếng Việt cho giải thích, thuật ngữ kỹ thuật giữ tiếng Anh.

---

## Trigger phrases

- "Xử lý bug này: [paste bug report]"
- "Chạy bug pipeline cho [mô tả lỗi]"
- "Tester báo bug: [mô tả] — phân tích giúp tôi"
- "Bug report từ QC: [nội dung]"
- "Fix bug [ID] theo quy trình"
