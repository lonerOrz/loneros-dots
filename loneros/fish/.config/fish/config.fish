set -U fish_greeting ''
# functions -e fish_command_not_found

if status is-interactive
    # Initialize starship prompt
    starship init fish | source
    # direnv
    direnv hook fish | source
    # zoxide
    zoxide init fish | source

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

set -gx PATH $HOME/.cargo/bin $PATH # rust
set -x PATH $HOME/.npm/bin $PATH # npm
set -gx GOPATH $HOME/.config/go $GOPATH
set -gx PATH $GOPATH/bin $PATH # go

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
alias wp 'cd ~/Pictures/wallpapers/'
alias cps 'cd ~/dockercompose/'
alias dl 'cd ~/Downloads/'
alias doc 'cd ~/Documents/'
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
alias fontlist 'fc-list : family | sort | uniq'
alias cpu_top 'ps aux --sort=-%cpu | head -n 10'
alias npmi 'npm install -g --prefix=~/.npm'

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
