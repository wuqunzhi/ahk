; ==========o==========o==========o==========o==========o==========o global
#HotIf
~esc:: removeAllTip()
CapsLock Up:: send("{esc}") ;, tipLM("esc")
>!CapsLock:: SetCapsLockState(GetKeyState("CapsLock", "T") ? "AlwaysOff" : "AlwaysOn")
>!NumLock:: SetNumLockState(GetKeyState("NumLock", "T") ? "AlwaysOff" : "AlwaysOn")
<!CapsLock:: LoopRelatedWindows()

NumLock & k::#k
NumLock & j::#j
NumLock & i::#i
NumLock & p::#p

#HotIf GetKeyState("LAlt", "p")
; CapsLock::+Tab
#HotIf
; o==========o==========o==========o==========o VirtualDesktop
#CapsLock:: VirtualDesktop.showCycleRight()
#^n:: VirtualDesktop.Create().Show()
#^w:: VirtualDesktop.Current.Remove()
#^h:: VirtualDesktop.showCycleLeft()
#^l:: VirtualDesktop.showCycleRight()


; >^>!/::^!/
; #HotIf !GetKeyState("ctrl", 'p')
; Ralt:: send("RButton")    ;shift f10
; Ralt::RButton    ;shift f10
; #HotIf
CapsLock & f1:: ocr()
CapsLock & end:: togglegame()
CapsLock & down:: moveD(1)
CapsLock & up:: moveU(1)
CapsLock & left:: moveL(1)
CapsLock & right:: moveR(1)
CapsLock & m::AppsKey    ;shift f10
CapsLock & n::LButton
CapsLock & Ralt::RButton
CapsLock & w:: wheelU()
CapsLock & s:: wheelD()
CapsLock & d::Delete
CapsLock & b::BackSpace
CapsLock & h::left
CapsLock & l::right
CapsLock & j::down
CapsLock & k::up
CapsLock & v:: zvim.go("e_n")
CapsLock & i:: zvim.go("i")
CapsLock & g:: (zvim.mode == "g_n") ? zvim.go('i') : zvim.go("g_n")
CapsLock & o::Enter
CapsLock & p:: autorun(A_Clipboard)
CapsLock & e:: autorun(A_Clipboard)
CapsLock & space:: toggleTouchpad()
CapsLock & t:: A_Clipboard := transtable(A_Clipboard), send("^v") ;!todo?
CapsLock & r:: transRaw() ;!todo?
CapsLock & y:: copyandshow(debugInfo('w'))
CapsLock & a:: appendCopy()
CapsLock & c:: writeAndShowCBH()
CapsLock & f::^!0 ;有道词典
CapsLock & 1:: private.nas()

>!p:: WinSetAlwaysOnTop(-1, "A"), top := winGetAlwaysOnTop("A") ? "ontop" : "offtop", tipRB(top ": " WinGetTitle("A"))
>!+p:: WinSetAlwaysOnTop(0, "A"), top := winGetAlwaysOnTop("A") ? "ontop" : "offtop", tipRB(top ": " WinGetTitle("A"))
#m:: WinToggleMaximize()
#n:: WinMinimize("A")
#c:: winCenter()
#j:: runOrActivate(win_chrome, 'b', 'a', "chrome.exe")
#k:: runOrActivate(win_vscode, 'b', 'a', "code.exe")
; #k:: runOrActivate([win_vscode, "- Note - "], 'b', 'a', "code.exe")
#o:: runOrActivate(win_vscodeNote, 'at', 'a', "code D:\vscodeDeemos\Note")
#e:: runOrActivate(win_explorer, 'b', 'a', "explorer.exe")
>!j:: runOrActivate(win_chrome, 'b', 'a', "chrome.exe")
>!k:: runOrActivate([win_vscode, "- Note - "], 'b', 'a', "code.exe")
#+e:: run("explorer.exe")
#t:: runOrActivate(win_wt, 'b', 'a', "wt.exe")
#w:: send("{blink}^!w"), SetTimer(focus_wx, -10)

#a:: send("{blink}^!z")     ; toggle qq
#q:: send("{blink}^!{f10}") ; toggle qqmusic
#y:: runOrActivate(win_cloudmusic, 'c', 'sa', dk2 "/wyy")

GroupAdd("games", "ahk_class Engine")
#HotIf WinExist("ahk_group games")
#g:: runOrActivate("ahk_group games", 'at', 'a')
#HotIf WinExist(win_steam)
#s:: runOrActivate(win_steam, 'at', 'a')
#HotIf

