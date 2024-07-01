#SingleInstance Force
#Warn Unreachable, off

; https://wyagd001.github.io/v2/docs/

init()
#Include config.ahk ;放前面
#Include private.ahk
#Include Lib/entry.ahk
#Include zvim.ahk               ; vim键位操作鼠标 hjkl移动鼠标窗口等
#Include clipboard.ahk          ; 记录剪贴板历史
#Include ime.ahk                ; 输入法相关
#Include keyMap.ahk             ; 改键
#Include wheel.ahk              ; 鼠标滚轮相关
#Include files/entry.ahk
#Include global.ahk ;放最后

#SuspendExempt true
CapsLock & \:: Suspend  ; Ctrl+Alt+S
#SuspendExempt false


init() {
    tip.LB(A_ScriptName " running. AHK " A_AhkVersion)
    SetTitleMatchMode("RegEx")     ;大小写敏感
    ; **ahk v2开始 croodMode 默认全是client**
    CoordMode("ToolTip", "Screen") ;作用于ToolTip.
    CoordMode("Pixel", "Client")   ;作用于PixelGetColor, PixelSearch 和 ImageSearch.
    CoordMode("Caret", "Client")   ;作用于CaretGetPos.
    CoordMode("Menu", "Client")    ;作用于Menu.Show 方法, 当为其指定坐标时.
    CoordMode("Mouse", "Client")   ;作用于MouseGetPos, Click 和 MouseMove, MouseClick 和 MouseClickDrag.
    SetMouseDelay(-1)
    SetCapsLockState "AlwaysOff"
    ; SetNumLockState "AlwaysOn"
    ; SetTimer(police, 1000)
    disableWinL()
}