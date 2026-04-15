#!/bin/bash

# ═══════════════════════════════════════════════════════════
#  SKILLS INSTALLER v2.3
#  Cài đặt custom skills cho Claude Code / Claude Desktop
#  Target: ~/.claude/skills/
#  Ngày build: 2026-04-15
# ═══════════════════════════════════════════════════════════

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$SCRIPT_DIR/skills"

if [ -n "$1" ]; then
  TARGET_DIR="$1"
else
  CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  TARGET_DIR="$CLAUDE_HOME/skills"
fi

SKILLS=(
  "ba-role|Business Analyst / Solution Architect"
  "bug-fix-pipeline|Bug Fix Pipeline (Auto Accept v2)"
  "code-review-pipeline|Code Review Pipeline (Auto Accept v2)"
  "dev-role|Developer / Tech Lead / DevOps"
  "google-play-aso|Google Play ASO"
  "ops-role|Release Manager / SysAdmin / SRE"
  "pm-role|Project Manager / Scrum Master"
  "qa-qc-role|QA Lead / QC Engineer / Automation"
  "tech-lead-review|Tech Lead Review (standalone verify)"
)
TOTAL=${#SKILLS[@]}

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}  SKILLS INSTALLER v2.3 — Linux / macOS${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  Skills:  ${BOLD}${TOTAL}${NC} skills"
echo -e "  Target:  ${BOLD}${TARGET_DIR}${NC}"
echo ""

if [ ! -d "$SKILLS_SOURCE" ]; then
  echo -e "  ${RED}✗ Không tìm thấy thư mục skills/${NC}"
  echo -e "    Hãy chạy script từ thư mục đã giải nén."
  exit 1
fi

echo -e "  ${BOLD}Danh sách:${NC}"
IDX=1
for ENTRY in "${SKILLS[@]}"; do
  IFS='|' read -r NAME DESC <<< "$ENTRY"
  if [ -f "$SKILLS_SOURCE/$NAME/SKILL.md" ]; then
    SIZE=$(wc -c < "$SKILLS_SOURCE/$NAME/SKILL.md" | tr -d ' ')
    echo -e "    ${GREEN}[$IDX/$TOTAL]${NC} ${BOLD}$NAME${NC} — $DESC (${SIZE}B)"
  else
    echo -e "    ${RED}[$IDX/$TOTAL]${NC} ${BOLD}$NAME${NC} — THIẾU FILE!"
  fi
  IDX=$((IDX + 1))
done

echo ""
read -p "  Bắt đầu cài đặt? [Y/n] " CONFIRM
CONFIRM=${CONFIRM:-Y}
[[ ! "$CONFIRM" =~ ^[Yy]$ ]] && echo -e "\n  ${YELLOW}Đã huỷ.${NC}" && exit 0

echo ""
mkdir -p "$TARGET_DIR"

INSTALLED=0
FAILED=0
for ENTRY in "${SKILLS[@]}"; do
  IFS='|' read -r NAME DESC <<< "$ENTRY"
  SRC="$SKILLS_SOURCE/$NAME/SKILL.md"
  DST="$TARGET_DIR/$NAME/SKILL.md"

  if [ ! -f "$SRC" ]; then
    echo -e "  ${RED}✗${NC} $NAME — không tìm thấy source"
    FAILED=$((FAILED + 1))
    continue
  fi

  mkdir -p "$TARGET_DIR/$NAME"
  [ -f "$DST" ] && cp "$DST" "$DST.bak" && echo -e "  ${YELLOW}↻${NC} $NAME — backup → SKILL.md.bak"
  cp "$SRC" "$DST"
  echo -e "  ${GREEN}✓${NC} $NAME"
  INSTALLED=$((INSTALLED + 1))
done

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
[ $FAILED -eq 0 ] \
  && echo -e "  ${GREEN}✓ HOÀN TẤT${NC} — ${BOLD}${INSTALLED}/${TOTAL}${NC} skills → ${BOLD}${TARGET_DIR}${NC}" \
  || echo -e "  ${YELLOW}⚠${NC} ${INSTALLED} OK, ${RED}${FAILED} lỗi${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  Khởi động lại Claude Code / Claude Desktop để load skills."
echo ""
