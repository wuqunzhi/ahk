; ; ==========o==========o==========o==========o==========o==========o chrome
#HotIf WinActive(win_chrome)
<!h:: send("^+{Tab}")
<!l:: send("^{Tab}")
<!<+h::A
<!<+l::D
^o::!left
^i::!right
#HotIf

; -------------------------------- 给vimmium接控不了的网页补充快捷键
GroupAdd("vimiumfix", "^OneTab - Google Chrome")
GroupAdd("vimiumfix", "^无标题 - Google Chrome")
GroupAdd("vimiumfix", "chrome-extension")
; GroupAdd("vimiumfix", "Chrome 应用商店")
GroupAdd("vimiumfix", "\.pdf - Google")
GroupAdd("vimiumfix", "^设置 - Google Chrome")
win_vimiumfix := win_chrome " ahk_group vimiumfix"

#HotIf WinActive(win_vimiumfix)
^[:: Chrome.vim(-1), KeyWait("[")
#HotIf WinActive(win_vimiumfix) and !Chrome.vim()
:*x?b0z:asdasd:: Chrome.vim(-1)

#HotIf WinActive(win_vimiumfix) and Chrome.vim()
i:: Chrome.vim(0)
q:: Chrome.vim(0)
a:: send("^+{Tab}")
d:: send("^{Tab}")
<+x:: send("^+t")
k:: send("{wheelup}")
j:: send("{wheeldown}")
w:: send("{wheelup}")
s:: send("{wheeldown}")
#HotIf

class Chrome extends VimController {
}