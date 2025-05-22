#!/usr/bin/env bash

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
  print_color "$ERROR" "This script should not be executed as root! Exiting......."
  exit 1
fi

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

# Set some colors for banner
BANNER_COLOR_1="$(tput setaf 9)"  # Bright Red
BANNER_COLOR_2="$(tput setaf 11)" # Bright Yellow
BANNER_COLOR_3="$(tput setaf 12)" # Bright Cyan

# Print the custom loneros banner with more flashy colors
printf "\n%.0s" {1..2}
echo -e "${BANNER_COLOR_1}.__                                                        .___      __          ${RESET}"
echo -e "${BANNER_COLOR_2}|  |   ____   ____   ___________  ____  ______           __| _/_____/  |_  ______${RESET}"
echo -e "${BANNER_COLOR_3}|  |  /  _ \ /    \_/ __ \_  __ \/  _ \/  ___/  ______  / __ |/  _ \   __\/  ___/${RESET}"
echo -e "${BANNER_COLOR_1}|  |_(  <_> )   |  \  ___/|  | \(  <_> )___ \  /_____/ / /_/ (  <_> )  |  \___ \ ${RESET}"
echo -e "${BANNER_COLOR_2}|____/\____/|___|  /\___  >__|   \____/____  >         \____ |\____/|__| /____  >${RESET}"
echo -e "${BANNER_COLOR_3}                 \/     \/                 \/               \/                \/ ${RESET}"
printf "\n%.0s" {1..2}

# Function to print colorful text
print_color() {
  printf "%b%s%b\n" "$1" "$2" "$RESET"
}

# 15min
echo "Please enter sudo password once"
sudo -v

# Run the original copy script from the upstream repository
chmod +x ./*.sh
read -p "${CAT} Do you want to synchronize the latest version configuration file ? (y/n): " SYNC
case "$SYNC" in
[Yy]*)
  ./sync.sh
  ;;
[Nn]*)
  print_color "$NOTE" "- Skipping sync config"
  ;;
*)
  print_color "$WARN" "- Invalid choice."
  ;;
esac

# Directory for configurations
config_dir="$PWD/loneros"

# Check if stow is installed
if ! command -v stow &>/dev/null; then
  print_color "$ERROR" "stow is not installed. Please install it first."
  exit 1
fi
print_color "$OK" "stow is installed."

# 查找配置目录中的子目录
directories=($(find "$config_dir" -mindepth 1 -maxdepth 1 -type d))

# 定义需要跳过stow的项目目录
SKIP_DIRECTORIES=("waypaper" "hyprpanel" "spicetify" "nwg-dock-hyprland" "xsettingsd" "git" "btop" "bottom")

mkdir_route() {
  local dirname="$1"

  if [ -f "$config_dir/$dirname/route" ]; then
    print_color "$INFO" "检测到 rout 文件，按 rout 规则创建目录..."

    while IFS= read -r line; do
      [[ -z "$line" ]] && continue    # 忽略空行
      [[ "$line" =~ ^# ]] && continue # 忽略注释行

      # 处理提示信息
      if [[ "$line" =~ ^@NOTE ]]; then
        print_color "$MAGENTA" "route 提示: ${line#@NOTE: }"
        continue
      fi

      # 处理正常的目录路径
      target_dir="$HOME/$line"
      if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        print_color "$GREEN" " 创建目录: $target_dir 成功！"
      fi
    done <"$config_dir/$dirname/route"
    # else
    # print_color "$INFO" "没有需要创建的文件夹"
  fi
}

# 遍历所有目录
for dir in "${directories[@]}"; do
  dir_name=$(basename "$dir")
  if [[ " ${SKIP_DIRECTORIES[@]} " =~ " $dir_name " ]]; then
    echo "${NOTE} $ORANGE 项目 $dir_name 不需要stow,被跳过！$RESET"
    echo
    continue
  fi

  # 是否自动链接
  AUTO_SYNC=true # 设置为 true 以自动链接，无需询问用户

  if [ -d "$config_dir/$dir_name" ]; then
    if [ "$AUTO_SYNC" == true ]; then
      # 自动执行链接操作
      echo "${CAT} Automatically stowing ${BLUE}$dir_name${RESET}..."
      stow_output=$(stow --dir="$config_dir" --target="$HOME" -D "$dir_name" 2>&1)
      mkdir_route "$dir_name"
      stow_output=$(stow --dir="$config_dir" --target="$HOME" "$dir_name" --ignore="^route$" --no-folding 2>&1)
      stow_status=$?
      print_color "$OK" "${GREEN}$dir_name successfully linked."
    else
      # 向用户询问是否执行链接
      while true; do
        read -p "${CAT} Do you want to stow ${BLUE}$dir_name${RESET} ? (Y/y or N/n): " SYNC
        case "$SYNC" in
        [Yy]*)
          stow_output=$(stow --dir="$config_dir" --target="$HOME" -D "$dir_name" 2>&1)
          mkdir_route "$dir_name"
          stow_output=$(stow --dir="$config_dir" --target="$HOME" "$dir_name" --ignore="^route$" --no-folding 2>&1)
          stow_status=$?
          print_color "$OK" "${GREEN}$dir_name successfully linked."
          break
          ;;
        [Nn]*)
          print_color "$NOTE" "- Skipping link $dir_name"
          break
          ;;
        *)
          print_color "$WARN" "- Invalid choice. Please enter Y/y or N/n."
          ;;
        esac
      done
    fi
    echo
  else
    print_color "$ORANGE" "$config_dir/$dir_name does not exist. Skipping."
    echo
  fi
done

find $HOME -xtype l -exec rm -f {} \;

# Check if wallpapers directory exists in loneros
if [ -d "wallpapers" ]; then
  while true; do
    read -p "${CAT} ${ORANGE}wallpapers${RESET} directory found in loneros/. Do you want to use loneros' wallpapers and overwrite your current wallpapers? (y/n): " WALLPAPER_CHOICE
    case "$WALLPAPER_CHOICE" in
    [Yy]*)
      # Create the target directory if it doesn't exist
      if [ ! -d "$HOME/Pictures/wallpapers" ]; then
        BACKUP_DIR=$(date +"%m%d_%H%M")
        mv "$HOME/Pictures/wallpapers" "$HOME/Pictures/wallpapers-backup-$BACKUP_DIR"
        mkdir -p "$HOME/Pictures/wallpapers"
        print_color "$NOTE" "- Existing wallpapers backed up to $HOME/Pictures/wallpapers-backup-$BACKUP_DIR."
      else
        print_color "$INFO" "- Creating wallpapers directory."
        mkdir -p "$HOME/Pictures/wallpapers"
      fi

      # Copy new wallpapers
      cp -r wallpapers/* "$HOME/Pictures/wallpapers"
      if [ $? -eq 0 ]; then
        print_color "$OK" "- Wallpapers successfully copied to $HOME/Pictures/wallpapers."
      else
        print_color "$ERROR" "- Failed to copy wallpapers."
        exit 1
      fi
      break
      ;;
    [Nn]*)
      print_color "$NOTE" "- Skipping wallpaper setup."
      break
      ;;
    *)
      print_color "$WARN" "- Invalid choice. Please enter Y or N."
      ;;
    esac
  done
else
  print_color "$NOTE" "- No wallpapers directory found in loneros."
fi
printf "\n%.0s" {1..1}

print_color "$INFO" "- Copying dotfiles ${BLUE}second${RESET} part"
