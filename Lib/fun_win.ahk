AltTab() {
    idList := WinGetList()
    for id in idList {
        if (WinActive("ahk_id " id))
            continue
        If (WinGetTitle("ahk_id " id) == "")
            continue
        If (!IsWindow(id))
            continue
        WinActivate("ahk_id " id)
        break
    }
}

;-----------------------------------------------------------------
; Check whether the target window is activation target
; https://www.autohotkey.com/boards/viewtopic.php?style=17&t=101808
;-----------------------------------------------------------------
IsWindow(hWnd) {
    Stype := WinGetStyle("ahk_id " hwnd)
    if ((Stype & 0x08000000) || !(Stype & 0x10000000)) {
        return false
    }
    EXStype := WinGetExStyle("ahk_id " hwnd)
    if (EXStype & 0x00000080) {
        return false
    }
    return true
}

; auto switch
runOrActivate(winTE := "A", ifactive := "r", ifexist := "a", ifnoexist := "") {
    winTitle := unset
    excludeTitle := unset
    Type(winTE) == "String" ? winTitle := winTE : (winTitle := winTE[1], excludeTitle := winTE[2])

    save := A_DetectHiddenWindows
    DetectHiddenWindows true
    try {
        if (WinActive(winTitle, , excludeTitle?)) {
            ; tip("a")
            switch ifactive {
                case "m": WinMinimize()
                case "c": WinClose()
                case "h": WinHide()
                case "b": WinActivateBottom(winTitle, , excludeTitle?)
                case "at": AltTab()
                default: ; r: do nothing (remain)
            }
            return
        }
        if (WinExist(winTitle, , excludeTitle?)) {
            ; tip("e")
            switch ifexist {
                case "a": WinActivate()
                case "sa": WinShow(), WinActivate()
            }
            return
        }
        if (!WinExist(winTitle, , excludeTitle?)) {
            ; tip("!e")
            if (!ifnoexist)
                return
            func := type(ifnoexist) == "String" ? "run" : ifnoexist[1]
            args := type(ifnoexist) == "String" ? ifnoexist : ifnoexist[2]
            switch func {
                case "run":
                    ; RunWait(args) 阻塞
                    run(args)
                    tipLB("run " args)
                    if (WinWait(winTitle, , 5, excludeTitle?))
                        WinActivate()
                default:
            }
            return
        }
    } catch error as e {
        Log(e)
        DetectHiddenWindows save
    }
    DetectHiddenWindows save
}

class markWindow {
    static winid := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    static winTitle := ["", "", "", "", "", "", "", "", "", ""]
    static mark(idx) {
        try {
            this.winid[idx] := WinGetID("A")
            title := WinGetTitle("A")
            ahkclass := WinGetClass("A")
            ahkexe := WinGetProcessName("A")
            this.winTitle[idx] := Format("{} ahk_class {} ahk_exe {}", title, ahkclass, ahkexe)
            tipRB(Format("mark {}: {}", idx, this.winTitle[idx]))

        } catch Error as e {
            logM(e)
        }
    }
    static go(idx) {
        try {
            WinActivate("ahk_id " this.winid[idx])
        } catch Error as e {
            logM(e)
        }
    }

}


countdown(seconds) {
    loop seconds {
        tipMM(seconds + 1 - A_Index, 950)
        Sleep(1000)
    }
}

maymark() {
    ih := InputHook("T3 L1")
    ; SetTimer countdown.Bind(3), -20
    ih.Start()
    ih.Wait()
    res := ih.Input
    if (IsInteger(res) && Integer(res) <= 10 && Integer(res) > 0) {
        markWindow.mark(Integer(res))
    }
}

; 添加/移除标题栏
winSetCaption(n) {
    switch n {
        case 1: WinSetStyle("+0xC00000", "A")
        case 0: WinSetStyle("-0xC00000", "A")
        case -1: WinSetStyle("^0xC00000", "A")
    }
    ; 7:: WinSetStyle("^0x800000", "A")
    ; 0x40000
}

; 判断是否在托盘中(最小化到任务栏)
winInTray(processName) {
    ; todo
    return ProcessExist(processName)
}

