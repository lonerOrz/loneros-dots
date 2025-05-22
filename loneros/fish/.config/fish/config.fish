set -U fish_greeting ''

if status is-interactive
    # Initialize starship prompt
    starship init fish | source
    # Commands to run in interactive sessions can go here
    # fastfetch -c ~/.config/fastfetch/config-compact.jsonc
    # fastfetch -c ~/.config/fastfetch/config-small.jsonc
    # fastfetch
    # maxfetch
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

set -g direnv_fish_mode eval_on_arrow

set -gx LD_LIBRARY_PATH /run/opengl-driver/lib $LD_LIBRARY_PATH
set -x PATH $HOME/.local/bin $PATH
# set -x PATH $HOME/.yarn/bin $PATH
# set -x PATH $GOPATH/bin $PATH

# gitconfig for archlinux
# set -x GIT_CONFIG ~/.config/git/config
set -x GITHUB_TOKEN (cat ~/.config/fish/.github_token)

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
alias dot 'cd ~/loneros-dots/'
alias wp 'cd ~/Pictures/wallpapers/'
alias cps 'cd ~/dockercompose/'
alias dl 'cd ~/Downloads/'
alias dcm 'cd ~/Documents/'
alias vm 'cd ~/virtualmachine/vm/'
alias cf 'cd ~/.config'
alias mkshell 'devbox init && devbox generate direnv && direnv allow'
alias ga 'git add .'
alias gs 'git status'
alias lg lazygit
alias fox musicfox
alias sw 'nh os switch ~/loneros-nixos'
alias disk 'df -h | grep -vE "^tmpfs|^devtmpfs|^efivarfs|^/run" | awk "{print \$6, \$2, \$5, \$4, \$1}" | column -t'
alias gc 'sudo nix-collect-garbage -d && sudo nix-store --gc'
alias cll 'find ~/.config -type l ! -exec test -e {} \; -delete'
alias py python
alias code codium
alias powerinfo 'upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias cpu_top 'ps aux --sort=-%cpu | head -n 10'

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

function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end
