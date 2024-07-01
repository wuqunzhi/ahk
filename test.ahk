; #NoEnv 是v2默认行为, 所以该指令本身已经被删除. 如果等效的内置变量不可用, 请使用 EnvGet 代替.
; SendMode 默认为输入(Input) 而不是事件(Event).
; 标题匹配模式默认为 2 而不是 1.
; 删除了 SetBatchLines, 因此所有脚本都以全速运行(等同于 v1 中的 SetBatchLines -1).
; SetWorkingDir 工作目录默认为 A_ScriptDir. A_InitialWorkingDir 包含由启动 AutoHotkey 的进程设置的工作目录.
; CoordMode 默认为 Client(在 v1.1.05 版中加入), 而不是 Window.
; 脚本文件(但不包括 由 脚本读取的文件) 的默认编码现在是 UTF-8 而不是 ANSI(CP0). 和以前一样, 这可以通过 /CP 命令行开关来覆盖.
; #NoTrayIcon ;用了这行没法SingleInstance,难退出
;---------------------------------
#SingleInstance Force
#Warn Unreachable, off
#Include config.ahk
#Include private.ahk
#Include Lib/entry.ahk
#SuspendExempt true
f7:: Suspend
#SuspendExempt false
;---------------------------------
SetTitleMatchMode("regex")
DetectHiddenWindows(1)
SetMouseDelay(-1)

resize(hwnd, x, y, w, h) {
    DllCall("SetWindowPos", "UInt", hwnd, "UInt", 0, "Int", x, "Int", y, "Int", w, "Int", h, "UInt", 0x400)
}


win_ocr := "Umi-OCR v2.1.2 ahk_exe Umi-OCR.exe ahk_class Qt5152QWindowOwnDCIcon"
w := WinExist(win_git) ? win_git : win_cmd
6:: test()
test() {
    WinRestore(win_ocr)
    ; a := Run("control.exe bthprops.cpl")
    ; a.call()
    ; tip.p(['1', '2', '3', '4', '5'].ToString())
}

; Windows 键+ Home – 最小化除活动窗口之外的所有窗口。
; MakeWindowDraggable()
; winSetCaption(-1)

t := {
    f5: tip.p.Bind(, 3)
}

wintoggle0x20(hwnd) {
    static u := 0
    u := !u
    ; tip.p(u)
    if (u) {
        WinSetExStyle("+0x20", hwnd)
        winSetCaption(0, hwnd)
    }
    else {
        WinSetExStyle("-0x20", hwnd)
        winSetCaption(1, hwnd)
    }
}


; CoordMode("ToolTip", "Screen")
; SetMouseDelay 0                                           ; SendInput 可能会降级为 SendEvent, 此时会有 10ms 的默认 delay
; SetWinDelay 0                                             ; 默认会在 activate, maximize, move 等窗口操作后睡眠 100ms
; ProcessSetPriority "High"

; todo
; offpin all
;
sendRequset() {
    oHttp := ComObject("WinHttp.Winhttprequest.5.1")
    ; oHttp.open("GET", "https://api.live.bilibili.com/xlive/web-ucenter/v1/xfetter/GetWebList?page=1")
    oHttp.open("GET", "https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/w_live_users?size=10")
    oHttp.send()
    MsgBox oHttp.responseText
}

winScroll(wintitle := "A", cont?) {
    ; https://www.autohotkey.com/board/topic/87514-sendmessage-scroll-down-a-certain-number-of-lines/
    ; MouseGetPos(, , &win, &cont)
    ; ControlGetFocus, control, A
    ; MsgBox(cont)
    ; SB_LINEUP = 0
    ; SB_LINEDOWN = 1
    ; SB_PAGEUP = 2
    ; SB_PAGEDOWN = 3
    ; SB_THUMBPOSITION = 4
    ; SB_THUMBTRACK = 5
    ; SB_TOP = 6
    ; SB_BOTTOM = 7
    ; SB_ENDSCROLL = 8
    SendMessage(0x115, 1, 0, , "A")
}

f1() {
    MouseGetPos(, , &win, &cont)
    ; http://www.autohotkey.com/forum/topic7976.htmlk
    SendMessage(0x0002, , , cont, "A") ; WM_DESTROY
    SendMessage(0x0082, , , cont, "A") ; WM_NCDESTROY
    WinRedraw("A")
}
f2() {
    ; http://www.autohotkey.com/forum/viewtopic.php?t=2859#1816
    MouseGetPos(, , &win, &cont)
    SendMessage(0x10, , , cont, "A") ; WM_CLOSE
}

