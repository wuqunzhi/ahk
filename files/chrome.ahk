; ; ==========o==========o==========o==========o==========o==========o chrome
; SetTitleMatchMode "RegEx"

#HotIf WinActive(win_chrome)
<!h:: send("^+{Tab}")
<!l:: send("^{Tab}")
<^+h:: send("^t"), setCHyingForce(), sleep(200), send("chrome://history/{enter}")
<!s:: send("!d* ")
^o::!left
^i::!right
CapsLock & t:: switchChromeAddress("gb")
#HotIf

; -------------------------------- 防vimmium失效的地方补充快捷键
vim_Chrome(vim?) {
    static use := 1
    if (!isset(vim))
        return use
    use := (vim = -1) ? !use : vim
    return use

}


GroupAdd("vimiumfix", "^OneTab - Google Chrome")
GroupAdd("vimiumfix", "^无标题 - Google Chrome")
GroupAdd("vimiumfix", "chrome-extension")
; GroupAdd("vimiumfix", "Chrome 应用商店")
GroupAdd("vimiumfix", "\.pdf - Google")
GroupAdd("vimiumfix", "^设置 - Google Chrome")

#HotIf WinActive(win_chrome " ahk_group vimiumfix")
^[:: {
    vim_Chrome(-1)
    KeyWait("[")
}
#HotIf WinActive(win_chrome " ahk_group vimiumfix") and !vim_Chrome()
:*x?b0z:asdasd:: vim_Chrome(-1)

#HotIf WinActive( win_chrome " ahk_group vimiumfix") and vim_Chrome()

;keybindings please don't conflict with zvim
; $t:: send("^t") ;confliuiot with cap t
i:: vim_Chrome(0)
q:: vim_Chrome(0)
a:: send("^+{Tab}")
d:: send("^{Tab}")
<+x:: send("^+t")
k:: send("{wheelup}")
j:: send("{wheeldown}")
w:: send("{wheelup}")
s:: send("{wheeldown}")
#HotIf

; :*x?b0z:c1:: imgclick("img/chrome_onetab.bmp", 1)

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
        clickB("28,18")
    ; Click(x "," y ",0")
} */
; {
;     ;Cap e 浏览器转换ahk v1和v2
;     MouseGetPos &x,
;         &y
;     Click "540, 157"
;     sleep 200
;     Click "540, 203"
;     sleep 200
;     click x . "," . y ",0"
; }