
---

# **🎮 Hyprland + 游戏优化（Wayland 专用）**

## **🔹 1. 启用 `gamescope`（适用于 Wayland）**
Hyprland **默认使用 Wayland**，你可以使用 **`gamescope`** 作为 **游戏模式** 以优化性能。

### **📌 安装 `gamescope`**
```sh
sudo pacman -S gamescope
```

### **📌 启动方式**
在 **Steam 启动参数**里添加：
```
gamescope -W 1920 -H 1080 -r 60 -f -- %command%
```
**参数说明：**
- `-W 1920 -H 1080` → 设定游戏窗口大小（可调）
- `-r 60` → 设定刷新率（换成你的显示器刷新率）
- `-f` → 强制全屏
- `-- %command%` → 运行 Steam 游戏

---

## **🔹 2. `gamemode`（游戏模式）**
```sh
sudo pacman -S gamemode
```
然后在 Steam 游戏 **启动参数**加：
```
gamemoderun %command%
```
这样游戏时，系统会 **自动调整 CPU 频率，减少后台进程占用**。

---

## **🔹 3. 确保 **NVIDIA/AMD** 驱动正确安装**
**📌 NVIDIA 用户（Wayland）**
```sh
sudo pacman -S nvidia nvidia-utils nvidia-dkms
```
然后修改 **`/etc/environment`**：
```sh
echo "WLR_NO_HARDWARE_CURSORS=1" | sudo tee -a /etc/environment
echo "LIBVA_DRIVER_NAME=nvidia" | sudo tee -a /etc/environment
echo "GBM_BACKEND=nvidia-drm" | sudo tee -a /etc/environment
echo "__GLX_VENDOR_LIBRARY_NAME=nvidia" | sudo tee -a /etc/environment
```
然后重启！

**📌 AMD 用户**
```sh
sudo pacman -S mesa mesa-utils vulkan-radeon lib32-mesa lib32-vulkan-radeon
```

---

## **🔹 4. Hyprland 相关优化**
### **📌 限制 `Hyprland` 的 `damage tracking`**
打开 Hyprland 配置：
```sh
nano ~/.config/hypr/hyprland.conf
```
**找到：**
```ini
# Use auto or full for better performance
damage_tracking = full
```
**改成**
```ini
damage_tracking = full
```
然后重启 Hyprland：
```sh
hyprctl reload
```
这样可以 **减少不必要的屏幕重绘**，提升游戏性能。

---

## **🔹 5. 关闭 `vsync`，减少延迟**
Hyprland 默认可能启用了 `vsync`，你可以关闭它以减少输入延迟：
```ini
# 在 Hyprland 配置文件里（~/.config/hypr/hyprland.conf）
env = WLR_NO_VSYNC,1
```
然后重启 Hyprland：
```sh
hyprctl reload
```

---

## **🔹 6. 使用 `MangoHud`（Wayland 版）**
```sh
sudo pacman -S mangohud
```
然后 **运行游戏** 时：
```
MANGOHUD=1 %command%
```
这样可以 **实时显示 FPS、温度、GPU 占用**。

---

## **🔹 7. 使用 `fsync` / `esync`（适用于 Proton 游戏）**
如果你在 Steam 运行 **Windows 游戏**（Proton），建议开启 `fsync`：
```sh
WINEFSYNC=1 %command%
```
**📌 `fsync` 适用于：**
- **Wine / Proton 游戏**
- **大型开放世界游戏**
- **减少卡顿，提高帧率**

---

## **🔹 8. 启用 `mesa-git`（AMD 用户专属）**
如果你是 **AMD 显卡**：
```sh
yay -S mesa-git
```
这样可以获得最新的 **Vulkan 驱动**，提升游戏性能！

---

## **🔹 9. 轻量化系统（减少后台占用）**
如果你希望游戏运行时 **减少 CPU 负担**，可以：
```sh
systemctl stop bluetooth
systemctl disable bluetooth
```
这样可以 **减少不必要的服务运行**，游戏时提高 CPU 性能。

---

# **🚀 总结（Hyprland 专属游戏优化）**
| **优化** | **作用** | **适用平台** |
|------------|------------|------------|
| **使用 `gamescope`** | **Wayland 下的游戏模式，优化全屏性能** | **所有游戏** 🎮 |
| **启用 `gamemode`** | **自动调整 CPU 频率，减少后台占用** | **所有游戏** 🚀 |
| **优化 `Hyprland` 配置** | **减少屏幕重绘，降低输入延迟** | **Wayland 专属** 🎯 |
| **关闭 `vsync`** | **减少延迟，提高 FPS** | **Hyprland 专属** 🔥 |
| **开启 `fsync`** | **提高 Wine / Proton 游戏流畅度** | **Steam / Proton** 🏆 |
| **安装 `mesa-git`** | **AMD Vulkan 提升** | **AMD 用户** 🎨 |
| **禁用 `bluetooth`** | **减少后台占用，提高 CPU 性能** | **所有系统** ⚡ |

这些优化 **专门针对 Hyprland + Wayland**，你可以试试看，FPS 和流畅度应该会 **显著提升**！🚀🔥
