#!/bin/bash

# === COLOR SETUP ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# === SPINNER FUNCTION ===
spinner() {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  while ps -p $pid > /dev/null 2>&1; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# === CONFIG ===

KEEP_EXTENSIONS=(
  "blockchainbard.suimoverunner"
  "damirka.move-syntax"
  "move.move-analyzer"
  "mysten.move"
  "mysten.move-trace-debug"
  "mysten.prettier-move"
)

INSTALL_LIST=(
  "ms-python.python"
  "ms-python.vscode-pylance"
  "dart-code.flutter"
  "github.copilot"
  "eamodio.gitlens"
  "ms-toolsai.vscode-ai"
  "bierner.markdown-preview-github-styles"
  "docker.docker"
  "vscodevim.vim"
)

PYTHON_PROFILE=("ms-python.python" "ms-python.vscode-pylance" "ms-python.autopep8" "ms-python.black-formatter")
FLUTTER_PROFILE=("dart-code.flutter" "dart-code.dart-code" "alexisvt.flutter-snippets")
AI_PROFILE=("github.copilot" "github.copilot-chat" "ms-toolsai.vscode-ai" "google.geminicodeassist")
DOCS_PROFILE=("bierner.markdown-preview-github-styles" "davidanson.vscode-markdownlint")
DEVTOOLS_PROFILE=("eamodio.gitlens" "vscodevim.vim" "editorconfig.editorconfig")

# === FUNCTIONS ===

uninstall_all_except_sui() {
  echo -e "${BLUE}🔧 Uninstalling all extensions except Sui Move dev tools...${NC}"
  for ext in $(code --list-extensions); do
    if [[ ! " ${KEEP_EXTENSIONS[@]} " =~ " $ext " ]]; then
      echo -e "${RED}❌ Uninstalling $ext${NC}"
      ([[ "$DRY_RUN" != "true" ]] && code --uninstall-extension "$ext") & spinner
    else
      echo -e "${GREEN}✅ Keeping $ext${NC}"
    fi
  done
  echo -e "${GREEN}✅ Cleanup complete!${NC}"
}

install_extensions() {
  echo -e "${CYAN}📦 Available extensions to install:${NC}"
  for i in "${!INSTALL_LIST[@]}"; do
    echo "$((i+1)). ${INSTALL_LIST[$i]}"
  done
  echo -e "\nEnter numbers separated by space to install (or * for all, or 'back' to cancel):"
  read -r selection
  [[ "$selection" == "back" ]] && return
  if [[ "$selection" == "*" ]]; then
    for ext in "${INSTALL_LIST[@]}"; do
      echo -e "${YELLOW}📥 Installing $ext${NC}"
      ([[ "$DRY_RUN" != "true" ]] && code --install-extension "$ext") & spinner
    done
  else
    for num in $selection; do
      index=$((num-1))
      ext="${INSTALL_LIST[$index]}"
      echo -e "${YELLOW}📥 Installing $ext${NC}"
      ([[ "$DRY_RUN" != "true" ]] && code --install-extension "$ext") & spinner
    done
  fi
  echo -e "${GREEN}✅ Installation complete!${NC}"
}

install_profile() {
  echo -e "${CYAN}📂 Available profiles:${NC}"
  echo "1. Python"
  echo "2. Flutter"
  echo "3. AI"
  echo "4. Docs"
  echo "5. DevTools"
  echo -e "\nEnter profile number or type 'back' to return:"
  read -r selected
  [[ "$selected" == "back" ]] && return

  case "$selected" in
    1) profile_name="Python"; profile_exts=("${PYTHON_PROFILE[@]}") ;;
    2) profile_name="Flutter"; profile_exts=("${FLUTTER_PROFILE[@]}") ;;
    3) profile_name="AI"; profile_exts=("${AI_PROFILE[@]}") ;;
    4) profile_name="Docs"; profile_exts=("${DOCS_PROFILE[@]}") ;;
    5) profile_name="DevTools"; profile_exts=("${DEVTOOLS_PROFILE[@]}") ;;
    *) echo -e "${RED}❌ Invalid profile.${NC}"; return ;;
  esac

  echo -e "${BLUE}📥 Installing profile: $profile_name${NC}"
  for ext in "${profile_exts[@]}"; do
    echo -e "${YELLOW}📦 Installing $ext${NC}"
    ([[ "$DRY_RUN" != "true" ]] && code --install-extension "$ext") & spinner
  done
  echo -e "${GREEN}✅ Profile installed.${NC}"
}

add_extension_to_list() {
  echo -e "${CYAN}➕ Enter extension IDs separated by commas (or 'back' to cancel):${NC}"
  read -r input
  [[ "$input" == "back" ]] && return
  IFS=',' read -ra EXT_ARRAY <<< "$input"
  echo -e "${CYAN}📂 Add to which list?${NC}"
  echo "1. Install list"
  echo "2. Keep list"
  read -r list_choice
  [[ "$list_choice" == "back" ]] && return
  for ext in "${EXT_ARRAY[@]}"; do
    ext=$(echo "$ext" | xargs)
    case "$list_choice" in
      1) INSTALL_LIST+=("$ext"); echo -e "${GREEN}✅ Added $ext to install list.${NC}" ;;
      2) KEEP_EXTENSIONS+=("$ext"); echo -e "${GREEN}✅ Added $ext to keep list.${NC}" ;;
      *) echo -e "${RED}❌ Invalid choice.${NC}" ;;
    esac
  done
}

