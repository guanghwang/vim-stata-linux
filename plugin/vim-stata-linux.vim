" Vim to Stata
"==============================================================================
"Script Description: Run selected do-file in Stata from Vim
"Script Platform: Linux Swaywm and Stata 14, 15
"Script Version: 0.02
"Last Edited: Dec 19, 2019
"Authors:  Guanghua Wang
"Notes:
"   1. This plugin is motivated by zizhongyan/vim-stata and kylebarron/stata-exec
"   2. This plugin only workers on Linux.
"   3. `xdotool` and `wl-clipboard` are needed for this plugin to work
"==============================================================================
fun! RemoveComment()
python3 << EOF
import vim
import sys
import os
import re
with open('/tmp/stata-exec_code', 'r') as file:
    filedata = file.read()
# 1. remove /*    */
filedata = re.sub(r'\/\*[\s\S]*?\*\/', r"", filedata)
# 2. remove ///
filedata = re.sub(r'(/){3}.*?(\r\n|\r|\n)', r"", filedata)
# 3. remove //coments
filedata = re.sub(r'(/){2}.*?(\r\n|\r|\n)', r"\2", filedata)
with open('/tmp/stata-exec_code', 'w') as file:
    file.write(filedata)
EOF
endfun

fun! RunTemp()
python3 << EOF
import vim
import sys
import os
import re
with open('/tmp/stata-exec_code', 'r') as file:
    filedata = file.read()
def run_yan():
    cmd = ("""
           thiswks="$(swaymsg -t get_workspaces | jq '.[] \
             | select(.focused==true) | .num')" &&
           thiswindow="$(swaymsg -t get_tree | jq '.. \
             | (.nodes? // empty)[] | select(.focused==true) | .pid')" &&
           wl-copy -c &&
           cat /tmp/stata-exec_code | wl-copy &&
           swaymsg '[title="[Ss]tata.*"] focus' &&
           xdotool \
             key --clearmodifiers --delay 100 ctrl+v Return &&
           swaymsg '[pid=$thiswindow workspace='$thiswks'] focus' &&
           wl-copy -c
           """
           )
    os.system(cmd)
run_yan()
EOF
endfun

fun! RunSelection()
    let selectedLines = getbufline('%', line("'<"), line("'>"))
    if col("'>") < strlen(getline(line("'>")))
        let selectedLines[-1] = strpart(selectedLines[-1], 0, col("'>"))
    endif
    if col("'<") != 1
        let selectedLines[0] = strpart(selectedLines[0], col("'<")-1)
    endif
    call writefile(selectedLines, "/tmp/stata-exec_code")
    call RemoveComment()
    call RunTemp()
endfun

fun! RunCline()
    let selectedLines = getline('.') " string
    call writefile([selectedLines], "/tmp/stata-exec_code")
    call RemoveComment()
    call RunTemp()
endfun

fun! RunAboveline()
    let lines = getline(1, line(".") - 1) " lists
    call writefile(lines, "/tmp/stata-exec_code")
    call RemoveComment()
    call RunTemp()
endfun

fun! SourceDofile()
    call writefile(["do "], "/tmp/stata-exec_code", "b")
    let selectedDofile = expand("%:p")
    call writefile([selectedDofile], "/tmp/stata-exec_code", "a")
    call RunTemp()
endfun

noremap  <Plug>(RunSelection)             :<C-U>call RunSelection()<CR><CR>
map  <buffer> <silent> <leader>ss         <Plug>(RunSelection)

noremap  <Plug>(RunCline)                 :<C-U>call RunCline()<CR><CR>
map  <buffer> <silent> <leader>l          <Plug>(RunCline)

noremap  <Plug>(RunAboveline)             :<C-U>call RunAboveline()<CR><CR>
map  <buffer> <silent> <leader>su         <Plug>(RunAboveline)

noremap  <Plug>(SourceDofile)             :<C-U>call SourceDofile()<CR><CR>
map  <buffer> <silent> <leader>aa         <Plug>(SourceDofile)

"command! Vim2StataToggle call RunDoLines()<CR><CR>
