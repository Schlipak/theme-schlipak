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
    if [ $uid -eq 0 ]
        set_color -o red
    else
        set_color -o green
    end
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

function get_hostname -d "Set hostname variable"
    set -g HOSTNAME_PROMPT (hostname)
end

function prompt_dir -d "Display the current directory"
    print_separator
    set_color -b normal
    set_color cyan
    echo -n (prompt_pwd)
    set_color normal
end

function prompt_hg -d "Display mercurial state"
  set -l branch
  set -l state
  if command hg id >/dev/null 2>&1
    if command hg prompt >/dev/null 2>&1
      set branch (command hg prompt "{branch}")
      set state (command hg prompt "{status}")
      set branch_symbol \uE0A0
      print_separator
      set_color -b normal
      if [ "$state" = "!" ]
          set_color red
          echo -n "$branch_symbol $branch ±"
    else if [ "$state" = "?" ]
        set_color yellow
        echo -n "$branch_symbol $branch ±"
      else
          set_color green
          echo -n "$branch_symbol $branch"
      end
      set_color normal
    end
  end
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


function prompt_svn -d "Display the current svn state"
  set -l ref
  if command svn ls . >/dev/null 2>&1
    set branch (svn_get_branch)
    set branch_symbol \uE0A0
    set revision (svn_get_revision)
    print_separator
    set_color -b normal
    set_color green
    echo -n "$branch_symbol $branch:$revision"
    set_color normal
  end
end

function svn_get_branch -d "get the current branch name"
  svn info 2> /dev/null | awk -F/ \
      '/^URL:/ { \
        for (i=0; i<=NF; i++) { \
          if ($i == "branches" || $i == "tags" ) { \
            print $(i+1); \
            break;\
          }; \
          if ($i == "trunk") { print $i; break; } \
        } \
      }'
end

function svn_get_revision -d "get the current revision number"
  svn info 2> /dev/null | sed -n 's/Revision:\ //p'
end

function prompt_status -d "Displays symbols for exit status, root and bg jobs"
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
end

# ===========================
# Apply theme
# ===========================

function fish_prompt
    set -g RETVAL $status
    prompt_status
    prompt_user
    prompt_dir
    type -q hg;  and prompt_hg
    type -q git; and prompt_git
    type -q svn; and prompt_svn
    prompt_finish
end
