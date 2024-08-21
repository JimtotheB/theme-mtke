function fish_right_prompt
    set -l exit_code $status
    if test $exit_code -ne 0
        set_color red
        echo -n $right_exit_value
    else
        set_color green
        echo -n $right_exit_value
    end
    # printf '%d' $exit_code
#     set_color yellow
#     echo -n 'yay'
    set_color normal
end