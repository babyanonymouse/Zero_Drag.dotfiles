# Shell Setup

Details of the Zsh shell configuration used in Zero-Drag.

---

## Overview

The shell stack is built around **Zsh** with modern Rust-powered CLI replacements and a clean, low-latency prompt system.

| Tool | Replaces | Purpose |
| :--- | :------- | :------ |
| `eza` | `ls` | Modern file listing with icons |
| `bat` | `cat` | Syntax-highlighted file viewer |
| `zoxide` | `cd` | Smart directory jumping |
| `ripgrep` (`rg`) | `grep` | Faster search |
| `fzf` | — | Fuzzy finder (history, files) |
| `starship` | PS1 | Fast, customizable prompt |

---

## Plugins

Plugins are loaded from the system-wide Arch Linux paths:

```zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-completions/zsh-completions.zsh
```

| Plugin | Effect |
| :----- | :----- |
| `zsh-syntax-highlighting` | Fish-like syntax coloring as you type |
| `zsh-autosuggestions` | Fish-like command suggestions from history |
| `zsh-completions` | Additional tab-completion definitions |

---

## Aliases

### File System

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ls` | `eza --icons --group-directories-first` | Icon-decorated listing |
| `ll` | `eza -al --icons --group-directories-first` | Long listing with icons |
| `tree` | `eza --tree --icons` | Tree view with icons |
| `cat` | `bat` | Syntax-highlighted file viewer |

### Navigation

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `cd` | `z` | Smart jump via zoxide |
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |

### Utilities

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `grep` | `rg` | Faster grep via ripgrep |
| `v` | `vim` | Open Vim |
| `c` | `clear` | Clear terminal |
| `gs` | `git status` | Git status shortcut |

---

## Keybindings

The shell uses **emacs mode** (`bindkey -e`).

| Shortcut | Action |
| :------- | :----- |
| `Ctrl+R` | FZF history search (replaces default reverse search) |
| `Home` | Beginning of line |
| `End` | End of line |
| `Delete` | Delete character forward |
| `Ctrl+→` | Forward word |
| `Ctrl+←` | Backward word |
| `Ctrl+Backspace` | Delete word backwards |

---

## History Settings

| Setting | Value | Description |
| :------ | :---- | :---------- |
| `HISTFILE` | `~/.zsh_history` | History file location |
| `HISTSIZE` | `10000` | Lines to keep in memory |
| `SAVEHIST` | `10000` | Lines to save to disk |
| `SHARE_HISTORY` | on | Share history across sessions |
| `HIST_IGNORE_DUPS` | on | Don't store duplicate commands |
| `HIST_IGNORE_SPACE` | on | Don't store commands starting with space |

---

## Prompt (Starship + Transient Prompt)

### Starship

[Starship](https://starship.rs/) provides a feature-rich, fast prompt. Configuration lives in `~/.config/starship.toml`.

Starship is initialized last in `.zshrc`:

```zsh
eval "$(starship init zsh)"
```

### Transient Prompt

Zero-Drag implements a **transient prompt** — after pressing Enter, the full Starship prompt collapses to a minimal `➜ ` indicator, keeping the terminal output clean.

How it works:

```zsh
# When Enter is pressed: collapse to minimal prompt
zle-line-finish() {
    PROMPT="%B%F{green}➜%f%b "
    RPROMPT=""
    zle reset-prompt
}
zle -N zle-line-finish

# Before drawing the next prompt: restore full Starship prompt
precmd_restore_prompt() {
    PROMPT=$_STARSHIP_FULL_PROMPT
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_restore_prompt
```

This gives you the full context (git branch, virtualenv, etc.) on the **current** prompt line, but clean output for **previous** commands.

---

## Environment Variables

| Variable | Value | Description |
| :------- | :---- | :---------- |
| `EDITOR` | `vim` | Default text editor |
| `VISUAL` | `vim` | Default visual editor |
| `PAGER` | `bat` | Default pager (syntax-highlighted) |

---

## Adding to the Shell Config

To add your own customizations without modifying `.zshrc` directly, append them at the end of the file or create `~/.zshrc.local` and source it:

```zsh
# At the bottom of ~/.zshrc
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
```

Then add your personal aliases, functions, and exports to `~/.zshrc.local`.