#1:: winSetCaption(-1)


; logi option
+!PgDn:: VirtualDesktop.showCycleRight()
+!PgUp:: VirtualDesktop.showCycleLeft()


; o==========o==========o==========o==========o==========o c-hjkl
<^u:: send("{Blink}{bs}")
<^b::^u ;!!!c-u c-d翻页
GroupAdd("noc_hjkl", win_vscode)
GroupAdd("noc_hjkl", win_obsidian)
GroupAdd("noc_hjkl", win_idea)
GroupAdd("noc_hjkl", win_woz)
#HotIf !WinActive("ahk_group noc_hjkl")
<^j:: send("{blink}{down}")
<^k:: send("{blink}{up}")
<^l:: send("{blink}{enter}")
<^h:: send("{blink}{esc}")
<^+j:: send("{blink}{tab}")
<^+k:: send("{blink}+{tab}")
<^!l:: send("{blink}^{enter}")
<^+l:: send("{blink}+{enter}")
!l::^Tab
!h::^+tab
; <^o:: send("{blink}^{enter}")
; <^+o:: send("{blink}+{enter}")
; <!h:: send("{blink}{left}")
; <!l:: send("{blink}{right}")
#HotIf

; o==========o==========o==========o==========o==========o c-w , c-s-w
; ^+w:: WinClose("A"), tip("WinClose A", 1000, 0.5, 0.5)    ;关闭 to obsidian
GroupAdd("noc_w", win_vscode)
GroupAdd("noc_w", win_chrome)
GroupAdd("noc_w", win_edge)
; GroupAdd("noc_w", win_explorer) ; 资源管理器
GroupAdd("noc_w", win_desktop)  ; 桌面
GroupAdd("noc_w", win_taskbar)  ; 任务栏
GroupAdd("noc_w", win_wt)       ; windows ternimal
GroupAdd("noc_w", win_vim)      ; vim
GroupAdd("noc_w", win_idea)     ; idea
#HotIf !WinActive("ahk_group noc_w") and not ingame
^+w:: pid := WinGetPID("A"), tipMM("taskkill " ProcessClose(pid))    ;强制关闭
; WinKill("A"),
^w:: WinClose("A"), tipLM("WinClose A")    ;关闭
#HotIf

; o==========o==========o==========o==========o==========o a-`
GroupAdd("noa_quote", win_vscode)  ; 不在谷歌,vscode
#HotIf !WinActive("ahk_group noa_quote")
<!`:: run("cmd", A_Desktop)
#HotIf

; o==========o==========o==========o==========o==========o 调试相关
CapsLock & Numpad1:: runOrActivate("Window Spy", "c", 'a', "D:\AutoHotkey_2.0.10\WindowSpy.ahk")
CapsLock & Numpad2::
{
    ; Cap f2 ;打开脚本主窗口
    WinShow("ahk_id" . A_ScriptHwnd)    ;WinShow可以检测隐藏
    WinActivate("ahk_id" . A_ScriptHwnd)
    send ("{f5}")
}

CapsLock & Numpad3:: listWins(, showEach := true)
CapsLock & Numpad4:: ahkManager()
CapsLock & Numpad5:: copyandshow(debugInfo('w1'))
CapsLock & q:: run("https://wyagd001.github.io/v2/docs/lib/" A_Clipboard ".htm")
CapsLock & LButton:: tip(debugInfo('w'), 10000, 1, 1, 12)
#HotIf


; o==========o==========o==========o==========o==========o 热字串
; https://wyagd001.github.io/v2/docs/Hotstrings.htm#Options
; 符号后面加`转中文符号
:*?:.``::。
:*?:,``::，
:*?:\``::、

; :?*x:]t:: SendInput Format("{}:{}:{}", A_Hour, A_Min, A_Sec) ;在vscodeVim中有bug,估计是input太快的原因
; :?*x:]d:: SendInput Format("{}-{}-{}", A_YYYY, A_MM, A_DD)
:?*cx:]d:: sendInputVimFix(Format("{}-{}-{}", A_YYYY, A_MM, A_DD))
:?*cx:]t:: sendInputVimFix(Format("{}:{}:{}", A_Hour, A_Min, A_Sec))
:?*cx:]T:: sendInputVimFix(Format("{}-{}-{} {}:{}:{}", A_YYYY, A_MM, A_DD, A_Hour, A_Min, A_Sec))
sendInputVimFix(str) {
    loop parse str {
        SendInput(A_LoopField)
        Sleep(60)
    }
}