; 在同程序的各窗口切换
LoopRelatedWindows() {
    ahk_exe := WinGetProcessName("A")
    ahk_class := WinGetClass("A")
    WinActivateBottom("ahk_exe " ahk_exe " ahk_class " ahk_class)
}

; 返回窗口是否置顶
winGetAlwaysOnTop(wintitle) {
    ; https://www.autohotkey.com/board/topic/31878-get-alwaysontop-state/
    return WinGetExStyle(wintitle) & 0x8 ;264
}

;return WinExist and !WinActive
WinExistAndNotActive(WinTitle?, WinText?, ExcludeTitle?, ExclideText?) {
    return WinExist(WinTitle?, WinText?, ExcludeTitle?, ExclideText?)
        and !WinActive()
    ; and !WinActive(WinTitle?, WinText?, ExcludeTitle?, ExclideText?)
}


; restore and move center
; winReset(0,0) 窗口还原最小尺寸并移动到中间
winReset(w := unset, h := unset) {
    WinRestore("A")
    ; w := IsSet(w) ? w : winw()
    ; h := IsSet(h) ? h : winh()
    WinMove(, , w?, h?, "A")
    winCenter()
    ; WinMove((A_ScreenWidth - w) / 2, (A_ScreenHeight - h) / 2, , , "A"); wincenter
}

; 切换最大化
WinToggleMaximize() {
    WinGetMinMax("A") = 1 ? WinRestore("A") : WinMaximize("A")
}

; move center
winCenter() {
    try {
        WinMove((A_ScreenWidth - winw()) / 2, (A_ScreenHeight - winh()) / 2, , , "A")
    } catch Error as e {
        tip(e)
    }
}

/**
 * @param {number} dx x位置改变量  
 * @param {number} dy y位置改变量  
 * @param {number} dw 宽改变量  
 * @param {number} dh 高改变量  
 */
winMovedif(dx := 0, dy := 0, dw := 0, dh := 0) {
    WinGetPos(&x, &y, &w, &h, "A")
    WinMove(x + dx, y + dy, w + dw, h + dh, "A")
}

; -------------------- 窗口移动
; 当前窗口往下移动
winMoveD(d) {
    winMovedif(, d)
}
; 当前窗口往上移动
winMoveU(d) {
    winMovedif(, -d)
}
; 当前窗口往左移动
winMoveL(d) {
    winMovedif(-d)
}
; 当前窗口往右移动
winMoveR(d) {
    winMovedif(d)
}
; 当前窗口移动最下方
winMoveDMost() {
    WinMove(, A_ScreenHeight - winh(), , , "A")
}
; 当前窗口移动最上方
winMoveUMost() {
    WinMove(, 0, , , "A")
}
; 当前窗口移动最左方
winMoveLMost() {
    WinMove(0, , , , "A")
}
; 当前窗口移动最右方
winMoveRMost() {
    WinMove(A_ScreenWidth - winw(), , , , "A")
}

; -------------------- 窗口resize
; 窗口下方调整大小
winResizeD(d) {
    winMovedif(, , , d)
}
; 窗口上方调整大小
winResizeU(d) {
    winMovedif(, -d, , d)
}
; 窗口左方调整大小
winResizeH(d) {
    winMovedif(-d, , d)
}
; 窗口右方调整大小
winResizeL(d) {
    winMovedif(, , d)
}
; 窗口上方调整最大
winResizeUMost() {
    WinGetPos(&x, &y, &w, &h, "A")
    WinMove(, 0, , y + h, "A")

}
; 窗口下方调整最大
winResizeDMost() {
    WinGetPos(&x, &y, &w, &h, "A")
    WinMove(, , , A_ScreenHeight - y, "A")

}
; 窗口左方调整最大
winResizeHMost() {
    WinGetPos(&x, &y, &w, &h, "A")
    WinMove(0, , x + w, , "A")

}
; 窗口右方调整最大
winResizeLMost() {
    WinGetPos(&x, &y, &w, &h, "A")
    WinMove(, , A_ScreenWidth - x, , "A")

}


