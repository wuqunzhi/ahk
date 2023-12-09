#Include fun_tip.ahk
#Include fun_str.ahk
#Include fun_win.ahk
#Include fun_copy.ahk
#Include fun_click.ahk
#Include fun_ime.ahk
#Include fun_class.ahk
#Include steal\JsRT.ahk
#Include steal\ActiveScript.ahk
#Include steal\Monitor.ahk
#Include ../private.ahk

class privatefunc {
    static nas() {
        winT := Format(".*{}.* {}", private.nasIP, win_explorer)
        cmd := Format("explorer \\{}\GPProjectShare", private.nasIP)
        runOrActivate(winT, 'at', 'a', cmd)
    }
}
; 通过注册表启动锁屏
lockComputer() {
    RegWrite(0, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation")
    ; a := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation")
    DllCall("LockWorkStation")
    SetTimer(disableWinL, -1000)
    ; https://wyagd001.github.io/v2/docs/lib/Shutdown.htm
    ; Shutdown()
    ; 0 = 注销
    ; 1 = 关机
    ; 2 = 重启
    ; 4 = 强制
    ; 8 = 关闭电源
}

; 切换是否合并任务栏按钮
toggleTaskbarCombineButtons() {
    ;-----------------------------------------------------------------
    ; https://www.reddit.com/r/sysadmin/comments/16pptty/gporeg_entry_for_combine_taskbar_button_and_hide/
    ; 0=Always
    ; 1=When Taskbar Full
    ; 2=Never
    ;-----------------------------------------------------------------
    num := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarGlomLevel")
    newNum := num == 0 ? 2 : 0
    RegWrite(newNum, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarGlomLevel")
    ; REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V MMTaskbarGlomLevel /T REG_DWORD /D 2 /F
    restartExplorer()
}

; 通过写注册表禁用winl锁屏
disableWinL() {
    RegWrite(1, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation")
}

;restart explorer.exe
restartExplorer() {
    run(A_CWD "\tools\restartexplorer.bat", , 'Hide')
    ; RunWait("taskkill /im explorer.exe /f", , "Hide")
    ; Sleep(2000)
    ; run("C:\Windows\explorer.exe")
}

; 关闭一些无关紧要的窗口,减少任务栏占用
winclear() {
    GroupAdd("winclear", win_cloudmusic)
    GroupAdd("winclear", win_qqmusic)
    GroupAdd("winclear", win_wechat)
    GroupAdd("winclear", win_explorer)
    GroupAdd("winclear", win_taskManager)
    GroupAdd("winclear", win_youdao)
    GroupAdd("winclear", win_clash)
    WinClose("ahk_group winclear")
}

police() {
    return
    if (WinExist("Windows 安全中心警报 ahk_exe rundll32.exe ahk_class #32770")) {
        WinActivate()
        WinWaitActive()
        Send("{blink}{enter}")
    }
}

eval(str) {
    script := ActiveScript("JScript")
    try {
        return script.Eval(str)
    } catch Error as e {
        return ""
    }
}


creatGui() {
    g := Gui()
    g.BackColor := "333333" ; EEAA99可以是任何 RGB 颜色(下面会变成透明的).
    WinSetTransColor(g.BackColor " 255", g)
    g.SetFont("cBlack s20 bold q5")
    g.Opt("+AlwaysOnTop -Caption +ToolWindow") ; +ToolWindow 避免显示任务栏按钮和 alt-tab 菜单项.
    edit1 := g.Add("Edit", "vedit1 WantTab t4 ym") ; ym 选项开始一个新的控件列.
    ; edit1.OnEvent("LoseFocus", hide)
    ; g[edit1]
    ; vedit1这样命名才可以被g.submit().edit1检索
    return g
}

creathookgui(fontsize := 16, fontcolor := "000000", fontname?) {
    g := gui()
    g.opt("+alwaysontop -caption +toolwindow") ; +toolwindow 避免显示任务栏按钮和 alt-tab 菜单项.
    g.backcolor := "123456" ; 可以是任何 rgb 颜色(下面会变成透明的).
    winsettranscolor(g.backcolor, g)
    ; winsettransparent(55, colorgui)
    g.setfont(Format("s{} c{}", fontsize, fontcolor), fontname?) ;"consolas")    ; 设置大字体(32 磅).
    return g
}

ocr() {
    tip.p("unset")
    ; A_Clipboard := ""
    ; ; Run "tools/textshotw.exe eng+chi_sim"

    ; send("^{f3}") ;
    ; KeyWait("LButton", "D T5")
    ; KeyWait("LButton")
    ; tip.p(34)
    ; ClipWait(5)
    ; tip.RB(A_Clipboard)
}


RunWaitOne(command) {
    shell := ComObject("WScript.Shell")
    ; 通过 cmd.exe 执行单条命令
    exec := shell.Exec(A_ComSpec " /C" command)
    ; 读取并返回命令的输出
    return exec.StdOut.ReadAll()
}

translate(text := A_Clipboard) {
    ; 不能hide
    ; msgbox RunWaitOne('D:\VSCodeDeemo\Python3\工具箱\baidu_translate.py "hello stupid"')
    ; Run("cmd /c activate base & python -u D:\VSCodeDeemo\Python3\工具箱\baidu_translate.py hello",,"hide")
    test := '"' A_Clipboard '"'

    Run('"D:\VSCodeDeemo\Python3\tools\baidu_translate.py"' test, , "hide")
    ; Run('"D:\VSCodeDeemo\Python3\工具箱\baidu_translate.py" "hello hello"',,"hide") ;ok

    ; Run A_ComSpec ' /c ""D:\VSCodeDeemo\Python3\工具箱\baidu_translate.py" "nimasile""'
    ; filepath := '"D:\VSCodeDeemo\Python3\工具箱\baidu_translate.py"'
    ; text := '^^^"' A_Clipboard '^^^"'
    ; Run(A_ComSpec '/c D:\VSCodeDeemo\Python3\工具箱\baidu_translate.py' text)
    ; Run(Format('{} /c "{} {}"', A_ComSpec, filepath, text),,"hide")

    ; https://wyagd001.github.io/v2/docs/lib/Run.htm
    ; Run A_ComSpec ' /c ""C:\My Utility.exe" "param 1" "second param" >"C:\My File.txt""'
    text := A_Clipboard
}


; !up to now, only work in explorer, notepad
inputfocus() {
    ; return a_cursor = "ibeam"
    return caretgetpos(&x, &y)
}


; 切换触摸板
toggleTouchpad() {
    static touchpad := 1
    touchpad := !touchpad
    run(a_windir "\system32\systemsettingsadminflows.exe enabletouchpad " touchpad)
    tip.MM("touchpad " touchpad, 1000)
    ; send("#i")
    ; if (winwaitactive("ahk_exe applicationframehost.exe", , 5)) {
    ;     sleep(500)
    ;     click("585, 315"), sleep(200)
    ;     click("117, 464"), sleep(200)
    ;     click("457, 251"), sleep(200)
    ;     ; winclose("a")
    ;     winclose("ahk_exe applicationframehost.exe")
    ; }
}

toggleqqmusic() {
    send("{blink}^!{f10}")
    ; 下面的判断太慢(大概0.5s),还是自己启动吧
    ; global qqmusic:="^(?!桌面歌词).*$ ahk_exe QQMusic.exe ahk_class TXGuiFoundation"
    ; global qqmusicLyric:="桌面歌词 ahk_exe QQMusic.exe ahk_class TXGuiFoundation"
    ; if (!WinExist(qqmusic)) {
    ;     run("C:\Users\79481\Desktop\桌面2\qm")
    ;     return
    ; }
    ; return

}


togglegame() {
    global ingame
    ingame := !ingame
    tip.p("ingame: " . ingame)
}

; toggle key down and up (logical state)
togglekey(key := "LButton") {
    down := GetKeyState(key)
    if (down)
        Send("{" key " up}")
    else
        Send("{" key " down}")
    return down
}


showIntxt(str) {
    path := A_userPath . "\showintxt.txt"
    f := FileOpen(path, 'a')
    f.Write(str)
    f.Close()
    run("code.exe showintxt.txt")
}

nextkey(time := 0.5, opt := "C V") {
    ih := InputHook(Format("{} T{} L1", opt, time))
    ih.Start(), ih.Wait()
    return ih.Input
}

preIs(key, time := 1) {
    return (A_PriorKey == key and A_TimeSincePriorHotkey < time * 1000)
}

press(keys, time := 0.5, opt := "C") {
    ;https://wyagd001.github.io/v2/docs/commands/InputHook.htm
    ; M: 将修饰键击对应于真正的 ASCII 字符, 识别并转录修饰键击(如 Ctrl+A 到 Ctrl+Z). 参考这个例子, 它识别 Ctrl+C:
    if (keys is string) {
        loop parse keys
            if (nextkey(time, opt) !== A_LoopField)
                return false
        return true
    }
    for key in keys
        if (nextkey(time, opt) !== key)
            return false
    return true
}

;keys: "jkl" or ['j'','k','l']
press2(keys, time := 0.5) {
    ; !problem: jkal also return true
    if (keys is string) {
        loop parse keys
            if (!KeyWait(A_LoopField, "D T" time))
                return false
        return true
    }
    for key in keys
        if (!KeyWait(key, "D T" time))
            return false
    return true
}


/**
 * send ^c,判断是否复制到东西
 * 会恢复剪贴板
 */
isTextSelected() {
    tmp := A_Clipboard
    A_Clipboard := ""
    send "^c"
    sleep 50
    ; ClipWait(1)
    res := A_Clipboard
    A_Clipboard := tmp
    tmp := 0 ; 释放内存
    return (res = "" ? 0 : 1)
}

getEnvPath(env) {
    switch env {
        case '%SystemRoot%':
        default:

    }

}

; run or open clipb
autorun(str := A_Clipboard) {
    str := trim(str)
    try {
        ; RegExReplace(str, '^C:\User\.*?\', 'C:\User\79481\')
        if RegExMatch(str, "^(C:|D:|E:|F:)") {
            str := RegExReplace(str, 'C:\\Users\\.*?\\', 'C:\Users\79481\')
            str := RegExReplace(str, 'C:/Users/.*?/', 'C:/Users/79481/')
            run "explorer " str
        }
        else if startwith(str, "localhost:")
            run "chrome.exe http://" str
        else if RegExMatch(str, "^(http:\/\/|https:\/\/)")
            or RegExMatch(str, "(com|net|cn|io|org|htm|html)$")
            ; or RegExMatch(str, "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}")
            or RegExMatch(str, "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}.*")
            run "chrome.exe " str
        ; %AppData%\code
        else if RegExMatch(str, "%(\w+)%(\\[^%]+)*", &matchs) and EnvGet(matchs[1]) {
            str := EnvGet(matchs[1]) . SubStr(str, StrLen(matchs[1]) + 3)
            run "explorer " str
        }
        else
            run "https://www.google.com/search?q=" . str
    }
    catch as e {
        log(e)
    }
}

; 获取dir下所有文件 目前需要加通配符例如
; C:\Users\79481\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\\*
getfiles(dir, mode := "") {
    ; dir := A_Desktop . "\桌面2\*"
    ; https://wyagd001.github.io/v2/docs/lib/LoopFiles.htm
    res := []
    loop files dir, mode {
        res.Push(A_LoopFileName)
    }
    return res
}

focus_wx() {
    win_wechat := "ahk_exe WeChat.exe ahk_class WeChatMainWndForPC"
    if WinWaitActive(win_wechat, , 1) {
        clk.blink("300 360 0")
    }
}

;todo no use
cmdClipReturn(command) {
    cmdInfo := ""
    Clip_Saved := A_Clipboard
    try {
        A_Clipboard := ""
        RunWait(A_ComSpec " /C " command " | CLIP", , "Hide")
        ClipWait 2
        cmdInfo := A_Clipboard
        Sleep 500
    }
    A_Clipboard := Clip_Saved
    return cmdInfo
}

; transform clipb string to markdown table
; use default sep <space><space>
transtable(str) {
    ; tabstr := RegExReplace(str, "m)^|$|  |\t", "|")
    res := RegExReplace(str, " {2,}", "|")
    res := RegExReplace(res, "m)^(?!\|)", "|")
    res := RegExReplace(res, "m)(?<!\|)$", "|")
    res := RegExReplace(res, "m)^\|$", "")
    return "|--|--|`n|:-:|:-:|`n" res
}

transRaw(str := A_Clipboard, mode := 1) {
    str := StrReplace(str, '"', '\"') ; " -> \"
    str := StrReplace(str, '`t', '\t') ; " -> \"
    str := StrReplace(str, '`r`n', '",`r`n"') ; line begin: "
    str := '"' . str . '"'
    ; str := RegExReplace(str, "m)^", "`"") ; line begin: "
    ; str := RegExReplace(str, "m)$", "`",") ; line end: ",
    ; str := RegExReplace(str, "m)^", """")
    ; str := RegExReplace(str, "m)$", """`",")

    A_Clipboard := str
    tip.p("transRaw done")


    ; https://wyagd001.github.io/v2/docs/commands/Hotstring.htm#ExHelper
    ; ClipContent := StrReplace(A_Clipboard, "``", "````")    ; 首先进行此替换以避免和后面的操作冲突.
    ; ClipContent := StrReplace(ClipContent, "`r`n", "``r")    ; 在 MS Word 等软件中中使用 `r 会比 `n 工作的更好.
    ; ClipContent := StrReplace(ClipContent, "`n", "``r")
    ; ClipContent := StrReplace(ClipContent, "`t", "``t")
    ; ClipContent := StrReplace(ClipContent, "`;", "```;")
}


nop() {
}

/**
 * ts:切换网址的(\en <=> \cn)  (\en-us <=> \zh-cn)
 * gb:谷歌必应搜索切换 或 谷歌翻译有道翻译切换
 * @param {string} mode "ts | gb"
 * @returns {number} replace Result String
 */
switchChromeAddress(mode := "ts gb") {
    ;translate|googlebing
    savecb := A_Clipboard
    A_Clipboard := ""
    send "!d"
    Sleep(200) ;等复制完
    send "^c"
    ClipWait
    tmp := A_Clipboard
    tip.p(tmp, 2000)
    counts := 0
    ; i)不区分大小写 (?<!)后向否定预查,(?!)前向否定
    if (InStr(mode, "gb")) {
        if (InStr(tmp, "translate.google.com"))
            tmp := "fanyi.youdao.com"
        else if (InStr(tmp, "fanyi.youdao.com")) {
            tmp := "translate.google.com.hk/?hl=zh-CN"
            ; A_Clipboard := tmp
            ; return
        } else {
            tmp := StrReplace(tmp, "bing.", "google.", , &count)
            if (count = 0)
                tmp := StrReplace(tmp, "google.", "bing.", , &count)
        }
    }
    if (InStr(mode, "ts")) {
        tmp := StrReplace(tmp, "\en-us", "\zh-cn", , &count1)
        tmp := StrReplace(tmp, "\en", "\zh", &count2)
        if (count1 = 0 and count2 = 0) {
            tmp := StrReplace(tmp, "\zh-cn", "\en-us", , &count1)
            tmp := StrReplace(tmp, "\zh", "\en", &count2)
        }
    }
    tip.p(tmp, 2000)
    if (tmp = A_Clipboard) ;没有替换
        return
    A_Clipboard := tmp
    ClipWait()
    ; sleep 200    ;等复制完
    Send "^v"
    Sleep 50 ;必须要,不然^v被enter打断粘贴不完全
    send "{enter}"
    A_Clipboard := savecb
}

/**
 * @param mode
 * support mode := "a,m,c" or "a m c" ...  
 * a: A_***CoordMode  
 * i: ime id,mode  
 * ms: mouse pos relative to screen  
 * mw: mouse pos relative to window  
 * mc: mouse pos relative to client  
 * m: mouse pos  
 * c: color on mousePos  
 * w: wintitle,exe,class,id,pid,path  
 * w1: wintitle,exe,class  
 * wcpos: WinGetClientPos  
 * wpos: WinGetPos  
 * all: == "a i m c w wcpos wpos"  
 * @returns {string}   
 * 显示鼠标位置,窗口位置,输入法消息  
 */
debugInfo(mode, appendsep := '`n') {
    if (InStr(mode, ',') or InStr(mode, ' ')) {
        loop parse mode, ", " {
            if (A_LoopField == " " or A_LoopField == ",")
                continue
            res .= debugInfo(A_LoopField) . appendsep
        }
        return res
    }
    save := A_DetectHiddenWindows
    DetectHiddenWindows(true)
    res := "error"
    try {
        switch mode, 1 { ; 1 casesensetive
            case 'all': res := debugInfo('w wcpos wpos a i m c')

            case 'a': ; A_...
                res := Format("
                (
                    A_coordModeToolTip: {}
                    A_CoordModeMouse: {}
                    A_CoordModePixel: {}
                    A_DetectHiddenWindows: {} 
                )", A_CoordModeToolTip, A_CoordModeMouse, A_CoordModePixel, A_DetectHiddenWindows)

            case 'i':
                imeId := getImeId()
                imeMode := getImeMode()
                res := Format("imeId,mode: {}, {}", imeId, imeMode)

            case 'ms': ; 相对screen的鼠标位置
                CoordMode "mouse", "Screen"
                MouseGetPos(&mxs, &mys)
                CoordMode "mouse", "Client"
                res := Format("
                (
                    ms: {} {}
                )", mxs, mys)

            case 'mc': ; 相对screen的鼠标位置
                CoordMode "mouse", "Client"
                MouseGetPos(&mxc, &myc)
                res := Format("
                (
                    mc: {} {}
                )", mxc, myc)

            case 'mw': ; 相对screen的鼠标位置
                CoordMode "mouse", "Window"
                MouseGetPos(&mxw, &myw)
                CoordMode "mouse", "Client"
                res := Format("
                (
                    mc: {} {}
                )", mxw, myw)

            case 'm': ; 相对screen,client,window的鼠标位置
                CoordMode "mouse", "Screen"
                MouseGetPos(&mxs, &mys)
                ; MouseGetPos(&mxs, &mys, &ahk_id, &ControlClassNN)
                CoordMode "mouse", "Window"
                MouseGetPos(&mxw, &myw)
                CoordMode "mouse", "Client"
                MouseGetPos(&mxc, &myc)
                res := Format("
                (
                    ms: {} {}
                    mw: {} {}
                    mc: {} {}
                )", mxs, mys, mxw, myw, mxc, myc)

            case 'c': ; 鼠标位置颜色
                MouseGetPos(&mxs, &mys)
                color := PixelGetColor(mxs, mys)
                res := Format("co: {}", color)

            case 'w': ; wintitle,ahk_exe,ahk_class,ahk_id,ahk_pid,ahk_processPath
                ahk_id := WinGetID("A")
                title := ahk_id ? WinGetTitle("ahk_id" ahk_id) : ""
                ahk_pid := ahk_id ? WinGetPID("ahk_id" ahk_id) : ""
                ahk_exe := ahk_id ? WinGetProcessName("ahk_id" ahk_id) : ""
                ahk_path := ahk_id ? WinGetProcessPath("ahk_id" ahk_id) : ""
                ahk_class := ahk_id ? WinGetClass("ahk_id" ahk_id) : ""
                res := Format("
                    (
                        {}
                        ahk_exe {}
                        ahk_class {}
                        ahk_id {}
                        ahk_pid {}
                        process_path {}
                    )", title, ahk_exe, ahk_class, ahk_id, ahk_pid, ahk_path)

            case 'w1': ; wintitle,ahk_exe,ahk_class
                ahk_id := WinGetID("A")
                title := ahk_id ? WinGetTitle("ahk_id" ahk_id) : ""
                ahk_exe := ahk_id ? WinGetProcessName("ahk_id" ahk_id) : ""
                ahk_class := ahk_id ? WinGetClass("ahk_id" ahk_id) : ""
                res := Format("{}`nahk_exe {} ahk_class {}", title, ahk_exe, ahk_class)

            case "wcpos":
                WinGetClientPos(&wincx, &wincy, &wincw, &winch, "A")
                res := Format("WinGetClientPos: {} {} {} {}", wincx, wincy, wincw, winch)

            case "wpos":
                WinGetPos(&winx, &winy, &winw, &winh, "A")
                res := Format("WinGetPos: {} {} {} {}", winx, winy, winw, winh)
        }
    }
    DetectHiddenWindows(save)
    return res
}
#HotIf