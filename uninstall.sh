#!/bin/bash

# ═══════════════════════════════════════════════════════════
#  SKILLS UNINSTALLER v2.1 — Linux / macOS
# ═══════════════════════════════════════════════════════════

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

if [ -n "$1" ]; then
  TARGET_DIR="$1"
else
  CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  TARGET_DIR="$CLAUDE_HOME/skills"
fi

SKILLS=("ba-role" "bug-fix-pipeline" "code-review-pipeline" "dev-role" "google-play-aso" "ops-role" "pm-role" "qa-qc-role")

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}  SKILLS UNINSTALLER v2.1 — Linux / macOS${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  Target: ${BOLD}$TARGET_DIR${NC}"
echo ""

echo -e "  ${BOLD}Sẽ gỡ:${NC}"
for SKILL in "${SKILLS[@]}"; do
  [ -d "$TARGET_DIR/$SKILL" ] \
    && echo -e "    ${RED}✗${NC} $SKILL" \
    || echo -e "    ${YELLOW}–${NC} $SKILL (không tồn tại)"
done

echo ""
echo -e "  ${RED}${BOLD}CẢNH BÁO: Không thể hoàn tác!${NC}"
read -p "  Xác nhận gỡ? [y/N] " CONFIRM
[[ ! "$CONFIRM" =~ ^[Yy]$ ]] && echo -e "\n  ${YELLOW}Đã huỷ.${NC}" && exit 0

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
