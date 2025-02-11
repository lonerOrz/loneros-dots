#!/bin/bash

# 检查是否已经有 wayvnc 运行
if pgrep -x "wayvnc" >/dev/null; then
  echo "正在运行的 wayvnc 实例已找到，正在停止..."
  pkill wayvnc
  echo "旧的 wayvnc 实例已停止。"
else
  echo "没有发现运行中的 wayvnc 实例。"
fi

# 使用 headless 模式运行 Wayland
export WLR_BACKENDS=headless

# 停止从输入设备获取信息
export WLR_LIBINPUT_NO_DEVICES=1

# 设置 Wayland 显示
export WAYLAND_DISPLAY=wayland-1

# 创建虚拟输出显示器，指定分辨率和刷新率
export WLR_OUTPUTS="DP-1:1920x1080@165"

echo "wayvnc 已启动，监听端口 5901。"
# 启动 wayvnc
echo "启动新的 wayvnc 实例..."
#wayvnc -C /home/loner/wayvnc/wayvnc.conf 0.0.0.0 5901 --log-level debug &>/home/loner/wayvnc/wayvnc.log
wayvnc 0.0.0.0 5901 -v --max-fps 165 --log-level debug &>/home/loner/wayvnc/wayvnc.log &
#sleep 2
if pgrep -x "wayvnc" >/dev/null; then
  echo "wayvnc 实例已成功启动。"
else
  echo "wayvnc 实例启动失败。"
fi
