/**
 * 存在则激活,否则运行
 * @param {string} WinTitle
 * @param {string} ifActive what to do if WinActive(WinTitle)
 *   m: WinMinimize
 *   c: WinClose
 *   h: WinHide
 *   b: WinActivateBottom
 * @param {string} cmd if no exit, run cmd
 * @param {bool} useCmdToActicate 
 */
runOrActivate(WinTitle := "A", ifActive := "r", cmd := "", useCmdToActicate := 0) {
    ; 1) WinActive
    if (WinActive(WinTitle)) {
        if (ifActive = "m")
            WinMinimize()
        else if (ifActive = "c")
            WinClose()
        else if (ifActive = "h")
            WinHide()
        else if (ifActive = "b")
            WinActivateBottom(WinTitle) ;cant omit WinTitle
        ;r do nothing (retain)
        return
    }

    if (useCmdToActicate) {
        ; for some in traybar
        RunWait cmd
        tipLB("run " cmd)
        WinActivate(WinTitle) ;!!!
        ; RunWait cmd
        return
    }

    ; 2) WinExist
    save := A_DetectHiddenWindows
    DetectHiddenWindows true
    if (WinExist(WinTitle)) {
        ; WinShow()    ;最小化的好像activate不了
        WinActivate()
        DetectHiddenWindows save
        return
    }

    ;3) no exit (may in tray)
    DetectHiddenWindows save
    run(cmd)
}


LoopRelatedWindows() {
    ahk_exe := WinGetProcessName("A")
    ahk_class := WinGetClass("A")
    WinActivateBottom("ahk_exe " ahk_exe " ahk_class " ahk_class)
}

winGetAlwaysOnTop(wintitle) {
    ; https://www.autohotkey.com/board/topic/31878-get-alwaysontop-state/
    return WinGetExStyle(wintitle) & 0x8 ? 1 : 0
    ;264
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

winMoved(dx := 0, dy := 0, dw := 0, dh := 0) {
    WinGetPos(&x, &y, &w, &h, "A")
    WinMove(x + dx, y + dy, w + dw, h + dh, "A")
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
    if (fullname.Has(PIDOrName))
        PIDOrName := fullname[PIDOrName]
    str := ProcessClose(PIDOrName) ? "" : " failed"
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
}

; 返回所有窗口idlist
allwin(showhide := 0, excludeEmptyTitle := 0, excludeProgramManager := 1) {
    res := []
    save := A_DetectHiddenWindows
    if showhide
        DetectHiddenWindows(true)
    if (excludeProgramManager)
        idlist := WinGetList(, , "Program Manager")
    else
        idlist := WinGetList()
    for id in idlist {
        if (!excludeEmptyTitle or WinGetTitle("ahk_id " id))
            res.Push(id)
    }
    if showhide
        DetectHiddenWindows(save)
    return res
}

; 对所有idlist执行act
allwinAct(idlist, act) {
    switch act {
        case 'offtop':
            for id in idlist {
                WinSetAlwaysOnTop(0, "ahk_id " id)
            }
        default:

    }
}

; ============================================================
ypos() {
    MouseGetPos(&x, &y)
    return y
}
xpos() {
    MouseGetPos(&x, &y)
    return x
}
winy() {
    WinGetPos(&x, &y, &w, &h, "A")
    return y
}
winx() {
    WinGetPos(&x, &y, &w, &h, "A")
    return x
}
winch() {
    WinGetClientPos(&x, &y, &w, &h, "A")
    return h
}
wincw() {
    WinGetClientPos(&x, &y, &w, &h, "A")
    return w
}
winw() {
    WinGetPos(&x, &y, &w, &h, "A")
    return w
}
winh() {
    WinGetPos(&x, &y, &w, &h, "A")
    return h
}
mx() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x)
    CoordMode("Mouse", "Client")
    return x
}
my() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(, &y)
    CoordMode("Mouse", "Client")
    return y
}
mwx() {
    CoordMode("Mouse", "Window")
    MouseGetPos(&x)
    CoordMode("Mouse", "Client")
    return x
}
mwy() {
    CoordMode("Mouse", "Window")
    MouseGetPos(, &y)
    CoordMode("Mouse", "Client")
    return y
}
mcx() {
    MouseGetPos(&x)
    return x
}
mcy() {
    MouseGetPos(, &y)
    return y
}
mouses() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)
    CoordMode("Mouse", "Client")
    return [x, y]
}
mousew() {
    CoordMode("Mouse", "Window")
    MouseGetPos(&x, &y)
    CoordMode("Mouse", "Client")
    return [x, y]
}
mousec() {
    CoordMode("Mouse", "Client")
    MouseGetPos(&x, &y)
    CoordMode("Mouse", "Client")
    return [x, y]
}