ahkManager() {
    static historycmd := ""
    winlst := listWins(".ahk - AutoHotkey")
    str1 := "空运行 r重启 e编辑 s挂起 p暂停 q退出 k显示(KeyHistory)`n"
    str2 := ahk("ls")
    str3 := "
    (
        例如:        (下拉显示更多)
            ls      列出所有运行中的ahk脚本
            ls*     列出所有窗口(拒绝访问请点击继续)
                    重启本脚本(见标题)
            foo     foo.ahk (管理员运行)
            r foo   重启foo.ahk
    )"
    IB := InputBox(str1 str2 str3, , "w600 h240", historycmd) ;"w640 h480"
    if (IB.result = "Cancel")
        return
    res := Trim(IB.Value)
    historycmd := res
    if (res = "") {
        Reload
        return
    }
    if (res = "ls") {
        ahk("ls")
    }
    if (res = "ls*") {
        ahk("ls*")
    } else {
        res := StrSplit(res, " ", " ")
        act := res.Length >= 2 ? res[1] : "run"
        name := res.Length >= 2 ? res[2] : res[1]
        ahk(act, name ".ahk")
    }
}

processManager() {
    namemap := Map("qm", "QQMusic.exe",
        "wyy", "cloudmusic.exe",
        "clash", "clash.exe"
    )
    str := "杀死进程"
    for k, v in namemap {
        str .= k . "`t`t" . v . "`n"
    }
    IB := InputBox(str, , "w600 h240") ;"w640 h480"
    res := Trim(IB.Value)
    taskkill(namemap.get(res, "NameNoExist"))
}

; 杀死进程
taskkill(PIDOrName) {
    static fullname := Map(
        "qm", "QQMusic.exe",
        "wyy", "cloudmusic.exe",
        "wx", "WeChat.exe",
        "clash", "Clash for Windows.exe",
        "yd", "YoudaoDict.exe",
    )
    PIDOrName := fullname.Get(PIDOrName, PIDOrName)
    str := ProcessClose(PIDOrName) ? "" : "failed"
    tipLB(Format("taskkill {} {}", PIDOrName, str))
}


/**
 * @param {string} act
 * t toggle run and quit
 * run run
 * r reload
 * e edit
 * s suspend
 * p pause
 * q quit
 * k KeyHistory
 * v ListVars
 * l Listines
 * ls return ahk str
 * ls* return all wins str
 * @param {string} name foo.ahk / foo
 * @param {string} path   ..\bar\foo.ahk
 */
ahk(act, name := "", path := name) {
    showtip(str) {
        tipLB(str)
    }
    if ( not endwith(name, ".ahk"))
        name .= ".ahk"
    ; PostMessage, 0x111, 65303,,, MyScript.ahk - AutoHotkey ; 重启 Reload
    ; PostMessage, 0x111, 65304,,, MyScript.ahk - AutoHotkey ; 编辑 Edit
    ; PostMessage, 0x111, 65305,,, MyScript.ahk - AutoHotkey ; 挂起 Suspend
    ; PostMessage, 0x111, 65306,,, MyScript.ahk - AutoHotkey ; 暂停 Pause
    ; PostMessage, 0x111, 65307,,, MyScript.ahk - AutoHotkey ; 退出 ExitApp
    ; PostMessage, 0x111, 65406,,, MyScript.ahk - AutoHotkey ; KeyHistory
    ; PostMessage, 0x111, 65407,,, MyScript.ahk - AutoHotkey ; ListVars
    ; PostMessage, 0x111, 65408,,, MyScript.ahk - AutoHotkey ; ListLines
    save := A_DetectHiddenWindows
    DetectHiddenWindows True
    title := name " - AutoHotkey"
    res := ""

    switch act {
        ; PostMessage, 0x111, 65303,,, MyScript.ahk - AutoHotkey ; 重启 Reload
        case "ls": ;list all ahk
            winlst := listWins(".ahk - AutoHotkey")
            res := "All running ahks: `n"
            res .= Format("{:-10}`t{:-10}`t{}`n", "hwnd", "pid", "wintitle")
            for win in winlst
                res .= Format("{:-10}`t{:-10}`t{}`n", win["hwnd"], win["pid"], win["wintitle"])

        case "ls*": ;list all wins
            winlst := listWins()
            res := "All Wins: `n"
            res .= Format("{:-10}`t{:-10}`t{:-30}`t{:-30}`t{}`n", "hwnd", "pid", "exe", "class", "wintitle")
            for win in winlst
                res .= Format("{:-10}`t{:-10}`t{:-30}`t{:-30}`t{}`n", win["hwnd"], win["pid"], win["exe"], win["class"], win["wintitle"])
            showIntxt(res) ;?sync

        case "t": ;toggle
            if (!WinExist(title))
                ahk("run", name, path)
            else
                ahk("q", name, path)
        case "run": ;Run
            Run("*runAs " path)
            showtip("runAs " name)
        case "r": ;Reload
            PostMessage(0x111, 65303, , , title)
            showtip("Reload " name)
        case "e": ;Edit
            PostMessage(0x111, 65304, , , title)
            showtip("Edit " name)
        case "s": ;Suspend
            PostMessage(0x111, 65305, , , title)
            showtip("Suspend " name)
        case "p": ;Pause
            PostMessage(0x111, 65306, , , title)
            showtip("Pause " name)
        case "q": ;Quit
            while WinExist(title) {
                PostMessage(0x111, 65307, , , title)
                showtip("Quit " name)
            }
        case "k": ;KeyHistory
            PostMessage(0x111, 65406, , , title)
            showtip("KeyHistory " name)
        case "v": ;ListVars
            PostMessage(0x111, 65407, , , title)
            showtip("ListVars " name)
        case "l": ;ListLines
            PostMessage(0x111, 65408, , , title)
            showtip("ListLines " name)
        default:

    }
    DetectHiddenWindows save
    return res

}