export_extensions() {
  echo -e "${CYAN}📤 Exporting current extensions to vscode-extensions.txt...${NC}"
  code --list-extensions > vscode-extensions.txt
  echo -e "${GREEN}✅ Export complete!${NC}"
}

reset_extensions() {
  echo -e "${RED}⚠️ This will uninstall ALL extensions. Proceed? (y/n)${NC}"
  read -r confirm
  [[ "$confirm" == "back" ]] && return
  if [[ "$confirm" == "y" ]]; then
    for ext in $(code --list-extensions); do
      echo -e "${RED}❌ Uninstalling $ext${NC}"
      ([[ "$DRY_RUN" != "true" ]] && code --uninstall-extension "$ext") & spinner
    done
    echo -e "${GREEN}✅ VS Code reset complete.${NC}"
  else
    echo -e "${YELLOW}❌ Reset cancelled.${NC}"
  fi
}

show_stats() {
  total=$(code --list-extensions | wc -l)
  kept=0
  for ext in $(code --list-extensions); do
    [[ " ${KEEP_EXTENSIONS[@]} " =~ " $ext " ]] && ((kept++))
  done
  echo -e "${CYAN}📊 Extension Stats:${NC}"
  echo -e "${YELLOW}🔢 Total installed: $total${NC}"
  echo -e "${GREEN}🛡️  Kept (Sui dev): $kept${NC}"
  echo -e "${RED}🧹 Will be removed: $((total - kept))${NC}"
}

smart_suggestions() {
  echo -e "${CYAN}🧠 Checking for missing Sui Move tools...${NC}"
  for ext in "${KEEP_EXTENSIONS[@]}"; do
    if ! code --list-extensions | grep -q "$ext"; then
      echo -e "${RED}⚠️ Missing: $ext — consider installing it.${NC}"
    fi
  done
  echo -e "${GREEN}✅ Suggestion check complete.${NC}"
}

search_extensions() {
  echo -e "${CYAN}🔍 Enter keyword to search (or 'back' to cancel):${NC}"
  read -r query
  [[ "$query" == "back" ]] && return
  echo -e "${BLUE}🔎 Matches in install list:${NC}"
  for ext in "${INSTALL_LIST[@]}"; do
    [[ "$ext" == *"$query"* ]] && echo "• $ext"
  done
}

sync_from_url() {
  echo -e "${CYAN}🌐 Enter URL to fetch extension list (or 'back' to cancel):${NC}"
  read -r url
  [[ "$url" == "back" ]] && return
    curl -s "$url" > remote-extensions.txt
  echo -e "${BLUE}📥 Installing extensions from remote list...${NC}"
  while read -r ext; do
    echo -e "${YELLOW}📦 Installing $ext${NC}"
    ([[ "$DRY_RUN" != "true" ]] && code --install-extension "$ext") & spinner
  done < remote-extensions.txt
  echo -e "${GREEN}✅ Remote sync complete.${NC}"
}
load_plugins() {
  if [[ -d "plugins" ]]; then
    for plugin in plugins/*.sh; do
      echo -e "${CYAN}🔌 Loading plugin: $plugin${NC}"
      source "$plugin"
    done
  fi
}
DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true && echo -e "${YELLOW}🧪 Dry run mode enabled — no changes will be made.${NC}"

load_plugins

while true; do
  echo -e "\n${CYAN}🛠 VS Code Extension Manager${NC}"
  echo -e "${YELLOW}1.${NC} Install extensions from list"
  echo -e "${YELLOW}2.${NC} Uninstall all except Sui Move dev extensions"
  echo -e "${YELLOW}3.${NC} Add extension to install or keep list"
  echo -e "${YELLOW}4.${NC} Export current extensions to file"
  echo -e "${YELLOW}5.${NC} Reset all extensions"
  echo -e "${YELLOW}6.${NC} Show extension stats"
  echo -e "${YELLOW}7.${NC} Smart suggestions"
  echo -e "${YELLOW}8.${NC} Install by profile"
  echo -e "${YELLOW}9.${NC} Search extensions"
  echo -e "${YELLOW}10.${NC} Sync from remote URL"
  echo -e "${YELLOW}0.${NC} Exit"
  echo -en "${BLUE}Choose an option (0–10): ${NC}"
  read -r choice

  case "$choice" in
    1) install_extensions ;;
    2) uninstall_all_except_sui ;;
    3) add_extension_to_list ;;
    4) export_extensions ;;
    5) reset_extensions ;;
    6) show_stats ;;
    7) smart_suggestions ;;
    8) install_profile ;;
    9) search_extensions ;;
    10) sync_from_url ;;
    0) echo -e "${GREEN}👋 Goodbye, Flourish!${NC}"; exit 0 ;;
    *) echo -e "${RED}❌ Invalid choice. Try again.${NC}" ;;
  esac
done

