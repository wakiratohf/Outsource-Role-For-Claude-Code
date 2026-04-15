# Skills Package v2.4

**Ngày build:** 2026-04-15

## Danh sách Skills (9)

| # | Skill | Mô tả |
|---|-------|--------|
| 1 | `ba-role` | Business Analyst, Solution Architect, System Analyst |
| 2 | `bug-fix-pipeline` | Pipeline xử lý bug 6 bước (v2.4 — Discovery + Auto Accept) |
| 3 | `code-review-pipeline` | Pipeline review code 5 bước (v2.4 — Discovery + Auto Accept) |
| 4 | `dev-role` | Tech Lead, Senior/Junior Dev, DevOps, DBA, Security |
| 5 | `google-play-aso` | App Store Optimization cho Google Play |
| 6 | `ops-role` | Release Manager, SysAdmin, SRE, Technical Support |
| 7 | `pm-role` | Project Manager, Scrum Master, Delivery Manager |
| 8 | `qa-qc-role` | QA Lead, QC Engineer, Automation, Performance Test |
| 9 | `tech-lead-review` | Tech Lead Review — standalone verify giải pháp/code |

---

## Cài đặt

### Linux / macOS

```bash
chmod +x install.sh
./install.sh                        # → ~/.claude/skills/
./install.sh /đường/dẫn/tuỳ/chọn   # → thư mục tuỳ chọn
```

### Windows

```
install.bat                         # → %USERPROFILE%\.claude\skills\
install.bat C:\đường\dẫn\tuỳ\chọn  # → thư mục tuỳ chọn
```

Hoặc nhấp đúp (double-click) file `install.bat`.

### Claude.ai (Web) / Claude Desktop (UI)

Nếu cài qua giao diện thay vì CLI:
1. Vào **Settings → Customize → Skills → "+"**
2. Chọn **Upload skill**
3. Upload từng file `.zip` trong thư mục `zips/`
4. Mỗi skill là 1 file zip riêng

### Thư mục cài đặt mặc định

| Platform | Đường dẫn |
|----------|-----------|
| Linux / macOS | `~/.claude/skills/` |
| Windows | `%USERPROFILE%\.claude\skills\` |
| Custom (env var) | `$CLAUDE_CONFIG_DIR/skills/` |
| Project-level | `.claude/skills/` (trong repo) |

---

## Gỡ cài đặt

```bash
# Linux / macOS
chmod +x uninstall.sh
./uninstall.sh

# Windows
uninstall.bat
```

---

## Changelog

- **v2.4** (2026-04-15): Cross-platform (Windows + Linux/macOS), target `~/.claude/skills/`, thêm zip cho UI upload
- **v2.4** (2026-04-15): Thêm giai đoạn Discovery & Alignment cho `code-review-pipeline`, `bug-fix-pipeline`, `dev-role` — chuẩn đoán trước, code sau
- **v2.0** (2026-04-15): Thêm Auto Accept mode cho `bug-fix-pipeline` và `code-review-pipeline`
- **v1.0**: Bản gốc
