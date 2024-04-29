; ; ==========o==========o==========o==========o==========o==========o chrome
#HotIf WinActive(win_chrome)
; MButton::Numpad2
; :*?zc:aft2:::after2022
<!h:: send("^+{Tab}")
<!l:: send("^{Tab}")
<!<+h::A
<!<+l::D
<^+h:: send("^t"), IME.setCHying(), sleep(200), send("chrome://history/{enter}")
^o::!left
^i::!right
#HotIf

; -------------------------------- 防vimmium失效的地方补充快捷键
GroupAdd("vimiumfix", "^OneTab - Google Chrome")
GroupAdd("vimiumfix", "^无标题 - Google Chrome")
GroupAdd("vimiumfix", "chrome-extension")
; GroupAdd("vimiumfix", "Chrome 应用商店")
GroupAdd("vimiumfix", "\.pdf - Google")
GroupAdd("vimiumfix", "^设置 - Google Chrome")

#HotIf WinActive(win_chrome " ahk_group vimiumfix")
^[:: Chrome.vim(-1), KeyWait("[")
#HotIf WinActive(win_chrome " ahk_group vimiumfix") and !Chrome.vim()
:*x?b0z:asdasd:: Chrome.vim(-1)

#HotIf WinActive(win_chrome " ahk_group vimiumfix") and Chrome.vim()
i:: Chrome.vim(0)
q:: Chrome.vim(0)
a:: send("^+{Tab}")
d:: send("^{Tab}")
<+x:: send("^+t")
j:: send("{wheeldown}")
k:: send("{wheelup}")
w:: send("{wheelup}")
s:: send("{wheeldown}")
#HotIf

class Chrome extends VimController {
}