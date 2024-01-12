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

class Chrome extends VimControl {
}

; :*x?b0z:c1:: clk.img("img/chrome_onetab.bmp", 1)

; h := 110
; capslock & 1:: click("51, " h)
; capslock & 2:: click("141, " h)
; capslock & 3:: click("251, " h)
; capslock & 4:: click("352, " h)
; capslock & 5:: click("441, " h)
; CapsLock & f:: send("/"), sleep(50), send("\b\b{left 2}")
/* CapsLock & s:: {
    ;toggle span 第一个标签组
    colors := "0x5F6368 0xFA9031  0x1A73E8 0xD93025 0xF9ab00 0x188038 0xD01884 0xbF7dF8 0x007B83 0xFA903E"
    ; MouseGetPos(&x, &y)
    if (InStr(colors, PixelGetColor(28, 18)))
        clk.back("28,18")
    ; Click(x "," y ",0")
} */
