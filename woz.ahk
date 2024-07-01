; 用bootstrap
; 弹幕hook 礼物hook up逮捕
; clipboard
#Requires AutoHotkey v2.0
#Warn Unreachable, off
#SingleInstance Force
#NoTrayIcon
#Include config.ahk ;放前面
#Include private.ahk
#Include Lib/entry.ahk
#HotIf

SetTitleMatchMode("RegEx")
CoordMode("ToolTip", "Screen")
tip.LB(A_ScriptName " running. AHK " A_AhkVersion, 2000)

woz := WozUI()

<^space:: woz.toggleGui(), KeyWait("space")
~esc:: woz.hideGui(), tip.removeAllTip(5)
>^space:: ahkManager()

/* tab自动执行上一条 */
#HotIf WinActive(win_woz)
enter::tab
<^l::tab
/* 复制计算结果 */
#HotIf WinActive(win_woz) and woz.inMath
^c:: copyandshow(woz.calResult, 3000, 1190, 223)
<^l::
enter::
tab:: copyandshow(woz.calResult, 5000, 1190, 223), woz.hideGui()
#HotIf


class WozUI {
    inMath := false
    calResult := ''
    lastcmd := ''
    g := Gui()
    showy := 200         ; 显示位置高度
    UIHeight := 76
    UIWidth := 76
    tipx := 735
    fontsize := 24
    maxTipLines := (A_ScreenHeight - A_TaskbarHeight - this.showy - this.UIHeight) // 20
    cmds := Map()
    __New() {
        this.initGui()
        this.initCMDs()
    }
    initGui() {
        this.g.BackColor := "333333" ; EEAA99可以是任何 RGB 颜色(下面会变成透明的).
        WinSetTransColor(this.g.BackColor " 225", this.g)
        this.g.SetFont("cBlack s" this.fontsize " bold q5")
        this.g.Opt("+AlwaysOnTop -Caption +ToolWindow") ; +ToolWindow 避免显示任务栏按钮和 alt-tab 菜单项.
        this.g.edit1 := this.g.Add("Edit", "WantTab t4 ym") ; ym 选项开始一个新的控件列.
        this.g.edit1.OnEvent("Change", this.updateOSD.Bind(this))
        this.g.OnEvent("Escape", (*) => this.hideGui())
    }
    initCMDs() {
        /**
         * @param id 命令id
         * @param func 函数名 或 函数对象
         * @param args 函数参数 或 以input为参数的函数
         * @param hint 显示描述
         * @param flag 匹配规则 ^ * full reg
         * @param pattern 什么情况显示
         */
        addcmd(id, func := 'run', args := [], hint := id, flag := "", pattern := "") {
            ; this.cmds.Set(id, [func, args, hint, flag, pattern])
            cmd := {
                id: id,
                func: func,
                args: args,
                hint: hint,
                flag: flag,
                pattern: pattern
            }
            this.cmds.Set(id, cmd)
        }
        for filename in getfiles(A_desktop2 "\*") {
            if (endwiths(filename, [".jpg", ".png", ".jpeg"]))
                continue
            filename := rtrims(filename, ['.lnk', '.exe'])
            addcmd(filename, "run", A_desktop2 "\" filename, "run " filename)
        }

        extractArgs(pattern, input) => RegExMatch(input, pattern, &matchs) ? matchs[1] : ''
        addcmd("^k (.*)`t$", kill, "fromid", "kill (.*)", "reg", "^k .*$")
        addcmd("^q (.*)`t$", ahk.Bind('q'), extractArgs.Bind("^q (.*)`t$"), "quit (.*).ahk", "reg", "^q .*$")
        addcmd("^go (.*)`t$", "mousemove", extractArgs.Bind("^go (.*)`t$"), "mouse move (.*)", "reg", "^go .*$")

        addcmd("k qm", kill, "qm", "kill qm", "full")
        addcmd("k wyy", kill, "wyy", "kill cloudmusic", "full")
        addcmd("k wx", kill, "wx", "kill WeChat.exe", "full")
        addcmd("k clash", kill, "clash", "kill clash", "full")
        addcmd("k yd", kill, "yd", "kill youdao", "full")


        addcmd("key", code, vspDir "\ahk\keyMap.ahk", "code keyMap")
        addcmd("c ahk", code, vspDir "\ahk", "code ahk")
        addcmd("ssh", code, A_userpath '.ssh\config', "ssh")
        addcmd("dy", code, "E:\垃圾桶\dy.txt", "code dy.txt")

        ; ahk
        addcmd("q main", ahk.Bind('q'), "main", "quit main.ahk", "full")
        addcmd("q test", ahk.Bind('q'), "test", "quit test.ahk", "full")
        addcmd("q woz", ahk.Bind('q'), "woz", "quit woz.ahk", "full")
        addcmd("main", "runAs", "main.ahk", "runAs main.ahk")
        addcmd("woz", "runAs", "woz.ahk", "runAs woz.ahk")
        addcmd("test", "runAs", "test.ahk", "runAs test.ahk")

        ; addcmd("nop")
        addcmd("notepad", createNotepad, , "notepad")
        addcmd("word", createWord, , "word")
        addcmd("bluetooth", Run.Bind("explorer ms-settings:bluetooth"), , "打开蓝牙设置")
        addcmd("ls", () => tip.RB(ahk("ls"), 5000), , "list all ahk")
        addcmd("-v", () => tip.MM(A_ScriptName " version AHK " A_AhkVersion), , A_AhkVersion)
        addcmd("fclr", fclear, , "整理桌面")
        addcmd("wclr", winclear, , "关闭无关紧要窗口")
        addcmd("restartexplorer", restartExplorer, , "重启资源管理器")
        addcmd("CombineButtons", toggleTaskbarCombineButtons, , "切换合并任务栏按钮") ;
        addcmd("ps", processManager, , "processManager")
        addcmd("touchpad", toggleTouchpad, , "切换触摸板")
        addcmd("doublepin", toggleDoublePin, , "切换双拼全拼")
        addcmd("lock", lockComputer, , "锁屏")
        addcmd("remote", , "mstsc", "远程桌面连接")
        addcmd("mstsc", , "mstsc", "远程桌面连接")
        addcmd("calculator", , "calc", "计算器")
        addcmd("taskmgr", , "taskmgr", "打开任务管理器")
        addcmd("colorhook", () => colorg.toggleshow())
        addcmd("record", () => ahk("t", "record.ahk", ".\utils\record.ahk"))
        addcmd("reload", () => run("*runAs " A_ScriptName))
        addcmd("quit", () => MsgBox("quit?", , 1) == "OK" ? ahk("q", "woz.ahk") : 0)
        addcmd("ahkmanager", ahkManager)


        ; -------------------- 系统配置
        addcmd("env", editEnv, , "环境变量")
        addcmd("regedit", , "regedit", "regedit")
        addcmd("gpedit", , "gpedit.msc", "gpedit.msc")
        addcmd("msconfig", , "msconfig", "msconfig")
        addcmd("services.msc", , "services.msc", "services.msc")
        addcmd("dxdiag", , "dxdiag", "dxdiag")
        addcmd("cont", , "control", "control")

        ; -------------------- 系统文件目录
        addcmd("nas", () => private.nas, , "nas") ;
        addcmd("~", , A_userpath, A_userpath)
        addcmd("program", , "C:\Program Files\", "C:\Program Files")
        addcmd("pro86", , "C:\Program Files (x86)\", "C:\Program Files (x86)")
        addcmd("document", , A_MyDocuments, A_MyDocuments)
        addcmd("system", , "C:\Windows\System\", "C:\Windows\System")
        addcmd("sys32", , "C:\Windows\System32\", "C:\Windows\System32")
        addcmd("dk2", , A_desktop2, "桌面2")
        addcmd("appdata", , A_userpath "\AppData\", "~\AppData")
        addcmd("roam", , A_AppData, "%AppData%")
        addcmd("host", , "C:\Windows\System32\drivers\etc", "host")
        addcmd("startmenu", , A_StartMenu, "Start Menu")
        addcmd("startup", , A_Startup, "shell:startup")

        ; -------------------- 软件目录
        addcmd("vsprojects", , "D:\vscodeProjects", "D:\vscodeProjects")
        addcmd("vssetting", , A_userpath "\AppData\Roaming\Code\User", "vscode Setting.json 文件夹")
        addcmd("wsl", , "\\wsl.localhost\Ubuntu", "wsl目录")
        addcmd("vim", , "D:\vim\vim90\", "D:\vim\vim90\")
        addcmd("vimrc", , A_userpath "\vimfiles\", A_userpath "\vimfiles\")

        ; -------------------- 网站
        addcmd("httpCode", , "https://tool.oschina.net/commons?type=5", "http statusCode")
        addcmd("v2", , "https://wyagd001.github.io/v2/docs", "ahkv2")
        addcmd("win32api", , "https://learn.microsoft.com/zh-cn/windows/win32/api", "win32api")
        addcmd("winkjj", "runs", "https://support.microsoft.com/zh-cn/windows/windows-的键盘快捷方式8F-dcc61a57-8ff0-cffe-9796-cb9706c75eec#WindowsVersion=Windows_10" . "|"
            . "https://support.google.com/chrome/answer/157179#zippy=%2C标签页和窗口快捷键%2Cgoogle-chrome-功能快捷键%2C地址栏快捷键%2C网页快捷键", "win快捷键")
        addcmd("regex", "runs", "https://regex101.com" . "|"
            . "https://tool.oschina.net/uploads/apidocs/jquery/regexp.html", "正则表达式参考网站")

    }

    updateOSD(*) {
        ; 记录之前的输入与结果
        static hints := []
        static matchCommands := Map()
        matchCommands.Clear(), hints := []
        input := this.g["edit1"].Value
        if (input == "")
            return
        if (input == "`t") {
            this.g["edit1"].Value := this.lastcmd
            Send("{blink}{end}")
            input := this.lastcmd
        }
        if (startwith(input, 'm ')) {
            calres := eval(SubStr(input, 3))
            if (calres) {
                this.inMath := true
                this.calResult := calres
                hints := [calres, "ctrl c 复制结果"]
                this.showHints(hints)
                this.lastcmd := input
                return
            }
        }

        for id, cmd in this.cmds {
            func := cmd.func
            args := cmd.args
            hint := cmd.hint
            flag := cmd.flag
            pattern := cmd.pattern
            if (input == id) { ;全匹配
                hints := [Format("{:-30}`t# {}", id, hint)]
                matchCommands.Clear()
                matchCommands.Set(id, cmd)
                break
            }

            if (matchcmd(id, input, flag)) {
                matchCommands.Set(id, cmd)
                hints.push(Format("{:-30}`t# {}", id, hint))
            } else {
                matchId := maymatchhint(id, input, flag, pattern)
                matchId ? hints.push(Format("{:-30}`t# {}", matchId, hint)) : 0
            }
            if (hints.Length >= this.maxTipLines - 1) {
                hints.push('...')
                break
            }

            ; 判断输入是否匹配命令
            matchcmd(id, input, mode) {
                switch mode {
                    case "full": return id == input
                    case "^$": return id == input
                    case "^": return startwith(id, input)
                    case "$": return endwith(id, input)
                    case "reg": return RegExMatch(input, id)
                    default: return InStr(id, input)
                }
            }
            ; 判断输入是否匹配提示
            maymatchhint(id, input, mode, pattern) {
                switch mode {
                    case 'reg':
                        if (RegExMatch(input, pattern))
                            return id
                    case 'full', '^$':
                        if (startwith(id, input))
                            return "^" id "$"
                    case '$':
                        if (InStr(id, input))
                            return id "$"
                }
                return false
            }
        }

        this.showHints(hints)

        if (matchCommands.Count = 1) { ;唯一匹配
            this.lastcmd := input
            for key, value in matchCommands {
                id := key
                cmd := value
                break ; 退出循环，因为我们只需要第一个键值对
            }
            this.hideGui()
            ih := InputHook("T1")
            ih.Start()    ;唯一匹配即执行 所以拦截用户溢出的多余输入1秒
            ; ih.Wait() ;会阻塞
            func := cmd.func
            args := cmd.args
            hint := cmd.hint
            flag := cmd.flag
            ; this.lastcmd := id
            if isFunc(args) {
                args := args.call(input)
            } else if (flag == "reg") { ; 解析正则真正命令参数
                RegExMatch(input, id, &matchs)
                args := matchs[1]
                ; this.lastcmd := input
            }
            if (this.dealCommand(func, args))
                this.showGui()
        }

    }
    showHints(hints) => tip.show(strJoin(hints, '`n'), 'oo', this.tipx, this.showy + this.UIHeight, 1)
    unShowHints() => tip.removeTip(1)

    dealCommand(func, args) {
        try {
            keep := 0
            if isFunc(func) {
                args := isString(args) ? [args] : args
                func.call(args*)
                return keep
            }
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
                case "ahkq": ahk("q", args)
                default: return 0
            }
            return keep ;if keep == 1 ,dont exit
        }
        catch as e {
            log(e)
        }
    }

    toggleGui() => (WinExist(win_ahk " ahk_id " this.g.Hwnd) ? this.hideGui() : this.showGui())
    hideGui(keepTip := 500) {
        SetTimer(() => this.unShowHints(), -keepTip) ;慢点消失避免看不到执行的命令
        this.inMath := false
        this.g.hide()
    }
    showGui() {
        this.g.Show("y" . this.showy)
        this.g["edit1"].Value := "tab: " . this.lastcmd
        send("^a")
    }
}


; ==========o==========o==========o==========o==========o hooks
colorg := colorGUI()
#HotIf WinExist(win_ahk " ahk_id " colorg.g.Hwnd)
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
