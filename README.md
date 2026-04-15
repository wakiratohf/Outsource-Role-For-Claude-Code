# Skills Package v2.0

**Ngày build:** 2026-04-15

## Danh sách Skills (8)

| # | Skill | Mô tả |
|---|-------|--------|
| 1 | `ba-role` | Business Analyst, Solution Architect, System Analyst |
| 2 | `bug-fix-pipeline` | Pipeline xử lý bug 6 bước (v2 — Auto Accept) |
| 3 | `code-review-pipeline` | Pipeline review code 5 bước (v2 — Auto Accept) |
| 4 | `dev-role` | Tech Lead, Senior/Junior Dev, DevOps, DBA, Security |
| 5 | `google-play-aso` | App Store Optimization cho Google Play |
| 6 | `ops-role` | Release Manager, SysAdmin, SRE, Technical Support |
| 7 | `pm-role` | Project Manager, Scrum Master, Delivery Manager |
| 8 | `qa-qc-role` | QA Lead, QC Engineer, Automation, Performance Test |

## Cài đặt

### Cách 1 — Script tự động

```bash
chmod +x install.sh
./install.sh                           # Cài vào /mnt/skills/user (mặc định)
./install.sh /đường/dẫn/tuỳ/chỉnh     # Cài vào thư mục tuỳ chọn
```

### Cách 2 — Thủ công

Copy từng thư mục trong `skills/` vào nơi lưu skill của Claude Project.

## Gỡ cài đặt

```bash
chmod +x uninstall.sh
./uninstall.sh                         # Gỡ từ /mnt/skills/user (mặc định)
./uninstall.sh /đường/dẫn/tuỳ/chỉnh
```

## Changelog

- **v2.0** (2026-04-15): Thêm Auto Accept mode cho `bug-fix-pipeline` và `code-review-pipeline`
- **v1.0**: Bản gốc
