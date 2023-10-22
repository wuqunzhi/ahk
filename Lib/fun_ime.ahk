; WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW 输入法
; 参考：
; https://zhuanlan.zhihu.com/p/425951648
; https://blog.csdn.net/liuyukuan/article/details/82291632
; https://github.com/mudssky/myAHKScripts/blob/main/scripts/switchIME.ahk
/*
        IMEid               ImeMode
CN 中   134481924           1025
CN 中   134481924           1   (中文模式输入英文字符，相当于ctrl.)
CN 英   134481924           0
EN      67699721            1
*/
; 美式键盘
isEn() {
    return getImeId() = 67699721 ;and getImeMode()=1
}
; 微软拼音英文模式
isCHying() {
    return getImeId() = 134481924 and getImeMode() = 0
}
; 微软拼音中文模式
isCHzhong() {
    return getImeId() = 134481924 and getImeMode() != 0
}
; 强制设置为美式键盘
setEnForce() {
    setImeId(67699721)
}
; 全部窗口设置英文
setCHyingAll() {
    save := A_DetectHiddenWindows
    DetectHiddenWindows true
    Aid := WinExist("A")
    idList := WinGetList(, , , "Program Manager")
    Loop idList.Length {
        WinActivate(idList[A_Index])
        setCHyingForce()
    }
    WinActivate("ahk_id " Aid)
    DetectHiddenWindows save
}
; 强制设置为微软拼音英文模式
setCHyingForce() {
    setImeId(134481924)
    setImeMode(0)
}
; 强制设置为微软拼音中文模式
setCHzhongForce() {
    setImeId(134481924)
    setImeMode(1)
}
; 强制设置为微软拼音中文模式且中文标点 ;!nowork
setCHzhong1025Force() {
    setImeId(134481924)
    setImeMode(1025)
}
; 设置鼠标光标: 0默认 1自定义
setCusor(mode := 0) {
    try {
        if mode {
            ; https://learn.microsoft.com/zh-cn/windows/win32/api/winuser/nf-winuser-setsystemcursor
            Cursor1 := "C:\\Windows\\Cursors\\custom\\beam_3.ani" ;自定义
            CursorHandle1 := DllCall("LoadCursorFromFile", "Str", Cursor1)
            Cursor2 := "C:\\Windows\\Cursors\\custom\\aero_4.ani" ;自定义
            CursorHandle2 := DllCall("LoadCursorFromFile", "Str", Cursor2)
            DllCall("SetSystemCursor", "Uint", CursorHandle1, "Int", 32513) ;选中文本时的鼠标
            DllCall("SetSystemCursor", "Uint", CursorHandle2, "Int", 32512) ;正常鼠标
        } else {
            Cursor1 := "C:\\Windows\\Cursors\\beam_m.cur" ;系统默认 (不是这个,不知道是哪个了)
            CursorHandle1 := DllCall("LoadCursorFromFile", "Str", Cursor1)
            Cursor2 := "C:\\Windows\\Cursors\\aero_arrow.cur" ;系统默认
            CursorHandle2 := DllCall("LoadCursorFromFile", "Str", Cursor2)
            DllCall("SetSystemCursor", "Uint", CursorHandle1, "Int", 32513) ;选中文本时的鼠标
            DllCall("SetSystemCursor", "Uint", CursorHandle2, "Int", 32512) ;正常鼠标
            ; SPI_SETCURSORS := 0x57    ;重新加载系统游标,不用这个因为鼠标会闪
            ; DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
        }
    } catch as e
        tip(type(e) " in " e.What ", which was called at line " e.Line)
    return
}

