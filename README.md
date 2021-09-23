## Vim Plugin for Running Selected Do-File in Stata on Linux
This plugin is inspired by the original [vim-stata](https://github.com/zizhongyan/vim-stata) on mac and atom plugin [stata-exec](https://github.com/kylebarron/stata-exec). The program of sending code to stata is modified from `stata-exec` and the template of vim plugin is from `vim-stata`.

## Install vim-stata on Linux(swaywm)
This plugin identifies editor window by the focused app_id and focused workspace. Feel free to modify the code.

```
Plug 'guanghwang/vim-stata-linux', { 'branch': 'main', 'for': 'stata'}  "stata exec
```


## [WIP] Install `vim-stata` on Linux (xwindows)````
For `xorg` users, add

```
Plug 'guanghwang/vim-stata-linux', { 'branch': 'linux', 'for': 'stata'}  "stata exec
```

to `.vimrc`

## requirements
`xdotool`, `wl-clipboard` and `jq` are required for this plugin to work in `sway`. `xdotool` and `xclip` are needed for this plugin to work under `xwindows`;

## How to use
1. open stata-gui.
2. open the do file.
3. press `<leader>l` to send current line to `stata`.
4. press `<leader>ss` to send selected lines to `stata`.
5. press `<leader>aa` to source the do file without echos.
