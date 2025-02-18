set -U fish_greeting ''

if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch -c ~/.config/fastfetch/config-compact.jsonc
    # Initialize starship prompt
    starship init fish | source
    # direnv
    direnv hook fish | source
end

# fcitx5 on wayland env
set -x GTK_IM_MODULE fcitx
set -x QT_IM_MODULE fcitx
set -x XMODIFIERS @im=fcitx
set -x INPUT_METHOD fcitx
set -x SDL_IM_MODULE fcitx
set -x GLFW_IM_MODULE ibus

# gitconfig
set -x GIT_CONFIG ~/.config/git/config


# Custom aliases
alias ls 'eza -a --icons'
alias ll 'eza -al --icons'
alias lt 'eza -a --tree --level=1 --icons'
alias grep 'grep --color=auto'
alias cls clear
alias gt 'gio trash --empty'
alias vif 'nvim (fzf -m --preview="~/.config/fzf/fzf-preview.sh {}" --height 30)'
alias fzf 'fzf -m --preview="~/.config/fzf/fzf-preview.sh {}" --height 30'
alias soc 'source ~/.config/fish/config.fish'
alias rc 'nvim ~/.config/fish/config.fish'
alias os 'cd ~/loneros-nixos/'
alias code 'cd ~/Templates/'
alias dot 'cd ~/loneros-dots/'
alias cps 'cd ~/dockercompose/'
alias dl 'cd ~/Downloads/'
alias dcm 'cd ~/Documents/'
alias vm 'cd ~/virtualmachine/vm/'
alias cf 'cd ~/.config'
alias mkshell 'devbox init && devbox generate direnv && direnv allow'
alias ga 'git add .'
alias gc 'git clone'
alias gs 'git status'
alias lg lazygit
alias ipa 'ip a | grep -A 2 -E "^[0-9]+: (wlan|eth|en)"'
alias nh 'nh os switch ~/loneros-nixos'
alias disk 'df -h | grep -vE "^tmpfs|^devtmpfs|^efivarfs|^/run" | awk "{print \$6, \$2, \$5, \$4, \$1}" | column -t'
alias gc 'sudo nix-collect-garbage -d && sudo nix-store --gc'


function ts
    set text $argv
    set detected_lang (echo $text | trans -b -identify | string trim)
    switch $detected_lang
        case en
            echo $text | trans -b :zh
        case zh-CN
            echo $text | trans -b :en
        case ja
            echo $text | trans -b :en
        case fr
            echo $text | trans -b :en
        case ko
            echo $text | trans -b :en
        case "*"
            echo "Detected language ($detected_lang) is not specifically handled."
            echo $text | trans -b :en
    end
end

function yt
    if test (count $argv) -eq 0
        echo "Error: Please provide a YouTube URL."
        return 1
    end

    set url $argv[1]
    set video_title (yt-dlp --get-title $url)
    set save_dir $HOME/Videos/yt-dlp/$video_title

    mkdir -p "$save_dir"

    yt-dlp --write-auto-subs --sub-langs zh-Hans --convert-subs srt --output "$save_dir/%(title)s [%(id)s].%(ext)s" "$url"

    if test $status -eq 0
        echo "Download completed successfully!"
    else
        echo "Error: Download failed."
    end
end

function gz
    for dir in (find . -maxdepth 1 -type d)
        # 排除当前目录 "."，确保只处理子文件夹
        if test "$dir" != "."
            set folder_name (basename "$dir")
            echo "Packaging folder '$folder_name' into '$folder_name.tar.gz'..."
            tar -czf "$folder_name.tar.gz" "$dir" && echo "Successfully created '$folder_name.tar.gz'" || echo "Failed to create '$folder_name.tar.gz'"
        end
    end
end


function ya
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function check
    du -h $argv[1] --max-depth=1 | sort -hr | head -n 10
end

function vmerge
    if count $argv <2
        echo "用法: merge <视频文件> <音频或视频文件> [输出文件]"
        return 1
    end

    set file1 $argv[1]
    set file2 $argv[2]

    # 如果没有指定输出文件名，则使用第一个文件的名称，并加上 "_merged"
    set output_file (math $argv[3] ?: (string trim (string split . $file1)[1])"_merged.mp4")

    # 获取第一个文件（假定为视频文件）的时长
    set duration1 (ffprobe -i $file1 -show_entries format=duration -v quiet -of csv="p=0")
    # 获取第二个文件的时长
    set duration2 (ffprobe -i $file2 -show_entries format=duration -v quiet -of csv="p=0")

    # 设置允许的最大时长差异（单位：秒）
    set max_diff 1

    # 计算时长差异
    set diff (math $duration1 - $duration2)

    # 检查时长差异是否在允许范围内
    if not test (math $diff <= $max_diff) -a (math $diff >= -$max_diff)
        echo "错误: 文件时长差异 ($diff 秒) 超过允许范围 ($max_diff 秒)！"
        return 1
    end

    # 判断第二个文件是视频还是音频
    set codec_type (ffprobe -i $file2 -show_streams -select_streams a -v quiet -of csv="p=0" -show_entries stream=codec_type)

    if test $codec_type = audio
        echo "检测到第二个文件是音频，合并视频和音频..."
        ffmpeg -i $file1 -i $file2 -c:v copy -c:a copy -map 0:v:0 -map 1:a:0 $output_file
    else
        echo "检测到第二个文件是视频，合并两个视频..."
        ffmpeg -i $file1 -i $file2 -filter_complex "[0:v:0][1:v:0]concat=n=2:v=1:a=0[outv]" -map "[outv]" $output_file
    end

    echo "合并完成: $output_file"
end

function cmt
    # 如果没有输入提交信息，则使用默认的提交信息
    if test (count $argv) -lt 1
        set commit_message "update version"
    else
        # 获取提交信息（从命令参数获取）
        set commit_message (string join " " $argv)
    end

    # 确保当前目录是一个 Git 仓库
    if not test -d .git
        echo "当前目录不是一个 Git 仓库！"
        return 1
    end

    # 执行 Git 操作
    git add . # 添加所有更改
    git commit -m "$commit_message" # 提交更改

    # 输出提交信息
    echo "更改已提交，提交信息: $commit_message"
end

function backup
    # 查找所有以 .backup 结尾的文件或目录
    find . -name "*.backup" | while read path
        # 获取去掉 .backup 后的路径
        set new_path (string replace -r '\.backup$' '' $path)

        # 强制重命名并覆盖已有文件或目录
        mv -f $path $new_path

        # 输出重命名的结果
        echo "Renamed (overwritten if necessary): $path -> $new_path"
    end
end
