/*
* @Author: wuqunzhi 794817076@qq.com
* @Date: 2022-10-13 20:16:05
* @LastEditTime: 2023-10-28 18:09:40
* @Description: 自用AHK脚本
* Copyright (c) 3022 by wuqunzhi 794817076@qq.com, All Rights Reserved.
*/
#SingleInstance Force
#Warn Unreachable, off

; https://wyagd001.github.io/v2/docs/

init()
#Include config.ahk ;放前面
#Include private.ahk
#Include "Lib/funcs.ahk"
#Include "zvim.ahk"               ; vim键位操作鼠标 hjkl移动鼠标窗口等
; #Include "zvimm.ahk"               ; vim键位操作鼠标 hjkl移动鼠标窗口等
#Include "clipboard.ahk"          ; 记录剪贴板历史
#Include "ime.ahk"                ; 输入法相关
#Include "wheel.ahk"              ; 鼠标滚轮相关
#Include "files\vscode.ahk"
#Include "files\chrome.ahk"
#Include "files\edge.ahk"
#Include "files\explorer.ahk"
#Include "files\desktop.ahk"
#Include "files\wechat.ahk"
#Include "files\taskbar.ahk"
#Include "files\cmd.ahk"
#Include "files\obsidian.ahk"
#Include "files\ideal.ahk"
#Include "files\clash.ahk"
#Include "files\game.ahk"
#Include "files\wyy.ahk"
#Include "files\qqmusic.ahk"
#Include "global.ahk" ;放最后
#HotIf


init() {
    SetTitleMatchMode("RegEx")    ;! case sensitive
    CoordMode("ToolTip", "Screen") ;v2开始 croodMode 默认全是client
    SetMouseDelay(-1)
    SetCapsLockState "AlwaysOff"
    SetNumLockState "AlwaysOn"
    tipLB(A_ScriptName " running. AHK " A_AhkVersion)
    SetTimer(police, 1000) ;! return
    disableWinL()
}