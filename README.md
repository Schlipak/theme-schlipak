# Schlipak theme for fish

This theme is based on agnoster theme, but isn't Powerline-themed.
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
