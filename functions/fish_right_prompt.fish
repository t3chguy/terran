function fish_right_prompt
    set -l status_copy $status
    set -l status_color fff 33f
    set -l back_color f00 fc0
    set -l gap
    set -l root_glyph (set_color -o)"  ≡  "(set_color normal)

    if test "$status_copy" -ne 0
        set status_color black fc0
        set back_color black black
    end

    if test "$CMD_DURATION" -gt 50
        set -l duration_copy $CMD_DURATION
        set -l duration (echo $CMD_DURATION | humanize_duration)

        segment_right $status_color " $duration "
        set -e gap
    end

    if set -l last_job_id (last_job_id)
        if not set -q gap
            segment_right $back_color
        end

        segment_right $status_color " %$last_job_id "
        set -e gap
    end

    if test 0 -eq (id -u $USER) -o ! -z "$SSH_CLIENT"
        if not set -q gap
            segment_right $back_color
        end

        segment_right $status_color (host_info " user~host ")
        set -e gap
    end

    if not set -q gap
        printf (set_color $status_color[2] -b black)(set_color normal)
    end

    segment_close
end
