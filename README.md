# Claude Skills — Outsource Project Roles

Bộ skill mô phỏng toàn bộ quy trình phát triển phần mềm outsource
theo chuẩn FPT / CMMI / Agile.

## Cài đặt

```bash
# 1. Giải nén (nếu nhận dạng .zip)
unzip claude-skills.zip
cd claude-skills/

# 2. Cấp quyền chạy
chmod +x install.sh

# 3. Chạy installer
./install.sh
```

Sau khi cài xong, khởi động lại Claude để skills có hiệu lực.

---

## Danh sách skills

### Vai trò đơn lẻ

| Skill | Trigger | Mô tả |
|---|---|---|
| `pm-role` | "với tư cách PM..." | Project Manager, Scrum Master, PMO |
| `ba-role` | "viết requirement..." | Business Analyst, Solution Architect |
| `dev-role` | "với tư cách Tech Lead..." | Dev team, DevOps, DBA |
| `qa-qc-role` | "viết test case..." | QA/QC, Automation, Performance |
| `ops-role` | "kế hoạch go-live..." | Release Manager, SRE, Support |

### Pipeline tự động (orchestrator)

| Skill | Trigger | Mô tả |
|---|---|---|
| `bug-fix-pipeline` | "xử lý bug này..." | Triage → Root cause → Fix → Retest → Close |
| `code-review-pipeline` | "chạy pipeline cho code này..." | Self-review → CI/CD → Review → QC → Approve |

---

## Luồng kết hợp hai pipeline

```
Tester gửi bug report
        │
        ▼
  bug-fix-pipeline          ← "xử lý bug này: [bug report]"
  (6 bước tự động)
        │
        ▼ pipeline tự gợi ý
  code-review-pipeline      ← "chạy pipeline cho code fix này"
  (5 bước tự động)
        │
        ▼
  Sẵn sàng deploy production
```

---

## Cấu trúc thư mục sau cài đặt

```
~/.claude/
└── skills/
    ├── pm-role/
    │   └── SKILL.md
    ├── ba-role/
    │   └── SKILL.md
    ├── dev-role/
    │   └── SKILL.md
    ├── qa-qc-role/
    │   └── SKILL.md
    ├── ops-role/
    │   └── SKILL.md
    ├── code-review-pipeline/
    │   └── SKILL.md
    └── bug-fix-pipeline/
        └── SKILL.md
```
