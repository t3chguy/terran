function fish_prompt
    set -l status_copy $status
    set -l status_color black fc0
    set -l root_color fff 33f
    set -l pwd_info (pwd_info "/")

    set -l root_glyph (set_color -o)"  ≡  "(set_color normal)

    if not pwd_is_home
        set root_color 33f fff
    end

    if test "$status_copy" -ne 0
        set root_color $status_color
        set root_glyph (echo "$status_copy" | awk '{
            printf(length($0) == 3 ? " %s \n" : "  %s  \n", $0)
        }')
        set status_color $status_color[2] $status_color[1]
    end

    if set branch_name (git_branch_name)
        set -l git_glyph 
        set -l git_color fff 33f
        set -l gap_color $status_color

        if git_is_detached_head
            set git_glyph ➦
        end

        if git_is_touched
            set gap_color normal black
            set git_color black fc0

            if git_is_staged
                if git_is_dirty
                    set branch_name $branch_name ⧗
                else
                    set branch_name $branch_name ≡
                end
            else if git_is_dirty
                set branch_name $branch_name ⧖
            else
                set branch_name $branch_name ≡
            end
        else
            set branch_name $branch_name ≡
        end

        if git_is_stashed
            set git_color fc0 33f
        end

        if test ! -z "$pwd_info[3]"
            segment fff 33f " $pwd_info[3] "
            segment $gap_color
        end

        segment $git_color " $git_glyph $branch_name "
        segment $gap_color
    end

    if test ! -z "$pwd_info[1]"
        segment fff 33f " $pwd_info[1] "
        segment $status_color
    end

    if test ! -z "$pwd_info[2]"
        segment fff 33f " $pwd_info[2] "
        segment $status_color
    end

    segment $root_color $root_glyph
    set segment (set_color $root_color[2])$segment(set_color normal)

    segment_close
end
