# Schlipak theme for fish

This theme is based on [agnoster theme](https://github.com/oh-my-fish/theme-agnoster), but isn't Powerline-themed.
It features a two line prompt, showing info such as:

- If the previous return status was different than 0
- If the current user is root
- If there are background jobs
- The current username and host (host::user)
- The current working directory, without the usual fish abbreviation
- If the user is in a Git/SVN/Mercurial repository, and some status infos
- On a new line, the prompt arrow. Turns to a red #> if the user is root.

![Screenshot](http://i.imgur.com/IbKzoAy.png)

### Installation

This theme can easily be installed using [Oh-my-fish](https://github.com/oh-my-fish/oh-my-fish).

```
omf install https://github.com/Schlipak/theme-schlipak
omf theme schlipak
```

If you don't use *Oh-my-fish*:
- Replace your `~/.config/fish/functions/fish_prompt.fish` file.
- Or clone this repository somewhere, and replace that same file with a symbolic link to this repository's `fish_prompt.fish`. This will allow you to update the theme only by running `git pull` in the directory you cloned the theme to.

### Configuration

This theme will work as is out of the box. However, it provides you with a set of variables that you can override in your `config.fish` to change its look.

- **theme_display_user** (*yes/no*) Hides or displays the username
- **theme_segment_separator** (*string*) Sets the separator between segments. Includes spacing
- **theme_user_separator** (*string*) Sets the separator between the host and username
- **theme_prompt_arrow** (*string*) Sets the character following the $ at the end of the prompt
- **theme_segment_separator_color** (*color*) Sets the color of the segment separator
- **theme_user_separator_color** (*color*) Sets the color of the host/user separator
- **theme_host_color** (*color*) Sets the color of the hostname
- **theme_user_color** (*color*) Sets the color of the username
- **theme_pwd_color** (*color*) Sets the color of the current working directory

Colors can be any of:
- black
- red
- green
- brown
- yellow
- blue
- magenta
- purple
- cyan
- white

Those will correspond to your terminal colors. You can also use any hex encoded color, without any # or 0x prefix.
To override a variable, use the following syntax in your `config.fish` file:
``` fish
set VAR VALUE
```
