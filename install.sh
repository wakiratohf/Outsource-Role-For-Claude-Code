#!/bin/bash

# ═══════════════════════════════════════════════════════════
#  SKILLS INSTALLER v2.0
#  Cài đặt tất cả custom skills cho Claude Project
#  Ngày build: 2026-04-15
# ═══════════════════════════════════════════════════════════

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$SCRIPT_DIR/skills"
TARGET_DIR="${1:-/mnt/skills/user}"

# ─── Header ───
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}  SKILLS INSTALLER v2.0${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""

# ─── Danh sách skills ───
SKILLS=(
  "ba-role|Business Analyst / Solution Architect"
  "bug-fix-pipeline|Bug Fix Pipeline (Auto Accept v2)"
  "code-review-pipeline|Code Review Pipeline (Auto Accept v2)"
  "dev-role|Developer / Tech Lead / DevOps"
  "google-play-aso|Google Play ASO"
  "ops-role|Release Manager / SysAdmin / SRE"
  "pm-role|Project Manager / Scrum Master"
  "qa-qc-role|QA Lead / QC Engineer / Automation"
)

TOTAL=${#SKILLS[@]}
echo -e "${BOLD}  Tổng số skills: ${TOTAL}${NC}"
echo ""

# ─── Kiểm tra source ───
if [ ! -d "$SKILLS_SOURCE" ]; then
  echo -e "${RED}  ✗ Không tìm thấy thư mục skills/${NC}"
  echo -e "    Đảm bảo giải nén đúng cấu trúc và chạy từ thư mục gốc."
  exit 1
fi

# ─── Hiển thị danh sách ───
echo -e "${BOLD}  Danh sách skills:${NC}"
echo ""
IDX=1
for SKILL_ENTRY in "${SKILLS[@]}"; do
  IFS='|' read -r SKILL_NAME SKILL_DESC <<< "$SKILL_ENTRY"
  if [ -f "$SKILLS_SOURCE/$SKILL_NAME/SKILL.md" ]; then
    SIZE=$(wc -c < "$SKILLS_SOURCE/$SKILL_NAME/SKILL.md" | tr -d ' ')
    echo -e "  ${GREEN}[$IDX/$TOTAL]${NC} ${BOLD}$SKILL_NAME${NC}"
    echo -e "          $SKILL_DESC (${SIZE} bytes)"
  else
    echo -e "  ${RED}[$IDX/$TOTAL]${NC} ${BOLD}$SKILL_NAME${NC} — THIẾU FILE!"
  fi
  IDX=$((IDX + 1))
done

echo ""
echo -e "${CYAN}───────────────────────────────────────────────────────────${NC}"
echo -e "  Target: ${BOLD}$TARGET_DIR${NC}"
echo ""

# ─── Xác nhận ───
read -p "  Bắt đầu cài đặt? [Y/n] " CONFIRM
CONFIRM=${CONFIRM:-Y}
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo -e "\n  ${YELLOW}Đã huỷ.${NC}"
  exit 0
fi

echo ""

# ─── Cài đặt ───
INSTALLED=0
FAILED=0

for SKILL_ENTRY in "${SKILLS[@]}"; do
  IFS='|' read -r SKILL_NAME SKILL_DESC <<< "$SKILL_ENTRY"
  SOURCE_FILE="$SKILLS_SOURCE/$SKILL_NAME/SKILL.md"

  if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "  ${RED}✗${NC} $SKILL_NAME — file không tồn tại, bỏ qua"
    FAILED=$((FAILED + 1))
    continue
  fi

  # Tạo thư mục đích nếu chưa có
  mkdir -p "$TARGET_DIR/$SKILL_NAME"

  # Backup nếu đã tồn tại
  if [ -f "$TARGET_DIR/$SKILL_NAME/SKILL.md" ]; then
    cp "$TARGET_DIR/$SKILL_NAME/SKILL.md" "$TARGET_DIR/$SKILL_NAME/SKILL.md.bak"
    echo -e "  ${YELLOW}↻${NC} $SKILL_NAME — backup file cũ → SKILL.md.bak"
  fi

  # Copy skill
  cp "$SOURCE_FILE" "$TARGET_DIR/$SKILL_NAME/SKILL.md"
  echo -e "  ${GREEN}✓${NC} $SKILL_NAME — đã cài đặt"
  INSTALLED=$((INSTALLED + 1))
done

# ─── Kết quả ───
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
if [ $FAILED -eq 0 ]; then
  echo -e "  ${GREEN}✓ HOÀN TẤT${NC} — Đã cài đặt ${BOLD}${INSTALLED}/${TOTAL}${NC} skills"
else
  echo -e "  ${YELLOW}⚠ HOÀN TẤT${NC} — ${INSTALLED} thành công, ${RED}${FAILED} thất bại${NC}"
fi
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""

# ─── Verify ───
echo -e "  ${BOLD}Kiểm tra nhanh:${NC}"
for SKILL_ENTRY in "${SKILLS[@]}"; do
  IFS='|' read -r SKILL_NAME SKILL_DESC <<< "$SKILL_ENTRY"
  if [ -f "$TARGET_DIR/$SKILL_NAME/SKILL.md" ]; then
    LINES=$(wc -l < "$TARGET_DIR/$SKILL_NAME/SKILL.md" | tr -d ' ')
    echo -e "    ${GREEN}✓${NC} $SKILL_NAME ($LINES dòng)"
  else
    echo -e "    ${RED}✗${NC} $SKILL_NAME — không tìm thấy"
  fi
done

echo ""
echo -e "  ${BOLD}Cài đặt xong! Skills đã sẵn sàng sử dụng.${NC}"
echo ""
