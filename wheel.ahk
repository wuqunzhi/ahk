; 1. 鼠标在任务栏时滑轮调节音量,亮度(在最右边时)
; 2. win + 滑轮调节当前窗口透明度
; 3. shift + NumLock + 滑轮调节鼠标移动速度

; ==========o==========o==========o==========o==========o==========o 滑轮
; 鼠标在任务栏时滑轮调节音量,亮度(在最左边时)
#HotIf MouseIsOver(win_taskbar)
WheelUp:: msx() < 1850 ? send("{Volume_Up}") : (Brightness.changeBrightness("+10"))
WheelDown:: msx() < 1850 ? send("{Volume_Down}") : (Brightness.changeBrightness("-10"))

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
    tp := tp >= 10 ? tp <= 255 ? tp : 255 : 10    ;透明会穿透
    WinSetTransparent(tp, hwnd)
    tip.p("窗口透明度: " tp)
}

; shift + NumLock + 滑轮调节鼠标移动速度
#HotIf GetKeyState("NumLock", "p")
+WheelDown:: MouseSpeedPlus(-1)
+WheelUp:: MouseSpeedPlus(1)
MouseSpeedPlus(num) {
    SPI_GETMOUSESPEED := 0x70
    SPI_SETMOUSESPEED := 0x71
    MouseSpeed := 0
    DllCall("SystemParametersInfo", "UInt", SPI_GETMOUSESPEED, "UInt", 0, "Ptr*", &MouseSpeed, "UInt", 0)    ;获取鼠标速度
    MouseSpeed += num
    if (MouseSpeed >= 0 and MouseSpeed <= 20)
        DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "Ptr", MouseSpeed, "UInt", 0)    ;设置鼠标速度(1-20)
    MouseSpeed := MouseSpeed >= 0 ? MouseSpeed <= 20 ? MouseSpeed : 20 : 0
    tip.p("鼠标速度: " MouseSpeed "`n(你需要10)")
}
#HotIf

; shift上下滑轮 => 左右滑轮  少用
; +WheelDown:: send("{WheelLeft}")
; +WheelUp:: send("{WheelRight}")
