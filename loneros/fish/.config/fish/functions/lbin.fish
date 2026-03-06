function lbin
    set target_dir $HOME/.local/bin

    # 没有参数，直接 cd 到目录
    if test (count $argv) -eq 0
        cd $target_dir
        return
    end

    # 去掉末尾 /
    if string match -qr '/$' -- $argv[1]
        set query (string trim -r / $argv[1])
    else
        set query $argv[1]
    end

    # 模糊匹配目录或符号链接
    set matches (find $target_dir -maxdepth 1 \( -type d -o -type l \) -iname "*$query*" -exec basename {} \;)

    if test (count $matches) -eq 0
        echo "没有找到匹配目录"
    else if test (count $matches) -eq 1
        cd $target_dir/$matches[1]
    else
        # 多个匹配，用 fzf
        if type -q fzf
            set choice (printf "%s\n" $matches | fzf --prompt="选择目录: ")
            if test -n "$choice"
                cd $target_dir/$choice
            end
        else
            echo "找到多个匹配："
            for m in $matches
                echo "  $m -> $target_dir/$m"
            end
        end
    end
end

# Fish 自动补全
function __lbin_dirs
    for d in $HOME/.local/bin/* $HOME/.local/bin/*/
        if test -d $d -o -L $d
            echo (basename $d)
        end
    end
end

complete -c lbin -f -a '(__lbin_dirs)'
