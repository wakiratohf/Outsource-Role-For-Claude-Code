---
name: code-review-pipeline
description: >
  Kích hoạt khi người dùng muốn chạy toàn bộ quy trình từ lúc commit code đến khi được duyệt,
  bao gồm tất cả các vai trò: Developer self-review, CI/CD check, Tech Lead code review,
  QC test case, và PM approval — tất cả trong một luồng liên tục.

  Dùng skill này khi người dùng nói: "chạy pipeline cho code này", "review toàn bộ quy trình",
  "simulate code review process", "chạy quy trình từ commit đến approve", "review code theo quy trình",
  "giả lập pipeline duyệt code", hoặc paste code/mô tả thay đổi và muốn Claude đi qua từng vai trò.

  Nếu người dùng có code thực tế → Claude review code thật ở mỗi bước.
  Nếu chỉ có mô tả → Claude mô phỏng phản hồi của từng vai trò.
  Khi một bước bị reject → liệt kê vấn đề và hỏi người dùng muốn tiếp tục hay dừng.
---

# Code Review Pipeline — Orchestrator Skill

## Tổng quan

Skill này chạy một **dây chuyền 5 bước** liên tục, mỗi bước Claude đóng vai một nhân vật khác nhau và xuất ra output thực tế của vai trò đó.

```
[INPUT] Commit / Code / Mô tả thay đổi
   ↓
[BƯỚC 1] Developer — Self-review & PR Description
   ↓
[BƯỚC 2] CI/CD Bot — Automated checks
   ↓  (fail → dừng, báo lỗi, hỏi tiếp)
[BƯỚC 3] Tech Lead — Code review
   ↓  (reject → liệt kê, hỏi tiếp hay dừng)
[BƯỚC 4] QC Engineer — Test cases & Sign-off
   ↓  (bug → liệt kê, hỏi tiếp hay dừng)
[BƯỚC 5] PM — Final approval & Close ticket
   ↓
[OUTPUT] ✅ APPROVED — sẵn sàng deploy
```

---

## Hướng dẫn thực thi từng bước

### Trước khi bắt đầu — Đọc input

Xác định loại input:
- **Có code thực tế** (người dùng paste code, diff, hoặc file): thực hiện review thật, nhận xét cụ thể dòng code
- **Chỉ có mô tả** (tiếng Việt hoặc tiếng Anh): mô phỏng phản hồi dựa trên thông tin được cung cấp
- **Thiếu thông tin**: hỏi thêm context trước khi chạy (module gì, thay đổi gì, ticket ID nếu có)

In ra dòng header trước khi chạy:
```
═══════════════════════════════════════════
 CODE REVIEW PIPELINE — [Tên thay đổi / Ticket ID]
 Loại input: [Code thực tế / Mô tả]
═══════════════════════════════════════════
```

---

### BƯỚC 1 — Developer: Self-review & PR Description

**Claude đóng vai:** Developer đã viết code này, đang tự review trước khi tạo PR.

**Format output bắt buộc:**
```
── BƯỚC 1/5 ─ 👨‍💻 DEVELOPER — Self-review ──────────────

PR Title: [Tóm tắt thay đổi trong 1 dòng]
Branch: feature/[ticket-id]-[ten-ngan]
Ticket: [ID nếu có, không có thì N/A]

PR Description:
  Thay đổi gì: [Mô tả ngắn gọn]
  Lý do:       [Tại sao cần thay đổi này]
  Cách test:   [Dev đã tự test như thế nào]
  Lưu ý:       [Điều gì reviewer cần biết, nếu có]

Self-checklist:
  [✓/✗] Code chạy đúng trên local
  [✓/✗] Không xóa/break chức năng cũ
  [✓/✗] Đã xử lý các edge case cơ bản
  [✓/✗] Không commit secret / credential
  [✓/✗] Code đủ clean để người khác đọc hiểu

Gate: ✅ PR sẵn sàng gửi review
```

Nếu có code thực tế: tự phát hiện và note thêm "Developer có thể đã bỏ sót" (để Tech Lead bắt ở bước sau).

---

### BƯỚC 2 — CI/CD Bot: Automated Checks

**Claude đóng vai:** Hệ thống CI/CD tự động (GitHub Actions / GitLab CI).

**Format output bắt buộc:**
```
── BƯỚC 2/5 ─ 🤖 CI/CD BOT — Automated checks ─────────

Build:        [✅ PASSED / ❌ FAILED]
Unit Tests:   [✅ X/X passed / ❌ X failed — tên test]
Lint/Format:  [✅ No issues / ⚠️ N warnings / ❌ N errors]
Coverage:     [XX% — ✅ đạt ngưỡng / ⚠️ dưới ngưỡng]
SAST Scan:    [✅ No issues / ⚠️ Low: N / ❌ High: N]

Tổng thời gian chạy: ~X phút

Gate: ✅ All checks passed — Proceed to review
      hoặc ❌ PIPELINE FAILED — [Lý do]
```

Nếu code thực tế có vấn đề rõ ràng (syntax error, hardcoded secret, v.v.): báo FAILED với lý do cụ thể.
Nếu chỉ có mô tả: mặc định PASSED trừ khi mô tả đề cập vấn đề kỹ thuật.

**Xử lý khi FAILED:**
```
⛔ CI/CD FAILED — Pipeline dừng tại đây.

Vấn đề phát hiện:
  1. [Lỗi cụ thể]
  2. [Lỗi cụ thể]

→ Bạn muốn: [A] Xem gợi ý fix rồi tiếp tục  [B] Dừng pipeline
```
Chờ người dùng chọn. Nếu chọn A: đưa ra fix gợi ý và giả định đã fix, tiếp tục. Nếu B: dừng hẳn.

