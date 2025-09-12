set -U fish_greeting ''
# functions -e fish_command_not_found

if status is-interactive
    # Initialize starship prompt
    starship init fish | source
    # direnv
    direnv hook fish | source
    # zoxide
    zoxide init fish | source
    # atuin
    atuin init fish | source
    # todo-rs
    # td init fish | source
    # Commands to run in interactive sessions can go here
    # fastfetch -c ~/.config/fastfetch/config-compact.jsonc
    # fastfetch -c ~/.config/fastfetch/config-small.jsonc
    # fastfetch
    # maxfetch
end

# editor
set -x VISUAL "nvim"
set -x EDITOR "nvim"

# fcitx5 on wayland env
set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS @im=fcitx
set -gx INPUT_METHOD fcitx
set -gx SDL_IM_MODULE fcitx
set -gx GLFW_IM_MODULE ibus

set -g direnv_fish_mode eval_on_arrow

set -gx LD_LIBRARY_PATH /run/opengl-driver/lib $LD_LIBRARY_PATH

# 自动将 ~/.local/bin 及其所有子目录加入 PATH（仅目录）
for dir in $HOME/.local/bin/*/
    if test -d $dir
        set -gx PATH $dir $PATH
    end
end
# 确保主目录也在 PATH 中
set -gx PATH $HOME/.local/bin $PATH

# rust
set -gx PATH $HOME/.cargo/bin $PATH
# npm
set -x PATH $HOME/.npm/bin $PATH
set -x NPM_CONFIG_PREFIX $HOME/.npm
set -x NODE_OPTIONS "--max-old-space-size=16000"
# go
set -gx PATH $GOPATH/bin $PATH
set -gx GOPATH $HOME/.config/go $GOPATH

# gitconfig for archlinux
set -gx GIT_CONFIG ~/.config/git/config
set -x GPG_TTY (tty)
# set -gx GITHUB_TOKEN (cat ~/.config/fish/.github_token)

# Custom aliases
alias ls 'eza -a --icons'
alias ll 'eza -al --icons'
alias lt 'eza -a --tree --level=1 --icons'
alias grep 'grep --color=auto'
alias cls clear
alias gt 'gio trash --empty'
alias vif 'nvim (fzf -m --preview="~/.config/fzf/fzf-preview.sh {}" --height 30)'
alias pfzf 'fzf -m --preview="~/.config/fzf/fzf-preview.sh {}" --height 30 --border=rounded'
alias soc 'source ~/.config/fish/config.fish'
alias rc 'nvim ~/.config/fish/config.fish'
alias os 'cd ~/loneros-nixos/'
alias tp 'cd ~/Templates/'
alias dot 'cd ~/loneros-dots/loneros/'
alias dl 'cd ~/Downloads/'
alias doc 'cd ~/Documents/'
alias mkshell 'devbox init && devbox generate direnv && direnv allow'
alias ga 'git add .'
alias lg lazygit
alias fox musicfox
alias sw 'nh os switch ~/loneros-nixos'
alias disk 'df -h | grep -vE "^tmpfs|^devtmpfs|^efivarfs|^/run" | awk "{print \$6, \$2, \$5, \$4, \$1}" | column -t'
alias gc 'sudo nix-collect-garbage -d && sudo nix-store --gc'
alias cll 'find ~/.config -type l ! -exec test -e {} \; -delete'
alias py python
alias code codium
alias powerinfo 'upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias fontlist 'fc-list : family | sort | uniq'
alias cpu_top 'ps aux --sort=-%cpu | head -n 10'
alias npmi 'npm install -g --prefix=~/.npm'
alias carm 'mpv av://v4l2:/dev/video0 --profile=low-latency --untimed --no-cache' # 使用mpv调用相机
alias ff 'fastfetch'
alias lbin 'cd $HOME/.local/bin/'


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
    nix-shell -p ncdu --run "sudo ncdu $argv[1]"
end

function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

# needed git gh fzf jq
function pr
    # 获取 open PR 列表
    set prs (gh pr list --state open --json number,title --jq '.[] | "\(.number): \(.title)"')

    if test (count $prs) -eq 0
        echo "No open PRs found."
        return
    end

    # 用 fzf 选择一个 PR
    set selected_pr (printf "%s\n" $prs | fzf --prompt="Select PR> ")

    if test -z "$selected_pr"
        echo "No PR selected."
        return
    end

    set pr_number (string split ":" $selected_pr)[1]

    # 选择操作
    set action (printf "View Info\nClose & Delete Branch\nRerun CI" | fzf --prompt="Select action> ")

    switch $action
        case "View Info"
            # 获取 PR 信息
            set pr_info (gh pr view $pr_number --json number,title,body,state,author,url,headRefName,baseRefName,createdAt,updatedAt)
            echo $pr_info | jq -r '
                "PR #\(.number): \(.title)",
                "State: \(.state)",
                "Author: \(.author.login)",
                "Base Branch: \(.baseRefName)",
                "Head Branch: \(.headRefName)",
                "Created At: \(.createdAt)",
                "Updated At: \(.updatedAt)",
                "URL: \(.url)",
                "",
                "Body:\n\(.body)"'

            # 获取 CI 状态
            set pr_branch (echo $pr_info | jq -r '.headRefName')
            set runs (gh run list --branch $pr_branch --json databaseId,name,status,conclusion --jq '.[] | "\(.databaseId):\(.name):\(.status):\(.conclusion)"')

            if test -n "$runs"
                echo ""
                echo "CI Runs for branch $pr_branch:"
                for r in $runs
                    set fields (string split ":" $r)
                    set ci_id $fields[1]
                    set ci_name $fields[2]
                    set ci_status $fields[3]
                    set ci_conclusion $fields[4]

                    if test "$ci_status" = "completed"
                        echo "  [$ci_conclusion] $ci_name"
                    else
                        echo "  [$ci_status] $ci_name"
                    end
                end
            else
                echo "No CI runs found for branch $pr_branch."
            end

        case "Close & Delete Branch"
            set pr_branch (gh pr view $pr_number --json headRefName --jq '.headRefName')
            echo "Closing PR #$pr_number..."
            gh pr close $pr_number
            echo "Deleting remote branch $pr_branch..."
            git push origin --delete $pr_branch

        case "Rerun CI"
            set pr_branch (gh pr view $pr_number --json headRefName --jq '.headRefName')
            set runs (gh run list --branch $pr_branch --json databaseId,name,status,conclusion --jq '.[] | "\(.databaseId):\(.name):\(.status):\(.conclusion)"')

            if test -z "$runs"
                echo "No CI runs found for PR #$pr_number."
                return
            end

            # 多选想 rerun 的 CI
            set selected_runs (printf "%s\n" $runs | fzf --multi --prompt="Select CI runs to rerun> ")
            if test -z "$selected_runs"
                echo "No CI selected."
                return
            end

            for r in $selected_runs
                set ci_id (string split ":" $r)[1]
                echo "Rerunning CI run $ci_id..."
                gh run rerun $ci_id
            end

        case "*"
            echo "No action selected."
    end
end

# 替换 shebang
function shebang
    # 默认 shebang
    set -l new_shebang "#!/usr/bin/env bash"

    # 如果第一个参数是非空且以 #!/ 开头，则认为是自定义 shebang
    if test (count $argv) -ge 1
        if string match -q '#!/*' $argv[1]
            set new_shebang $argv[1]
            set argv (argv[2..-1])  # 剩下的是文件列表
        end
    end

    # 默认文件列表是当前目录所有文件
    if test (count $argv) -eq 0
        set argv ./*.sh
    end

    for f in $argv
        if test -f $f
            set old_shebang (head -n1 $f)
            # 只替换第一行
            if string match -q '#!*' $old_shebang
                # 用临时文件替换
                set tmp (mktemp)
                printf "%s\n" $new_shebang > $tmp
                tail -n +2 $f >> $tmp
                mv $tmp $f
                echo "Updated shebang: $f -> $new_shebang"
            else
                echo "No shebang found, skipping: $f"
            end
        end
    end
end
