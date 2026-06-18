# Neovim Cheatsheet (kickstart setup)

> **Leader = `Space`.** Forgot a binding? `Space s k` opens a searchable list of ALL keymaps.
> Keys below: `C-x` means Ctrl+x. Things in *italics* are commands you type after `:`.

## Moving within a file

| Key | Action |
|---|---|
| `/word` then `Enter` | jump to next "word" — **the** primary movement |
| `n` / `N` | next / previous search match (`zz` after = center screen) |
| `*` | search the word under the cursor |
| `14j` / `14k` | jump 14 lines down/up — read the count off the relative line numbers |
| `C-d` / `C-u` | half page down / up (reading mode) |
| `{` / `}` | previous / next blank line (block-by-block in code) |
| `gg` / `G` / `42G` | top of file / bottom / line 42 |
| `zz` | center the view on the cursor |
| `C-o` / `C-i` | jump BACK / forward through jump history (works after any jump incl. LSP) |
| `gO` | fuzzy-pick a function/type in this file (outline) |
| `Space /` | fuzzy search within current buffer |

## Code navigation (LSP) — normal mode

| Key | Action |
|---|---|
| `grd` | goto **d**efinition (VS Code F12) |
| `gri` | goto **i**mplementations (trait → impls) |
| `grr` | list **r**eferences |
| `grt` | goto **t**ype definition |
| `grD` | goto declaration |
| `grn` | re**n**ame symbol project-wide |
| `gra` | code **a**ction (quick fixes, "generate match arms", auto-import…) |
| `K` | hover docs (press `K` again to scroll inside, `q` to close) |
| `gW` | fuzzy-pick a symbol across the whole workspace |
| `Space th` | toggle inlay hints (inferred types, like VS Code) |

## Diagnostics (errors/warnings — clippy output lands here)

| Key | Action |
|---|---|
| `]d` / `[d` | next / previous diagnostic in file |
| `Space q` | this file's diagnostics as a list |
| `Space sd` | ALL project diagnostics (VS Code "Problems" panel) |

Clippy runs on **save** — `:w` to refresh diagnostics.

## Completion (blink.cmp) — insert mode, while the menu is open

| Key | Action |
|---|---|
| `C-n` / `C-p` (or arrows) | next / previous suggestion |
| **`C-y`** | **accept** ("yes") — auto-adds the `use` import too |
| `C-e` | dismiss menu |
| `C-space` | open menu manually; press AGAIN for docs panel |
| `C-k` | toggle signature help (param tooltip; auto-shows on `(`) |
| `Tab` / `S-Tab` | hop between snippet placeholders |

## Formatting

| Key | Action |
|---|---|
| `Space f` | format buffer (or just the selection, in visual mode) — rustfmt via LSP |

## Find (Telescope)

| Key | Action |
|---|---|
| `Space sf` | find files (VS Code Ctrl+P) |
| `Space sg` | live grep the project (Ctrl+Shift+F) — searches from `:pwd`! |
| `Space Space` | open buffers (replaces the tab bar) |
| `Space s.` | recent files |
| `Space sk` | search keymaps (self-rescue) |
| `Space sh` | search nvim help |
| `Space sr` | resume last search where you left it |
| `Space sn` | search files in nvim config |

## Buffers, windows, file tree

| Key | Action |
|---|---|
| `C-6` | toggle between current and previous buffer (use this constantly) |
| *`:bd`* | close (delete) current buffer |
| `C-h/j/k/l` | move focus between splits |
| `\` | neo-tree file tree, revealing current file |

## Editing (learn one per day)

| Key | Action |
|---|---|
| `ciw` | change inner word |
| `ci"` / `ci(` / `ci{` | change inside quotes / parens / braces |
| `dap` | delete a paragraph/block |
| `.` | repeat last change |
| `Alt-j` / `Alt-k` (or Alt-arrows) | move current line / selection down / up |
| `Esc` | also clears search highlighting (custom mapping) |

## Git (gitsigns) — review Claude's edits hunk by hunk

| Key | Action |
|---|---|
| `]c` / `[c` | next / previous changed hunk |
| `Space hp` | preview hunk diff (`Space hi` = inline) |
| `Space hr` | reset (revert) hunk — works on visual selection too |
| `Space hs` | stage hunk (`Space hS` = whole buffer) |
| `Space hb` | blame current line (`Space tb` = toggle inline blame) |
| `Space hd` | diff file against index |

## Debugging (DAP) — `cargo build` first!

| Key | Action |
|---|---|
| `Space b` | toggle breakpoint |
| `Space B` | conditional breakpoint |
| `F5` | start / continue (asks for binary: `target/debug/<name>`) |
| `F2` | step over |
| `F1` | step into |
| `F3` | step out |
| `F7` | toggle the DAP UI (also: see last session's result) |

## Project & session hygiene

| Command | Action |
|---|---|
| launch as `cd <project>; nvim .` | makes grep/LSP/tree all scope correctly |
| *`:pwd`* / *`:cd <dir>`* | check / fix working directory |
| *`:checktime`* | reload files changed on disk (e.g. by Claude Code) |
| *`:w`* / *`:e`* | save / reload current file |
| *`:Tutor`* | chapter 1 (7 lessons) · *`:Tutor vim-02-beginner`* = chapter 2 |
| *`:Mason`* | manage LSP/DAP/formatter installs |
| *`:checkhealth`* | diagnose nvim setup problems |