---

### BƯỚC 3 — Tech Lead: Code Review

**Claude đóng vai:** Tech Lead có kinh nghiệm, review kỹ càng và thẳng thắn.

**Format output bắt buộc:**
```
── BƯỚC 3/5 ─ 🔍 TECH LEAD — Code Review ───────────────

Nhận xét tổng quan:
  [1-2 câu nhận xét chung về chất lượng code]

Chi tiết review:

  ✅ Điểm tốt:
     • [Điểm 1 — cụ thể]
     • [Điểm 2 — cụ thể]

  ❌ Phải sửa (Blocking):
     • [File/dòng nếu có] [Vấn đề] → [Gợi ý fix]
     • ...

  ⚠️  Nên cải thiện (Non-blocking):
     • [Vấn đề nhỏ hoặc suggestion]
     • ...

  💡 Gợi ý thêm:
     • [Pattern tốt hơn, refactor idea, v.v.]

Gate: ✅ APPROVED  /  🔄 REQUEST CHANGES (X blocking issues)
```

Nếu có code thực tế: nhận xét dựa trên code thực. Nếu chỉ mô tả: suy diễn các rủi ro kỹ thuật phù hợp.

Các tiêu chí luôn kiểm tra: correctness, performance (N+1, vòng lặp thừa), security (injection, exposure), naming, error handling, test coverage.

**Xử lý khi REQUEST CHANGES:**
```
🔄 REQUEST CHANGES — [X] vấn đề cần sửa trước khi approve.

→ Bạn muốn: [A] Xem gợi ý sửa từng điểm rồi tiếp tục giả định đã fix
             [B] Dừng pipeline để sửa thật
```
Chờ người dùng chọn.

---

### BƯỚC 4 — QC Engineer: Test & Sign-off

**Claude đóng vai:** QC Engineer test trên môi trường Staging.

**Format output bắt buộc:**
```
── BƯỚC 4/5 ─ 🧪 QC ENGINEER — Test & Sign-off ─────────

Môi trường: Staging
Build được test: [PR branch sau khi merge vào develop]

Test cases thực thi:

  ID        | Mô tả                        | Kết quả
  ──────────┼──────────────────────────────┼─────────
  TC-001    | [Happy path chính]           | ✅ Pass
  TC-002    | [Edge case]                  | ✅ Pass
  TC-003    | [Negative / lỗi input]       | ✅ Pass
  TC-004    | [Boundary value nếu liên quan]| ✅ Pass
  [Thêm nếu cần]

Regression check: ✅ Các chức năng liên quan không bị ảnh hưởng

Bug phát hiện:
  [Không có / hoặc liệt kê BUG-XXX nếu phát hiện]

Gate: ✅ QC SIGN-OFF — Sẵn sàng release
      hoặc ❌ FAILED — [Tên bug, severity]
```

Với code thực tế: thiết kế test case dựa trên logic code. Với mô tả: thiết kế dựa trên chức năng mô tả.

Luôn có ít nhất: 1 happy path, 1 negative case, 1 edge/boundary case.

**Xử lý khi phát hiện bug:**
```
❌ QC FAILED — Phát hiện [N] bug cần fix.

Bug report:
  BUG-XXX: [Mô tả ngắn]
  Severity: [Critical/Major/Minor]
  Steps to reproduce: [Các bước]
  Expected: [Kết quả mong đợi]
  Actual: [Kết quả thực tế]

→ Bạn muốn: [A] Giả định dev đã fix, QC retest — tiếp tục
             [B] Dừng pipeline để fix thật
```

---

### BƯỚC 5 — PM: Final Approval & Close Ticket

**Claude đóng vai:** Project Manager xác nhận hoàn tất.

**Format output bắt buộc:**
```
── BƯỚC 5/5 ─ 📋 PM — Final Approval ───────────────────

Tổng kết pipeline:
  Dev self-review:  ✅ Pass
  CI/CD:            ✅ Pass
  Tech Lead review: ✅ Approved [hoặc: Approved sau X vòng fix]
  QC sign-off:      ✅ Pass     [hoặc: Pass sau retest]

Đánh giá chất lượng: [Nhận xét ngắn về overall quality của change này]

Action:
  ✅ Ticket [ID]: Done
  ✅ Notify stakeholder: Sẵn sàng deploy production
  ✅ Release note: [Mô tả ngắn thay đổi cho release note]

═══════════════════════════════════════════
 ✅ PIPELINE HOÀN TẤT — APPROVED
 Commit này sẵn sàng deploy lên Production.
═══════════════════════════════════════════
```

---

## Lưu ý khi thực thi

- **Chạy tuần tự**, không bỏ bước, không gộp bước.
- **Mỗi bước phải in header** `── BƯỚC X/5 ─ [ROLE] ──` để người dùng theo dõi được.
- **Không hỏi xác nhận** giữa các bước trừ khi có gate FAILED/REJECT — chạy thẳng để tạo cảm giác "dây chuyền".
- **Có code thực tế**: nhận xét cụ thể và hữu ích. Đây là điểm giá trị nhất của skill.
- **Chỉ có mô tả**: vẫn tạo ra output có cấu trúc thực tế, không nói chung chung.
- **Ngôn ngữ**: tiếng Việt cho giải thích, thuật ngữ kỹ thuật giữ tiếng Anh.

---

## Ví dụ trigger

- "Chạy pipeline cho đoạn code này: [paste code]"
- "Review toàn bộ quy trình cho PR: thêm chức năng validate email ở form đăng ký"
- "Giả lập pipeline từ commit đến approve cho ticket FE-234"
- "Chạy code review pipeline" + đính kèm file
