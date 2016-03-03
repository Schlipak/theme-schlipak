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

This theme isn't part of the *Oh-my-fish* theme suite. However, it can easily be integrated locally to it.

```
cd ~/.local/share/omf/themes
git clone https://github.com/Schlipak/theme-schlipak-fish schlipak
omf theme schlipak
```

Henceforth, *Oh-my-fish* will keep track of the theme and will update it normally when running `omf update`.
