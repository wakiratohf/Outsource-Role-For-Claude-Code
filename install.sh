#!/bin/bash
# ═══════════════════════════════════════════════════
#  Claude Skills Installer
#  Cài tất cả skill vào ~/.claude/skills/
# ═══════════════════════════════════════════════════

set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skills"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}  Claude Skills Installer${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

# Kiểm tra source
if [ ! -d "$SOURCE_DIR" ]; then
  echo -e "${RED}❌ Không tìm thấy thư mục skills/ bên cạnh install.sh${NC}"
  exit 1
fi

# Tạo thư mục nếu chưa có
echo -e "📁 Tạo thư mục ${SKILLS_DIR} ..."
mkdir -p "$SKILLS_DIR"

# Danh sách skills
SKILLS=(
  "pm-role"
  "ba-role"
  "dev-role"
  "qa-qc-role"
  "ops-role"
  "code-review-pipeline"
  "bug-fix-pipeline"
)

echo ""
echo "📦 Cài đặt skills:"
echo ""

INSTALLED=0
SKIPPED=0

for skill in "${SKILLS[@]}"; do
  SRC="$SOURCE_DIR/$skill/SKILL.md"
  DEST_DIR="$SKILLS_DIR/$skill"
  DEST="$DEST_DIR/SKILL.md"

  if [ ! -f "$SRC" ]; then
    echo -e "  ${YELLOW}⚠️  $skill — không tìm thấy SKILL.md, bỏ qua${NC}"
    ((SKIPPED++))
    continue
  fi

  # Backup nếu đã tồn tại
  if [ -f "$DEST" ]; then
    cp "$DEST" "$DEST.bak"
    echo -e "  ${YELLOW}↩️  $skill — đã backup bản cũ → SKILL.md.bak${NC}"
  fi

  mkdir -p "$DEST_DIR"
  cp "$SRC" "$DEST"
  echo -e "  ${GREEN}✅ $skill${NC}"
  ((INSTALLED++))
done

echo ""
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "  ✅ Đã cài: ${GREEN}$INSTALLED skill${NC}"
if [ $SKIPPED -gt 0 ]; then
  echo -e "  ⚠️  Bỏ qua: ${YELLOW}$SKIPPED skill${NC}"
fi
echo ""
echo -e "  📂 Vị trí: ${SKILLS_DIR}/"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

# Hiển thị cấu trúc đã cài
echo "Cấu trúc thư mục sau khi cài:"
echo ""
echo "  ~/.claude/"
echo "  └── skills/"
for skill in "${SKILLS[@]}"; do
  if [ -f "$SKILLS_DIR/$skill/SKILL.md" ]; then
    echo -e "      ├── ${GREEN}$skill/${NC}"
    echo "      │   └── SKILL.md"
  fi
done
echo ""
echo -e "${GREEN}🎉 Hoàn tất! Khởi động lại Claude để skills có hiệu lực.${NC}"
echo ""
