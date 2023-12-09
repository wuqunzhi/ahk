#Requires AutoHotkey v2.0
#Warn Unreachable, off
#SingleInstance Force
#NoTrayIcon
#Include config.ahk ;放前面
#Include private.ahk
#Include Lib\funcs.ahk
#HotIf

SetTitleMatchMode("RegEx")
CoordMode("ToolTip", "Screen")

woz := WozUI()
<^space:: woz.toggleGui(), KeyWait("space")
~esc:: woz.hideGui(), tip.removeAllTip(5)
>^space:: ahkManager()
win_woz := "woz.ahk ahk_exe AutoHotkey64.exe ahk_class AutoHotkeyGUI"
#HotIf WinActive(win_woz)
enter::tab
NumpadEnter::tab
<^l::tab
#HotIf

class WozUI {
    lastcmd := ""
    timer := this.updateOSD.Bind(this)
    g := this.creatGui()
    showy := 200
    UIHeight := 76
    tipx := 770
    maxTipLines := (A_ScreenHeight - A_TaskbarHeight - this.showy - this.UIHeight) // 20
    cmds := Map()
    __New() {
        this.addcmds()
    }

    addcmds() {
        addcmd(id, func := id, args := "", hint := id, flag := "", pattern := "") {
            this.cmds.Set(id, [func, args, hint, flag, pattern])
        }
        for filename in getfiles(A_desktop2 "\*") {
            if (endwiths(filename, [".jpg", ".png", ".jpeg"]))
                continue
            if (endwith(filename, ".lnk"))
                filename := SubStr(filename, 1, StrLen(filename) - 4)
            addcmd(filename, "run", A_desktop2 "\" filename, "run " filename)
        }

        addcmd("^k (.*)`t$", "kill", "fromid", "kill (.*)", "reg", "^k .*$")
        addcmd("^q (.*)`t$", "ahkq", "fromid", "quit (.*).ahk", "reg", "^q .*$")
        addcmd("^go (.*)`t$", "mousemove", "fromid", "mouse move (.*)", "reg", "^go .*$")

        addcmd("k qm", "kill", "qm", "kill qm", "full")
        addcmd("k wyy", "kill", "wyy", "kill cloudmusic", "full")
        addcmd("k wx", "kill", "wx", "kill WeChat.exe", "full")
        addcmd("k clash", "kill", "clash", "kill clash", "full")
        addcmd("k yd", "kill", "yd", "kill youdao", "full")


        ; ahk
        addcmd("q main", "ahkq", "main", "quit main.ahk", "full")
        addcmd("q test", "ahkq", "test", "quit test.ahk", "full")
        addcmd("q woz", "ahkq", "woz", "quit woz.ahk", "full")
        addcmd("main", "runAs", "main.ahk", "runAs main.ahk")
        addcmd("woz", "runAs", "woz.ahk", "runAs woz.ahk")
        addcmd("test", "runAs", "test.ahk", "runAs test.ahk")

        addcmd("nop")
        addcmd("-v", , , A_AhkVersion)
        addcmd("timer")

        addcmd("showintxt", , , "将剪贴板内容用vscode打开") ;
        addcmd("bluetooth", , , "打开蓝牙设置")
        addcmd("ls", , , "list all ahk")
        addcmd("fclr", "recycleEmpty", , "清空回收站")
        addcmd("wclr", "winclear", , "关闭无关紧要窗口")
        addcmd("restartexplorer", , , "重启资源管理器")
        addcmd("CombineButtons", , , "切换合并任务栏按钮") ;
        addcmd("ps", , , "processManager")
        addcmd("touchpad", , , "切换触摸板")
        addcmd("lock", , , "锁屏")
        addcmd("remote", "run", "mstsc", "远程桌面连接")
        addcmd("mstsc", "run", "mstsc", "远程桌面连接")
        addcmd("colorhook")
        addcmd("record")
        addcmd("taskmgr", "run", "taskmgr", "打开任务管理器")
        addcmd("reload")
        addcmd("quit")
        addcmd("ahkmanager")


        addcmd("cpp", "run", "code D:\vscodeDeemos\cpp", "run vscode cpp")
        addcmd("dy", "run", "code E:\垃圾桶\dy.txt", "code dy.txt")


        ; -------------------- 系统配置
        addcmd("env", "env", "", "环境变量")
        addcmd("regedit", "run", "regedit", "regedit")
        addcmd("gpedit", "run", "gpedit.msc", "gpedit.msc")
        addcmd("msconfig", "run", "msconfig", "msconfig")
        addcmd("services.msc", "run", "services.msc", "services.msc")
        addcmd("dxdiag", "run", "dxdiag", "dxdiag")
        addcmd("cont", "run", "control", "control")

        ; -------------------- 系统文件目录
        addcmd("nas", "nas", "", "nas") ;
        addcmd("~", "run", A_userpath, A_userpath)
        addcmd("program", "run", "C:\Program Files\", "C:\Program Files")
        addcmd("pro86", "run", "C:\Program Files (x86)\", "C:\Program Files (x86)")
        addcmd("document", "run", A_MyDocuments, A_MyDocuments)
        ; addCommand("document", "run", userpath . "\Documents\", "C:\Users\79481\Documents")
        addcmd("system", "run", "C:\Windows\System\", "C:\Windows\System")
        addcmd("sys32", "run", "C:\Windows\System32\", "C:\Windows\System32")
        addcmd("dk2", "run", A_desktop2, "桌面2")
        addcmd("appdata", "run", A_userpath "\AppData\", "~\AppData")
        addcmd("roam", "run", A_AppData, "%AppData%")
        addcmd("host", "run", "C:\Windows\System32\drivers\etc", "host")
        addcmd("startmenu", "run", A_StartMenu, "Start Menu")
        addcmd("startup", "run", A_Startup, "shell:startup")

        ; -------------------- 软件目录
        addcmd("vsdeemo", "run", "D:\VSCodeDeemo\", "D:\VSCodeDeemo\")
        addcmd("vsprojects", "run", "D:\vscodeProjects", "D:\vscodeProjects")
        addcmd("vssetting", "run", A_userpath "\AppData\Roaming\Code\User", "vscode Setting.json 文件夹")

        addcmd("wsl", "run", "\\wsl$\Ubuntu-20.04", "wsl")
        addcmd("scoop", "run", "D:\Scoop", "scoop")

        ; -- vim/nvim目录
        addcmd("vim", "run", "D:\vim\vim90\", "D:\vim\vim90\")
        addcmd("vimrc", "run", A_userpath "\vimfiles\", A_userpath "\vimfiles\")

        ; -------------------- 网站
        addcmd("httpCode", "run", "https://tool.oschina.net/commons?type=5", "http statusCode")
        addcmd("v2", "run", "https://wyagd001.github.io/v2/docs", "ahkv2")
        addcmd("win32api", "run", "https://learn.microsoft.com/zh-cn/windows/win32/api", "win32api")
        addcmd("winkjj", "runs", "https://support.microsoft.com/zh-cn/windows/windows-的键盘快捷方式8F-dcc61a57-8ff0-cffe-9796-cb9706c75eec#WindowsVersion=Windows_10" . "|"
            . "https://support.google.com/chrome/answer/157179#zippy=%2C标签页和窗口快捷键%2Cgoogle-chrome-功能快捷键%2C地址栏快捷键%2C网页快捷键", "win快捷键")
        addcmd("regex", "runs", "https://regex101.com" . "|"
            . "https://tool.oschina.net/uploads/apidocs/jquery/regexp.html", "正则表达式参考网站")
        addcmd("rgb", "run", "https://www.gairuo.com/p/web-color", "rgb")
        addcmd("fdu", "runs", "http://ehall.fudan.edu.cn/ywtb-portal/fudan/index.html#/hall" . "|"
            . "http://yjsxk.fudan.edu.cn/yjsxkapp/sys/xsxkappfudan/xsxkHome/gotoChooseCourse.do" . "|"
            . "https://elearning.fudan.edu.cn/courses", "fdu")

    }

    updateOSD() {
        ; 记录之前的输入与结果
        static text := ""
        static hints := []
        static uniqueMatch := "" ;唯一匹配的cmd
        static matchCommands := Map()

        input := this.g["edit1"].Value
        if (input == "`t")
            input := this.lastcmd
        if (input == "")
            return
        if (input != text) { ;有变化才更新
            linecount := 0
            text := input
            matchCommands.Clear(), hints := [], uniqueMatch := ""
            ; ------ expr
            expr := startwiths(text, ['=', 'm', 'm ']) ? SubStr(text, 2) : text
            expr := (endwiths(expr, ['=', '`t']) && StrLen(expr) > 1) ? SubStr(expr, 1, StrLen(expr) - 1) : expr
            calres := eval(expr)
            if (calres) {
                hints.push(Format("{:-30}`t", calres)), linecount++
                if (endwiths(text, ['`t', '='])) {
                    this.showHints(hints)
                    copyandshow(calres)
                    this.hideGui(), copyandshow(calres)
                    return
                }
                if (startwith(text, "=")) {
                    this.showHints(hints)
                    return
                }
            }
            for k, v in this.cmds {
                if (k == text) { ;全匹配
                    hints := []
                    hints.push(Format("{:-30}`t# {}", k, v[3]))
                    linecount++
                    matchCommands.Clear()
                    matchCommands.Set(k, v), uniqueMatch := k
                    break
                }

                flag := v[4]
                pattern := v[5]
                if (match(k, text, flag)) {
                    matchCommands.Set(k, v), uniqueMatch := k
                    hints.push(Format("{:-30}`t# {}", k, v[3]))
                } else {
                    ; 不匹配也可能需要补充hint
                    if (flag == "reg") {
                        if (RegExMatch(text, pattern))
                            hints.push(Format("{:-30}`t# {}", k, v[3]))
                    }
                    else if (flag == "full" or flag == "^$") {
                        if (startwith(k, text))
                            hints.push(Format("{:-30}`t# {}", "^" k "$", v[3]))
                    }
                    else if (flag == "$") {
                        if (InStr(k, text))
                            hints.push(Format("{:-30}`t# {}", k "$", v[3]))
                    }
                }
                if (hints.Length >= this.maxTipLines - 1) {
                    hints.push('...')
                    break
                }

                match(k, text, flag) {
                    ; k      =   ^q main
                    ; text   =   q m
                    switch flag {
                        case "full":
                            return k == text
                        case "^$":
                            return k == text
                        case "^":
                            return startwith(k, text)
                        case "$":
                            return endwith(k, text)
                        case "reg":
                            return RegExMatch(text, k)
                        default:
                            return InStr(k, text)
                    }
                }
            }

        }

        this.showHints(hints)

        if (matchCommands.Count = 1) { ;唯一匹配
            ; RegExMatch("q  main $", "^q  (.*) $", &arg)
            ; if (RegExMatch(text, k, &arg)) {k
            this.hideGui()
            ih := InputHook("T1")
            ih.Start()    ;唯一匹配即执行 所以拦截用户溢出的多余输入1秒
            ; ih.Wait() ;会阻塞

            k := uniqueMatch
            v := matchCommands[uniqueMatch]
            func := v[1]
            args := v[2]
            hint := v[3]
            flag := v[4]
            this.lastcmd := k
            if (flag == "reg") { ; 解析正则真正命令参数
                RegExMatch(text, k, &matchs)
                args := matchs[1]
                this.lastcmd := input
            }
            if (this.deal(func, args))
                this.showGui()
        }

    }

    showHints(hints) {
        res := strJoin(hints, '`n')
        static num := 1
        num := nextn(num, 3)
        tip.ultimate(res, 500, this.tipx, this.showy + this.UIHeight, num)
    }

    deal(func, args) {
        try {
            keep := 0
            switch func {
                case "run": run(args), tip.LB("run " args)
                case "runAs": run("*runAs " args), tip.LB("*runAs " args)
                case "Hrun": run(args, , "Hide"), tip.LB("Hrun " args)
                case "HrunAs": run("*runAs " args, , "Hide"), tip.LB("*HrunAs " args)
                case "runs":
                    for s in StrSplit(args, "|", ' ')
                        run(s)
                    tip.LB("runs: `n" StrReplace(args, "|", "`n"))

                case "mousemove": click(args . " 0")
                case "-v": tip.RB(A_ScriptName " version AHK " A_AhkVersion)
                case "restartexplorer": restartExplorer()
                case "CombineButtons": toggleTaskbarCombineButtons()
                case "ps": processManager()
                case "showintxt": showIntxt(A_Clipboard)
                case "recycleEmpty":
                    if (MsgBox("是否清空回收站?", "", 1) = "ok")
                        FileRecycleEmpty(), tip.LB("FileRecycleEmpty")
                case "winclear": winclear()
                case "record": ahk("t", "record.ahk", ".\utils\record.ahk")
                case "colorhook": colorg.toggleshow() ;!!!!!
                case "touchpad": toggleTouchpad()
                case "bluetooth": Run("control.exe bthprops.cpl")
                    ; case "timer": timeh.toggleshow()
                case "env":
                    run("sysdm.cpl"), WinWaitActive("系统属性")
                    send("{ctrl Down}{Tab 2}{ctrl Up}!n")
                case "ahkmanager": ahkManager()
                case "ls": tip.RB(ahk("ls"), 5000)
                case "reload": run("*runAs woz.ahk") ;管理员
                case "quit": (MsgBox("quit?", , 1) == "OK") ? ahk("q", "woz.ahk") : 0
                case "nas": privatefunc.nas()
                case "ahkq": ahk("q", args)
                case "kill": taskkill(args)
                case "lock": lockComputer()

                default: return 0
            }
            return keep ;if keep == 1 ,dont exit
        }
        catch as e {
            log(e)
        }
    }

    creatGui() {
        g := Gui()
        g.BackColor := "333333" ; EEAA99可以是任何 RGB 颜色(下面会变成透明的).
        ; WinSetTransColor(MyGui.BackColor " 225", MyGui)
        g.SetFont("cBlack s20 bold q5")
        g.Opt("+AlwaysOnTop -Caption +ToolWindow") ; +ToolWindow 避免显示任务栏按钮和 alt-tab 菜单项.
        edit1 := g.Add("Edit", "WantTab t4 ym") ; ym 选项开始一个新的控件列.
        ; edit1.OnEvent("Change", this.timer)
        return g
    }

    toggleGui() {
        ; ahk_class AutoHotkeyGUI
        if (WinExist("ahk_exe AutoHotkey64.exe ahk_id " this.g.Hwnd))
            this.hideGui()
        else
            this.showGui()
    }

    hideGui() {
        SetTimer(this.timer, 0)
        this.g.hide()
    }

    showGui() {
        this.g.Show("y" . this.showy)
        this.g["edit1"].Value := "tab: " . this.lastcmd
        send("^a")
        SetTimer(this.timer, 200)
        this.updateOSD()
    }
}


; ==========o==========o==========o==========o==========o hooks
colorg := colorGUI()
#HotIf WinExist("ahk_exe AutoHotkey64.exe ahk_id " colorg.g.Hwnd)
Insert:: copyandshow(colorg.info.Value)
pgup:: colorg.nextColor()
pgdn:: colorg.nextPage()
#HotIf

/*
timeh := timerhook()
#HotIf WinExist("ahk_exe AutoHotkey64.exe ahk_id " timeh.g.Hwnd)
; :*x?b0z:`:`::: timeh.setdeadline()
:*x?b0z:`::: keywait(":"), KeyWait(":", 'DT1') and timeh.setdeadline()
#HotIf
*/
