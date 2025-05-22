#!/usr/bin/env bash

# ========== 配置 ==========
VERSION="1.0.0"                     # 版本号
dotdir="$HOME/loneros-dots/loneros" # dotfiles 存放目录
targetdir="$HOME"                   # 目标目录
ignore="^route$"                    # 忽略文件

# 处理stow链接包
handle_stow_package() {
  local selected_package="$1"

  # 如果没有选择包名，给出提示并退出
  if [[ -z "$selected_package" ]]; then
    echo "❌ 请提供包名"
    exit 1
  fi

  echo "正在链接包: $selected_package"
  stow --dir="$dotdir" --target="$targetdir" --ignore="$ignore" "$selected_package"
}

# 清理无效符号链接
clean_broken_links() {
  find $HOME/.config -type l ! -exec test -e {} \; -delete
  echo "🧹 清理无效符号链接完成"
}

# 打印帮助信息
print_help() {
  echo "usage: ./loneros.sh [options] [package]"
  echo "Options:"
  echo "  -s, --stow       使用 stow 链接包"
  echo "  -v, --version    显示版本信息"
  echo "  -h, --help       显示帮助信息"
}

# 打印版本信息
print_version() {
  echo "loneros 版本： $VERSION"
}

# 解析命令行参数
parse_args() {
  local selected_package=""

  # 如果没有传入任何参数，提示并退出
  if [[ $# -eq 0 ]]; then
    echo "❌ 请提供有效的选项或包名!"
    print_help
    exit 1
  fi

  # 解析参数
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -v | --version)
      # 显示版本
      print_version
      exit 0
      ;;
    -h | --help)
      # 显示帮助
      print_help
      exit 0
      ;;
    -s | --stow)
      # 启用 stow 链接
      shift
      if [[ $# -eq 0 ]]; then
        echo "❌ 错误：未指定要链接的包！"
        print_help
        exit 1
      fi
      # 处理多个包名
      while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
        selected_package="$1"
        handle_stow_package "$selected_package"
        shift
      done
      clean_broken_links # 清理无效符号链接
      ;;
    -i | --install)
      # 安装loneros
      ./install.sh
      exit 1
      ;;
    *)
      # 如果是未知选项，则提示并退出
      echo "❌ 未知选项：$1"
      print_help
      exit 1
      ;;
    esac
  done
}

# 调用解析函数
parse_args "$@"

echo "🎉 所有操作完成！"
