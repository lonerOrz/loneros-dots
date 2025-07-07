#!/usr/bin/env bash

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"       # 绿色：成功
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)" # 红色：错误
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"   # 黄色：注意
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"   # 蓝色：信息
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"   # 紫色：警告
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"  # 天蓝色：动作
MAGENTA="$(tput setaf 5)"                  # 紫色：其他用途
ORANGE="$(tput setaf 214)"                 # 橙色：提醒
WARNING="$(tput setaf 1)"                  # 红色：强烈警告
YELLOW="$(tput setaf 3)"                   # 黄色：提示
GREEN="$(tput setaf 2)"                    # 绿色：成功
BLUE="$(tput setaf 4)"                     # 蓝色：信息
SKY_BLUE="$(tput setaf 6)"                 # 天蓝色：辅助信息
RESET="$(tput sgr0)"                       # 重置颜色

# 检查当前目录是否是 git 仓库
if [ ! -d ".git" ]; then
  echo "${ERROR} 当前目录不是一个 git 仓库。"
  exit 1
fi

# 获取 upstream 仓库地址
UPSTREAM_REPO=$(git remote get-url upstream)
if [ -z "$UPSTREAM_REPO" ]; then
  echo "${ERROR} 未找到 upstream 仓库配置。"
  exit 1
fi

# 获取仓库名称（从 upstream URL 提取）
REPO_NAME=$(basename "$UPSTREAM_REPO" .git)

# 检查是否已经存在该仓库目录，若存在则执行 git pull 更新
if [ ! -d "$REPO_NAME" ]; then
  echo "${CAT} 克隆 upstream 仓库到当前目录下 $REPO_NAME..."
  git clone "$UPSTREAM_REPO"
  # git clone --branch development "$UPSTREAM_REPO"
  if [ $? -ne 0 ]; then
    echo "${ERROR} 克隆 upstream 仓库失败。"
    exit 1
  fi
else
  echo "${INFO} 仓库已存在，拉取最新代码..."
  # cd "$REPO_NAME" && git checkout main && git pull origin main
  cd "$REPO_NAME" || exit 1 # 确保进入仓库目录
  git fetch origin
  git checkout development
  git pull origin development
  if [ $? -ne 0 ]; then
    echo "${ERROR} 更新仓库失败。"
    exit 1
  fi
  cd ..
fi

# 确保临时仓库不被 git 跟踪，加入 .gitignore
if ! grep -q "$REPO_NAME" .gitignore; then
  echo "$REPO_NAME/" >>.gitignore
  echo "${INFO} 将临时仓库 $REPO_NAME 添加到 .gitignore 文件中。"
else
  echo "${INFO} 临时仓库 $REPO_NAME 已经在 .gitignore 中，跳过添加。"
fi

# 使用 rsync 同步需要的文件和文件夹
echo "${CAT} 开始同步文件..."

SYNCED_FILES=()

FILES_TO_SYNC=("config/" "assets/" "copy.sh") # 同步Hyprland-Dots的upstream的文件夹和文件

for FILE in "${FILES_TO_SYNC[@]}"; do
  # 检查文件或文件夹是否存在于 upstream 仓库
  if [ -e "$REPO_NAME/$FILE" ]; then
    echo "${INFO} 同步：$FILE"

    # 如果是文件夹，递归同步
    if [ -d "$REPO_NAME/$FILE" ]; then
      rsync -av --delete "$REPO_NAME/$FILE/" "$FILE/"
    else
      # 如果是单个文件，直接同步
      rsync -av --delete "$REPO_NAME/$FILE" "$FILE"
    fi

    SYNCED_FILES+=("$FILE")
  else
    echo "${WARN} 警告: 文件/文件夹 $FILE 不存在于 upstream 仓库，跳过..."
  fi
done

# 输出同步的文件
if [ ${#SYNCED_FILES[@]} -eq 0 ]; then
  echo "${NOTE} 没有文件被同步。"
else
  echo "${INFO} 已同步的文件和文件夹："
  for SYNCED_FILE in "${SYNCED_FILES[@]}"; do
    echo "  - ${YELLOW}$SYNCED_FILE${RESET}"
  done
fi

# 将同步的文件和文件夹添加到 git 暂存区
echo "${CAT} 将同步的文件添加到 git 暂存区..."
git add "${SYNCED_FILES[@]}"

# # 获取当前时间戳
# TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
#
# # 提交更改，包含时间戳
# COMMIT_MSG="同步 upstream 仓库更新 - $TIMESTAMP"
# echo "${CAT} 提交更改：$COMMIT_MSG..."
# git commit -m "$COMMIT_MSG"

# 输出完成信息
echo "${OK} 同步config完成!"
