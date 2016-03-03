# ===========================
# Schlipak theme
# ===========================

set -g theme_display_user   yes
set segment_separator       ' | '
set user_separator          '::'
set prompt_arrow            \u27A4

# ===========================
# Helper methods
# ===========================

set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_char_dirtystate '±'
set -g __fish_git_prompt_char_cleanstate ''

function parse_git_dirty
    set -l submodule_syntax
    set submodule_syntax "--ignore-submodules=dirty"
    set git_dirty (command git status --porcelain $submodule_syntax  2> /dev/null)
    if [ -n "$git_dirty" ]
        if [ $__fish_git_prompt_showdirtystate = "yes" ]
            echo -n "$__fish_git_prompt_char_dirtystate"
        end
    else
        if [ $__fish_git_prompt_showdirtystate = "yes" ]
            echo -n "$__fish_git_prompt_char_cleanstate"
        end
    end
end

function prompt_pwd -d 'Prints WD, not shortened'
    if test "$PWD" != "$HOME"
        printf "%s" (echo $PWD|sed -e 's|/private||' -e "s|^$HOME|~|")
    else
        echo '~'
    end
end

# ===========================
# Segments functions
# ===========================

function print_separator -d "Print segment separator"
    set_color -b normal
    set_color red
    echo -n $segment_separator
    set_color normal
end

function prompt_finish -d "Ends prompt"
    set_color -b normal
    set_color -o green
    echo
    echo -n " \$$prompt_arrow "
    set_color normal
end

# ===========================
# Theme components
# ===========================

function prompt_user -d "Display user and host"
    if [ "$theme_display_user" = "yes" ]
        set USER (whoami)
        set user_display (echo $USER | sed 's/\<[[:alpha:]]/\u&/g')
        get_hostname

        set_color -b normal
        set_color -o blue
        echo -n $HOSTNAME_PROMPT
        set_color -o white
        echo -n $user_separator
        set_color normal
        set_color blue
        echo -n $user_display
        set_color normal        
    else
        get_hostname
        if [ $HOSTNAME_PROMPT ]
            set_color -b normal
            set_color -o blue
            echo -n $HOSTNAME_PROMPT
            set_color normal
        end
    end
end

function get_hostname -d "Set current hostname to prompt variable $HOSTNAME_PROMPT if connected via SSH"
    set -g HOSTNAME_PROMPT (hostname)
end

function prompt_dir -d "Display the current directory"
    print_separator
    set_color -b normal
    set_color cyan
    echo -n (prompt_pwd)
    set_color normal
end

function prompt_git -d "Display the current git state"
    set -l ref
    set -l dirty
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set dirty (parse_git_dirty)
        set ref (command git symbolic-ref HEAD 2> /dev/null)
        if [ $status -gt 0 ]
            set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
            set ref "➦ $branch "
        end
        set branch_symbol \uE0A0
        set -l branch (echo $ref | sed  "s-refs/heads/-$branch_symbol -")
        print_separator
        set_color -b normal
        if [ "$dirty" != "" ]
            set_color yellow
        else
            set_color green
        end
        echo -n "$branch $dirty"
        set_color normal
    end
end

function prompt_status -d "the symbols for a non zero exit status, root and background jobs"
    set_color -b normal
    if [ $RETVAL -ne 0 ]
        set_color red
        echo -n "✘ "
        set_color normal
    end

    # if superuser (uid == 0)
    set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
        set_color yellow
        echo -n "⚡ "
        set_color normal
    end

    # Jobs display
    if [ (jobs -l | wc -l) -gt 0 ]
        set_color cyan
        echo -n "⚙ "
        set_color normal
    end
    echo -n " "
end

# ===========================
# Apply theme
# ===========================

function fish_prompt
    set -g RETVAL $status
    prompt_status
    prompt_user
    prompt_dir
    type -q git; and prompt_git
    prompt_finish
end