toggleDesktop() {
    ; https://learn.microsoft.com/en-us/windows/win32/shell/shell-application
    ; 同win+d
    ComObject("Shell.Application").ToggleDesktop()
}

/*
----------------------------------------
循环与切换: 见 files\slaythespire.ahk fxnxl
----------------------------------------
LWin & h::
if toggle := !toggle
{
WinHide ahk_class Shell_TrayWnd
WinHide Start ahk_class Button
}
else
{
WinShow ahk_class Shell_TrayWnd
WinShow Start ahk_class Button
}
return
----------------------------------------
*/
; RegWrite "Test Value", "REG_SZ", "HKEY_LOCAL_MACHINE\SOFTWARE\TestKey", "MyValueName"
; RegWrite(1, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System","DisableLockWorkstation")
; tip(A_ComSpec)
; run('code D:\vscodeDeemos\Note' )


; ==========o==========o==========o==========o==========o other
/*
ImageSearch PixelSearch
SoundPlay
A_TickCount 时间戳A_MSec也有
ListLines, ListVars
https: // wyagd001.github.io / v2 / docs / Scripts.htm#lib #include和库文件
; 当Ctrl被按住时,NumLock产生Pause的按键代码,所以使用^Pause来代替^NumLock.
; 长行:https://wyagd001.github.io/v2/docs/Scripts.htm#continuation
; 鼠标滑动手势 ; https://meta.appinn.net/t/topic/32120
; 设置亮度: powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,50)

*/
; ==========o==========o==========o==========o==========o文件
/*
FileReadLine 读取文件行
FileRead 读取文件
FileSelect:显示可以的选择文件/文件夹的标准对话框.
iniread , iniwrite ,inidelete 读取ini格式文件
FileCreateShortcut
FileExist
; 获取目录,文件名,文件夹,扩展名等:
FullFileName := "C:\My Documents\Address List.txt"
SplitPath FullFileName, &name, &dir, &ext, &name_no_ext, &drive
*/
; ==========o==========o==========o==========o==========o Edit
;  在所有的编辑控件中的轻松删除单词的快捷键. 没什么用
; #HotIf ActiveControlIsOfClass("Edit")
; ActiveControlIsOfClass(Cls) {
;     FocusedControl := 0
;     try FocusedControl := ControlGetFocus("A")
;     MsgBox(FocusedControl)
;     FocusedControlClass := ""
;     try FocusedControlClass := WinGetClass(FocusedControl)
;     MsgBox(FocusedControlClass)
;     return (FocusedControlClass = Cls)
; }
; ==========o==========o==========o==========o==========o inputHook
; #inputHook :创建一个对象, 该对象可用于收集或拦截键盘输入.
; 示例1:等待用户按下任意一个键.
/* MsgBox KeyWaitAny()
MsgBox KeyWaitAny("V")    ; 再来一遍, 但不阻止按键.
KeyWaitAny(Options := "") {
    ih := InputHook(Options)
    if !InStr(Options, "V")
        ih.VisibleNonText := false
    ih.KeyOpt("{All}", "E")    ; 结束
    ih.Start()
    ih.Wait()
    return ih.EndKey    ; 返回按键名称
} */
; ==========o==========o==========o==========o==========o inputHook
/*
https://www.autohotkey.com/board/topic/57245-how-can-i-find-if-other-script-is-pausedsuspended-4-pausing/
OnMessage(0x9999, "CheckPauseSuspend")
Return
CheckPauseSuspend(wParam) {
    If wParam = 1
        Return A_IsSuspended
    else if wParam = 2
        Return A_IsPaused
}
*/

; ==========o==========o==========o==========o==========o gui
/*
MyGui.Add("Link", , 'Links may be used anywhere in the text like <a id="A">this</a> or <a id="B">that</a>')
EditPaste ;指定的字符串粘贴到 Edit 控件插入符号(文本插入点) 处
EditGetLine 返回 Edit 控件中指定行的文本.
MyGui := Gui(, "Title of Window")
MyGui.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner")  ; +Owner 避免显示任务栏按钮.
MyGui.Add("Text",, "Some text to display.")
MyGui.Show("NoActivate")  ; NoActivate 让当前活动窗口继续保持活动状态.
; 从文件夹中获取文件名列表并把它们放入 ListView:
Loop Files, A_MyDocuments "\*.*"
    LV.Add(, A_LoopFileName, A_LoopFileSizeKB)
*/