; 获取当前窗口进程的输入法id; 微软拼音 134481924 ; 美式键盘 67699721
getImeId() {
    try {
        DetectSave := A_DetectHiddenWindows
        DetectHiddenWindows True
        hWnd := WinExist("A")
        ThreadID := DllCall("GetWindowThreadProcessId", "UInt", hWnd, "UInt", 0)
        InputLocaleID := DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")
        DetectHiddenWindows DetectSave
        return InputLocaleID
    } catch as e
        tip(type(e) " in " e.What ", which was called at line " e.Line)
        ; MsgBox(type(e) " in " e.What ", which was called at line " e.Line)

}
;设置当前窗口进程的输入法id; 微软拼音(无论中英文) 134481924 ; 美式键盘 67699721
setImeId(IMEID) {
    try res := SendMessage(0x50, 0, IMEID, , "A")
    catch as e
        tip(type(e) " in " e.What ", which was called at line " e.Line)
        ; MsgBox(type(e) " in " e.What ", which was called at line " e.Line)
    return res
}
; 获取输入法mode EN:1,英:0,中:1或1025(中文标点)
getImeMode() {
    try {
        DetectSave := A_DetectHiddenWindows
        DetectHiddenWindows True
        hWnd := WinExist("A")
        DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
        res := SendMessage(0x283, 0x001, 0, , "ahk_id" . DefaultIMEWnd)
        ; 0x283 : WM_IME_CONTROL
        ; 0x001 : IMC_GETCONVERSIONMODE
        DetectHiddenWindows DetectSave
        Return res
    } catch as e
        tip(type(e) " in " e.What ", which was called at line " e.Line)
    ; 已知任务管理器会error
}
; 设置输入法mode EN:1,英:0,中:1或1025(中文标点)
setImeMode(mode) {
    try {
        DetectSave := A_DetectHiddenWindows
        DetectHiddenWindows True
        hWnd := WinExist("A")
        DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
        res := SendMessage(0x283, 0x002, mode, , "ahk_id" . DefaultIMEWnd)
        ; 0x283 : WM_IME_CONTROL
        DetectHiddenWindows DetectSave
        Return res
    } catch as e
        tip(type(e) " in " e.What ", which was called at line " e.Line)
}

; --------设置任务栏颜色
; TaskBar_SetAttr(1, 0xc1e3c791) ; <- Set gradient    with color 0xd7a78f ( rgb = 0x91c7e3 ) and alpha 0xc1
; TaskBar_SetAttr(2, 0xa1e3c791) ; <- Set transparent with color 0xd7a78f ( rgb = 0x91c7e3 ) and alpha 0xa1
; TaskBar_SetAttr(2) ; <- Set transparent
; TaskBar_SetAttr(3) ; <- Set blur
; TaskBar_SetAttr(0) ; <- Set standard value
; 该方法设置的颜色会在按到开始菜单等操作后恢复
TaskBar_SetAttr(accent_state := 0, gradient_color := "0x01000000") {
    try {
        static init, hTrayWnd, ver := DllCall("GetVersion") & 0xff < 10
        static pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19
        if !(init) {
            if (ver)
                throw Error("Minimum support client: Windows 10", -1)
            if !(hTrayWnd := DllCall("user32\FindWindow", "str", "Shell_TrayWnd", "ptr", 0, "ptr"))
                throw Error("Failed to get the handle", -1)
            init := 1
        }
        accent_size := VarSetStrCapacity(&ACCENT_POLICY, 16)
        NumPut((accent_state > 0 && accent_state < 4) ? accent_state : 0, ACCENT_POLICY, 0, "int")
        if (accent_state >= 1) && (accent_state <= 2) && (RegExMatch(gradient_color, "0x[[:xdigit:]]{8}"))
            NumPut(gradient_color, ACCENT_POLICY, 8, "int")
        VarSetStrCapacity(&WINCOMPATTRDATA, 4 + pad + A_PtrSize + 4 + pad)
            && NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "int")
            && NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad, "ptr")
            && NumPut(accent_size, WINCOMPATTRDATA, 4 + pad + A_PtrSize, "uint")
        if !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hTrayWnd, "ptr", &WINCOMPATTRDATA))
            throw Error("Failed to set transparency / blur", -1)
        return true
    } catch as e
        tip(type(e) " in " e.What ", which was called at line " e.Line)
}