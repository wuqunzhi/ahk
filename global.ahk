; ==========o==========o==========o==========o==========o==========o global
#HotIf
f3:: ocr()
~esc:: tip.removeAllTip()
CapsLock Up:: send("{esc}") ;, ti.LM("esc")
>!CapsLock:: SetCapsLockState(GetKeyState("CapsLock", "T") ? "AlwaysOff" : "AlwaysOn")
>!NumLock:: SetNumLockState(GetKeyState("NumLock", "T") ? "AlwaysOff" : "AlwaysOn")
<!CapsLock:: LoopRelatedWindows()


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
CapsLock & e:: autorun(A_Clipboard)
CapsLock & space:: toggleTouchpad()
CapsLock & y:: copyandshow(debugInfo('w'))
CapsLock & a:: appendCopy()
CapsLock & c:: writeAndShowCBH()
CapsLock & f::^!0 ;有道词典
CapsLock & r:: transRaw() ;!todo?
CapsLock & t:: A_Clipboard := transtable(A_Clipboard), send("^v") ;!todo?

NumLock & Numpad1:: winSetCaption(-1)

tmp() {
    ; run("http://127.0.0.1:8080")
}
CapsLock & `:: markWindow.maymark()
; CapsLock & 1:: markWindow.toggle(1)
CapsLock & 1:: privatefunc.nas()
CapsLock & 2:: markWindow.toggle(2)
CapsLock & 3:: markWindow.toggle(3)
CapsLock & 4:: markWindow.toggle(4)
CapsLock & 5:: markWindow.toggle(5)
CapsLock & 6:: markWindow.toggle(6)
CapsLock & 7:: markWindow.toggle(7)
CapsLock & 8:: markWindow.toggle(8)
CapsLock & 9:: markWindow.toggle(9)
>!l:: lockComputer()
#l:: markWindow.toggle(11)
#+l:: markWindow.mark(11)
#+h:: markWindow.mark(12)
#h:: markWindow.toggle(12)
#+;:: markWindow.mark(13)
#;:: markWindow.toggle(13)
CapsLock & alt:: return

>!p:: WinSetAlwaysOnTop(-1, "A"), top := winGetAlwaysOnTop("A") ? "ontop" : "offtop", tip.RB(top ": " WinGetTitle("A"))
>!+p:: WinSetAlwaysOnTop(0, "A"), top := winGetAlwaysOnTop("A") ? "ontop" : "offtop", tip.RB(top ": " WinGetTitle("A"))
#m:: WinToggleMaximize()
#n:: WinMinimize("A")
#c:: winCenter()
#j:: runOrActivate(win_chrome, 'b', 'a', "chrome.exe")
#k:: runOrActivate(win_vscode, 'b', 'a', "code")
>!k:: runOrActivate(win_vscode, 'b', 'a', "code")
; >!k:: runOrActivate([win_vscode, "- Note - "], 'b', 'a', "code.exe")
; #k:: runOrActivate([win_vscode, "- Note - "], 'b', 'a', "code.exe")
#o:: runOrActivate(win_vscodeNote, 'at', 'a', "code D:\vscodeProjects\Note")
#e:: runOrActivate(win_explorer, 'b', 'a', "explorer.exe")
>!j:: runOrActivate(win_chrome, 'b', 'a', "chrome.exe")
#+e:: run("explorer.exe")
#t:: runOrActivate(win_wt, 'b', 'a', "wt.exe")
#w:: send("{blink}^!w"), SetTimer(focus_wx, -10)
#a:: send("{blink}^!z")     ; toggle qq
#q:: send("{blink}^!{f10}") ; toggle qqmusic
#y:: runOrActivate(win_cloudmusic, 'c', 'sa', A_desktop2 "/wyy")

; Windows + Shift + 向左键或向右键 : 将桌面上的应用或窗口从一台显示器移动至另一台显示器。
; #+h::#+left
; #+l::#+Right

GroupAdd("games", "ahk_class Engine")
GroupAdd("games", "ahk_class YYGameMakerYY")
GroupAdd("games", "ahk_class UnityWndClass")
#HotIf WinExist("ahk_group games")
#g:: runOrActivate("ahk_group games", 'at', 'a')
#HotIf WinExist(win_steam)
#s:: runOrActivate(win_steam, 'at', 'a')
#HotIf


; o==========o==========o==========o==========o==========o c-hjkl
; <^b::^u ;!!!c-u c-d翻页
<^u:: send("{Blink}{bs}")
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
^+w:: pid := WinGetPID("A"), tip.MM("taskkill " ProcessClose(pid))    ;强制关闭
; WinKill("A"),
^w:: WinClose("A"), tip.LM("WinClose A")    ;关闭
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
CapsLock & LButton:: tip.RB(debugInfo('w'), 10000)
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
:*?zc:gacp::git add . & git commit -m "stupid" & git push
sendInputVimFix(str) {
    loop parse str {
        SendInput(A_LoopField)
        Sleep(60)
    }
}