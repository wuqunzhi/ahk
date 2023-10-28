/*
* @Author: wuqunzhi 794817076@qq.com
* @Date: 2022-10-13 20:16:05
* @LastEditTime: 2023-10-28 18:09:40
* @Description: 自用AHK脚本
* Copyright (c) 3022 by wuqunzhi 794817076@qq.com, All Rights Reserved.
*/
#SingleInstance Force
; https://wyagd001.github.io/v2/docs/

init()
#Include "Lib/funcs.ahk"
#Include private.ahk
#Include "zvim.ahk"               ; vim键位操作鼠标 hjkl移动鼠标窗口等
#Include "clipboard.ahk"          ; 记录剪贴板历史
#Include "ime.ahk"                ; 输入法相关
#Include "wheel.ahk"              ; 鼠标滚轮相关
#Include "files\vscode.ahk"
#Include "files\chrome.ahk"
#Include "files\edge.ahk"
#Include "files\explorer.ahk"
#Include "files\desktop.ahk"
#Include "files\taskbar.ahk"
#Include "files\cmd.ahk"
#Include "files\obsidian.ahk"
#Include "files\ideal.ahk"
#Include "files\clash.ahk"
#Include "files\wyy.ahk"
#Include "files\qqmusic.ahk"
#Include "global.ahk" ;放最后
#HotIf


init() {
    global ingame := 0

    global win_chrome := "ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1"                 ; chrome
    global win_edge := "ahk_exe msedge.exe ahk_class Chrome_WidgetWin_1"                   ; edge
    global win_vscode := "ahk_exe Code.exe ahk_class Chrome_WidgetWin_1"                   ; vscode
    global win_obsidian := "ahk_exe Obsidian.exe ahk_class Chrome_WidgetWin_1"             ; obsidian
    global win_cmd := "ahk_exe cmd.exe ahk_class ConsoleWindowClass"                       ; cmd
    global win_wt := "ahk_exe WindowsTerminal.exe ahk_class CASCADIA_HOSTING_WINDOW_CLASS" ; Windows Ternimal
    global win_idea := "ahk_exe idea64.exe"                                                ; idea
    global win_vim := "ahk_exe vim.exe"                                                    ; vim
    global win_desktop := "ahk_exe explorer.exe ahk_class WorkerW"                         ; 桌面
    global win_taskbar := "ahk_exe explorer.exe ahk_class Shell_TrayWnd"                   ; 任务栏
    global win_explorer := "ahk_exe explorer.exe ahk_class CabinetWClass"                  ; 资源管理器
    global win_taskManager := "ahk_exe Taskmgr.exe ahk_class TaskManagerWindow"            ; 任务管理器
    global win_cloudmusic := "ahk_exe cloudmusic.exe ahk_class OrpheusBrowserHost"
    global win_cloudmusicLyric := "ahk_exe cloudmusic.exe ahk_class DesktopLyrics"
    global win_qqmusic := "^(?!桌面歌词).*$ ahk_exe QQMusic.exe ahk_class TXGuiFoundation"
    global win_qqmusicLyric := "桌面歌词 ahk_exe QQMusic.exe ahk_class TXGuiFoundation"
    global win_clash := "Clash for Windows ahk_exe Clash for Windows.exe"                  ; clash for windows
    global win_remote := "ahk_exe mstsc.exe ahk_class TscShellContainerClass"
    global dk2 := A_Desktop . "\桌面2\"
    SetTitleMatchMode("RegEx")    ;! case sensitive
    CoordMode("ToolTip", "Screen") ;v2开始 croodMode 默认全是client
    SetMouseDelay(-1)
    SetCapsLockState "AlwaysOff"
    SetNumLockState "AlwaysOn"
    tipLB(A_ScriptName " running. AHK " A_AhkVersion)
}