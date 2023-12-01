#SingleInstance force
#Include ..\Lib\funcs.ahk
; !没写完,大概这样.
global recording := 0
global recordstring := ""
CapsLock & f11:: {
    Global recording := !recording
    global recordstring
    if (recording) {
        ti.LB("开始录制", 600000)
    } else {
        filepath := A_ScriptDir "\rec_" A_Hour A_MM A_Sec ".ahk"
        ti.LB("结束录制:保存到 " filepath, 5000)
        f := FileOpen(filepath, "a")
        head := "
        (
            #SingleInstance Force
            F12::reload
            F11::{`n
        )"
        end := "}"
        f.Write(head . recordstring . end)
        recordstring := ""
        f.close()
        run("code.exe " filepath)
    }

}
; A_MSec 当前的毫秒数000
#HotIf recording
~LButton:: {
    MouseGetPos(&x, &y)
    global recordstring .= Format("sleep({}), click(`"{}, {}`")`n", A_TimeSincePriorHotkey, x, y, ThisHotkey)
    ; FileObj.WriteLine(Format("sleep({}), click(`"{}, {}`")", A_TimeSincePriorHotkey, x, y, ThisHotkey))
}
*k:: {
    global recordstring .= Format("sleep({}), send({})`n", A_TimeSincePriorHotkey, ThisHotkey)
    ; FileObj.WriteLine(Format("sleep({}), send({})", A_TimeSincePriorHotkey, ThisHotkey))
}

#HotIf

/* macro
WinActivate, Pulover's Macro Creator ahk_class AutoHotkeyGUI
Sleep, 333
Sleep, 344
.......
Click, 958, 241, 0
Sleep, 16
Click, 958, 238, 0
Sleep, 187
Click, 1263, 460 Left, Down
Sleep, 31
Click, 1263, 461, 0
Sleep, 16
Click, 1263, 462, 0
Sleep, 31
Click, 1264, 462, 0
Sleep, 47
Click, 1264, 462 Left, Up
.......















































