; 1. 鼠标在任务栏时滑轮调节音量,亮度(在最右边时)
; 2. win + 滑轮调节当前窗口透明度
; 3. shift + NumLock + 滑轮调节鼠标移动速度

; ==========o==========o==========o==========o==========o==========o 滑轮
; 鼠标在任务栏时滑轮调节音量,亮度(在最左边时)
#HotIf MouseIsOver(win_taskbar)
WheelUp:: {
    msx() < 60 ? tip.MM("鼠标速度: " MouseSpeed.change(1)) :
        msx() < 1760 ? send("{Volume_Up}") :
            Brightness.change("+10")
}
WheelDown:: {
    msx() < 60 ? tip.MM("鼠标速度: " MouseSpeed.change(-1)) :
        msx() < 1760 ? send("{Volume_down}") :
            Brightness.change("-10")
}

MouseIsOver(WinTitle) {
    MouseGetPos(, , &Winid)
    return WinExist(WinTitle " ahk_id " Winid)
}
#HotIf

; win + 滑轮调节当前窗口透明度
#f11::
LWin & WheelDown:: WinTransPlus(-30)
#f12::
LWin & WheelUp:: WinTransPlus(30)
WinTransPlus(num, hwnd := "A") {
    tp := WinGetTransparent(hwnd)
    tp := tp = "" ? 255 : tp
    tp += num
    tp := min(255, max(10, tp)) ;透明会穿透
    WinSetTransparent(tp, hwnd)
    tip.p("窗口透明度: " tp)
}

; shift + NumLock + 滑轮调节鼠标移动速度
#HotIf GetKeyState("NumLock", "p")
Shift & WheelUp:: tip.p("鼠标速度: " MouseSpeed.change(1))
Shift & WheelDown:: tip.p("鼠标速度: " MouseSpeed.change(-1))
#HotIf

; shift上下滑轮 => 左右滑轮  少用
; +WheelDown:: send("{WheelLeft}")
; +WheelUp:: send("{WheelRight}")