/**
 * 列出满足条件的所有窗口,返回一个map list
 * @param {string} wintitle 包含的,默认unset 即*
 * @param {boolean} showEach show and activitate each window if true
 * @param {string} exclude 排除的,默认Program Manager(系统相关,否则出来两百多个),也排除了空标题
 * @returns {array} winlist ;map list { "id" : ,"title:" , "class" : , "pid" : , "exe":,}
 */

listWins(wintitle := unset, exclude := "Program Manager", showEach := 0) {
    try {
        winlist := [] ;{ "id" : ,"title:" , "ahkclass" : , "pid" : , "exe":,}
        save := A_DetectHiddenWindows
        DetectHiddenWindows true
        idList := WinGetList(wintitle?, , exclude)
        saveId := WinGetID("A")
        Loop idList.Length {
            id := idList[A_Index]
            title := WinGetTitle("ahk_id" id)
            ; if (title = "")
            ;     continue
            ahkclass := WinGetClass("ahk_id" id)
            pid := WinGetPID("ahk_id" id)
            exe := WinGetProcessName("ahk_id" id)
            winlist.push(Map("hwnd", id, "wintitle", title, "class", ahkclass, "pid", pid, "exe", exe))
            if (showEach) {
                msg := Format(
                    "
        (
            list all windows:
            {} of {}:
            ahk_id：{}
            WinTitle：{}
            ahk_class：{}
            pid：{}
            exe: {}
            continue?
        )", A_Index, idList.Length, id, title, ahkclass, pid, exe)
                WinActivate("ahk_id" id)
                if MsgBox(msg, , 4) = "No"
                    break
            }
        }
        WinActivate("ahk_id" . saveId)
        DetectHiddenWindows save
        Return winlist
    } catch Error as e {
        log(e)
    }
}

; 对所有idlist执行act
winsAct(idlist, act) {
    switch act {
        case 'offtop':
            for id in idlist {
                WinSetAlwaysOnTop(0, "ahk_id " id)
                WinActivate(("ahk_id " id))
                MsgBox(WinGetTitle("ahk_id " id))
            }
        default:

    }
}

; ============================================================
winy() {
    WinGetPos(&x, &y, &w, &h, "A")
    return y
}
winx() {
    WinGetPos(&x, &y, &w, &h, "A")
    return x
}
winw() {
    WinGetPos(&x, &y, &w, &h, "A")
    return w
}
winh() {
    WinGetPos(&x, &y, &w, &h, "A")
    return h
}
winch() {
    WinGetClientPos(&x, &y, &w, &h, "A")
    return h
}
wincw() {
    WinGetClientPos(&x, &y, &w, &h, "A")
    return w
}