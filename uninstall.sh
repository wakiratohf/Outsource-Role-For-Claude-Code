#!/bin/bash

# ═══════════════════════════════════════════════════════════
#  SKILLS UNINSTALLER v2.0
#  Gỡ cài đặt tất cả custom skills
# ═══════════════════════════════════════════════════════════

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

TARGET_DIR="${1:-/mnt/skills/user}"

SKILLS=(
  "ba-role"
  "bug-fix-pipeline"
  "code-review-pipeline"
  "dev-role"
  "google-play-aso"
  "ops-role"
  "pm-role"
  "qa-qc-role"
)

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}  SKILLS UNINSTALLER v2.0${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  Target: ${BOLD}$TARGET_DIR${NC}"
echo ""

# Liệt kê skills sẽ bị gỡ
echo -e "  ${BOLD}Sẽ gỡ các skills sau:${NC}"
for SKILL in "${SKILLS[@]}"; do
  if [ -d "$TARGET_DIR/$SKILL" ]; then
    echo -e "    ${RED}✗${NC} $SKILL"
  else
    echo -e "    ${YELLOW}–${NC} $SKILL (không tồn tại)"
  fi
done

echo ""
echo -e "  ${RED}${BOLD}CẢNH BÁO: Thao tác này không thể hoàn tác!${NC}"
read -p "  Xác nhận gỡ cài đặt? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo -e "\n  ${YELLOW}Đã huỷ.${NC}"
  exit 0
fi

echo ""
REMOVED=0
for SKILL in "${SKILLS[@]}"; do
  if [ -d "$TARGET_DIR/$SKILL" ]; then
    rm -rf "$TARGET_DIR/$SKILL"
    echo -e "  ${RED}✗${NC} $SKILL — đã gỡ"
    REMOVED=$((REMOVED + 1))
  fi
done

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "  ${GREEN}✓${NC} Đã gỡ ${BOLD}${REMOVED}${NC} skills"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
