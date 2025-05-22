#!/usr/bin/env bash

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"       # 绿色：成功
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)" # 红色：错误
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"   # 黄色：注意
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"   # 蓝色：信息
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"   # 红色：警告
CAT="$(tput setaf 5)[ACTION]$(tput sgr0)"  # 紫色：动作
MAGENTA="$(tput setaf 5)"                  # 紫色：其他用途
ORANGE="$(tput setaf 214)"                 # 橙色：提醒
WARNING="$(tput setaf 1)"                  # 红色：强烈警告
YELLOW="$(tput setaf 3)"                   # 黄色：提示
GREEN="$(tput setaf 2)"                    # 绿色：成功
BLUE="$(tput setaf 4)"                     # 蓝色：信息
SKY_BLUE="$(tput setaf 6)"                 # 天蓝色：辅助信息
RESET="$(tput sgr0)"                       # 重置颜色

# 配置源文件夹和目标文件夹
SOURCE="config"
TARGET="loneros"

# 同步最新修改到config 最好手动同步，做好更新审核
./merge.sh
printf "\n%.0s" {1..8}
echo
# clear

# 定义需要跳过同步的项目目录
SKIP_DIRECTORIES=("fastfetch" "kitty" "nvim")

# 同步Hyprland-Dots和loneros
# 每个子文件夹下的排除规则可以单独定义
declare -A EXCLUDE_RULES
EXCLUDE_RULES["hypr"]="UserConfigs/ wallpaper_effects/ hyprlock.conf hyprlock-1080p.conf wallust/"
EXCLUDE_RULES["rofi"]="config.rasi .current_wallpaper wallust/ resolution/"
EXCLUDE_RULES["waybar"]="config style.css UserMoudules wallust/"
EXCLUDE_RULES["btop"]="btop.conf"
EXCLUDE_RULES["swaync"]="ja.png wallust/"
EXCLUDE_RULES["wallust"]="wallust.toml templates/"

# 获取目标目录下的所有子文件夹（项目）
subfolders=$(find "$TARGET" -mindepth 1 -maxdepth 1 -type d)

# 遍历源目录下的每个子文件夹（项目）
for subfolder in $subfolders; do
  folder_name=$(basename "$subfolder")

  if [[ " ${SKIP_DIRECTORIES[@]} " =~ " $folder_name " ]]; then
    echo "${NOTE} $ORANGE 项目 $folder_name 不需要同步,被跳过！$RESET"
    echo
    continue
  fi

  # 检查目标文件夹中是否存在对应的项目文件夹
  target_folder="$SOURCE/$folder_name"
  if [ ! -d "$target_folder" ]; then
    # echo "$WARNING 源文件夹下 $target_folder 不存在，跳过该项目...$RESET"
    continue
  fi

  # 获取当前子文件夹的名称
  echo "$SKY_BLUE ============ 正在比较 $folder_name 项目 ============$RESET"

  # 设置当前文件夹的排除规则
  EXCLUDE_PARAMS=()
  if [ -n "${EXCLUDE_RULES[$folder_name]}" ]; then
    for exclude_pattern in ${EXCLUDE_RULES[$folder_name]}; do
      EXCLUDE_PARAMS+=("--exclude=$exclude_pattern")
    done
  fi

  SOURCE_DIR="$SOURCE/$folder_name"
  TARGET_DIR="$TARGET/$folder_name/.config/$folder_name"

  # for file in $(rsync -avni --ignore-times "${EXCLUDE_PARAMS[@]}" "$SOURCE_DIR" "$TARGET_DIR" | grep -E '^>f' | awk '{print $2}'); do
  #   if [ -f "$TARGET/$folder_name/.config/$file" ]; then
  #     echo "$CAT 差异文件：$file$RESET"
  #     diff -u "$SOURCE/$file" "$TARGET/$folder_name/.config/$file"
  #   else
  #     echo "$CAT 新增文件：$SOURCE/$file$RESET"
  #     diff -u /dev/null "$SOURCE/$file"
  #   fi
  # done

  # 同步
  echo "$INFO 正在同步 $folder_name 项目...$RESET"
  rsync -avi "${EXCLUDE_PARAMS[@]}" "$SOURCE_DIR/" "$TARGET_DIR/"
  echo "$OK $folder_name 项目同步完成！$RESET"
  printf "\n%.0s" {1..3}
  echo
done
