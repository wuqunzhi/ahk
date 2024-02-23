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
tip.n(A_ScriptName " running. AHK " A_AhkVersion, 1000, 0, -2)

woz := WozUI()

<^space:: woz.toggleGui(), KeyWait("space")
~esc:: woz.hideGui(), tip.removeAllTip(5)
>^space:: ahkManager()

#HotIf WinActive(win_woz)
enter::tab
NumpadEnter::tab
<^l::tab
#HotIf WinActive(win_woz) and woz.mode == 'math'
^c:: copyandshow(woz.copystr, 3000, 1190, 223)
<^l::
enter::
tab:: copyandshow(woz.copystr, 5000, 1190, 223), woz.hideGui()
#HotIf


class WozUI {
    mode := 'hide'
    copystr := ''
    lastcmd := ''
    ; timer := this.updateOSD.Bind(this)
    g := Gui()
    showy := 200
    UIHeight := 76
    UIWidth := 76
    tipx := 770
    maxTipLines := (A_ScreenHeight - A_TaskbarHeight - this.showy - this.UIHeight) // 20
    cmds := Map()
    __New() {
        this.initCMDs()
        this.initGui()
    }
    initGui() {
        this.g.BackColor := "333333" ; EEAA99可以是任何 RGB 颜色(下面会变成透明的).
        ; WinSetTransColor(MyGui.BackColor " 225", MyGui)
        this.g.SetFont("cBlack s20 bold q5")
        this.g.Opt("+AlwaysOnTop -Caption +ToolWindow") ; +ToolWindow 避免显示任务栏按钮和 alt-tab 菜单项.
        this.g.edit1 := this.g.Add("Edit", "WantTab t4 ym") ; ym 选项开始一个新的控件列.
        this.g.edit1.OnEvent("Change", this.updateOSD.Bind(this))
        this.g.OnEvent("Escape", (*) => this.hideGui())
    }
    initCMDs() {
        /**
         * @param id 命令id
         * @param func 函数名 
         * @param args 函数参数 
         * @param hint 显示描述 
         * @param flag 匹配规则 ^ * full reg
         * @param pattern 什么情况显示
         */
        addcmd(id, func := id, args := "", hint := id, flag := "", pattern := "") {
            this.cmds.Set(id, [func, args, hint, flag, pattern])
        }
        for filename in getfiles(A_desktop2 "\*") {
            if (endwiths(filename, [".jpg", ".png", ".jpeg"]))
                continue
            filename := rtrims(filename, ['.lnk', '.exe'])
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

        addcmd("key", "run", "code D:\vscodeProjects\ahk\keyChange.ahk", "keychange")
        addcmd("c bililive", "code", vspDir "\bililive", "code bililive")
        addcmd("c ahk", "code", vspDir "\ahk", "code ahk")


        ; ahk
        addcmd("q main", "ahkq", "main", "quit main.ahk", "full")
        addcmd("q test", "ahkq", "test", "quit test.ahk", "full")
        addcmd("q woz", "ahkq", "woz", "quit woz.ahk", "full")
        addcmd("main", "runAs", "main.ahk", "runAs main.ahk")
        addcmd("woz", "runAs", "woz.ahk", "runAs woz.ahk")
        addcmd("test", "runAs", "test.ahk", "runAs test.ahk")
        addcmd("dy", "run", "code E:\垃圾桶\dy.txt", "code dy.txt")

        addcmd("nop")
        addcmd("-v", , , A_AhkVersion)
        addcmd("timer")
        addcmd("game")
        addcmd("showintxt", , , "将剪贴板内容用vscode打开") ;
        addcmd("bluetooth", , , "打开蓝牙设置")
        addcmd("ls", , , "list all ahk")
        addcmd("fclr", "recycleEmpty", , "清空回收站")
        addcmd("wclr", "winclear", , "关闭无关紧要窗口")
        addcmd("restartexplorer", , , "重启资源管理器")
        addcmd("CombineButtons", , , "切换合并任务栏按钮") ;
        addcmd("ps", , , "processManager")
        addcmd("touchpad", , , "切换触摸板")
        addcmd("ulpb", , , "切换双拼全拼")
        addcmd("lock", , , "锁屏")
        addcmd("remote", "run", "mstsc", "远程桌面连接")
        addcmd("mstsc", "run", "mstsc", "远程桌面连接")
        addcmd("colorhook")
        addcmd("record")
        addcmd("taskmgr", "run", "taskmgr", "打开任务管理器")
        addcmd("reload")
        addcmd("quit")
        addcmd("ahkmanager")


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
        addcmd("wsl", "run", "\\wsl.localhost\Ubuntu", "wsl")
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
    updateOSD(*) {
        ; 记录之前的输入与结果
        static hints := []
        static uniqueMatch := "" ;唯一匹配的cmd
        static matchCommands := Map()
        matchCommands.Clear(), hints := [], uniqueMatch := ""
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
                this.mode := 'math'
                this.copystr := calres
                hints := [calres, "ctrl c 复制结果"]
                this.showHints(hints)
                this.lastcmd := input
                return
            }
        }

        for cmdKey, cmdValue in this.cmds {
            func := cmdValue[1]
            args := cmdValue[2]
            hint := cmdValue[3]
            flag := cmdValue[4]
            pattern := cmdValue[5]
            if (input == cmdKey) { ;全匹配
                hints := [Format("{:-30}`t# {}", cmdKey, hint)]
                matchCommands.Clear()
                matchCommands.Set(cmdKey, cmdValue), uniqueMatch := cmdKey
                break
            }

            if (matchcmd(cmdKey, input, flag)) {
                matchCommands.Set(cmdKey, cmdValue), uniqueMatch := cmdKey
                hints.push(Format("{:-30}`t# {}", cmdKey, hint))
            } else {
                maymatchhint(cmdKey, input, flag, pattern)
            }
            if (hints.Length >= this.maxTipLines - 1) {
                hints.push('...')
                break
            }

            matchcmd(cmdKey, input, flag) {
                switch flag {
                    case "full": return cmdKey == input
                    case "^$": return cmdKey == input
                    case "^": return startwith(cmdKey, input)
                    case "$": return endwith(cmdKey, input)
                    case "reg": return RegExMatch(input, cmdKey)
                    default: return InStr(cmdKey, input)
                }
            }
            maymatchhint(cmdKey, input, flag, pattern) {
                switch flag {
                    case 'reg':
                        if (RegExMatch(input, pattern))
                            hints.push(Format("{:-30}`t# {}", cmdKey, hint))
                    case 'full', '^$':
                        if (startwith(cmdKey, input))
                            hints.push(Format("{:-30}`t# {}", "^" cmdKey "$", hint))
                    case '$':
                        if (InStr(cmdKey, input))
                            hints.push(Format("{:-30}`t# {}", cmdKey "$", hint))
                }
            }
        }

        this.showHints(hints)

        if (matchCommands.Count = 1) { ;唯一匹配
            ; RegExMatch("q  main $", "^q  (.*) $", &arg)
            ; if (RegExMatch(text, k, &arg)) {k
            this.hideGui(500)
            ih := InputHook("T1")
            ih.Start()    ;唯一匹配即执行 所以拦截用户溢出的多余输入1秒
            ; ih.Wait() ;会阻塞

            cmdKey := uniqueMatch
            cmdValue := matchCommands[uniqueMatch]
            func := cmdValue[1]
            args := cmdValue[2]
            hint := cmdValue[3]
            flag := cmdValue[4]
            this.lastcmd := cmdKey
            if (flag == "reg") { ; 解析正则真正命令参数
                RegExMatch(input, cmdKey, &matchs)
                args := matchs[1]
                this.lastcmd := input
            }
            if (this.dealCommand(func, args))
                this.showGui()
        }

    }
    showHints(hints) {
        res := strJoin(hints, '`n')
        ; static num := 1
        ; num := nextn(num, 3)
        tip.pp(res, 'oo', this.tipx, this.showy + this.UIHeight, 1)
    }
    unShowHints() {
        tip.removeTip(1)
    }

    dealCommand(func, args) {
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

                case "code": tip.p(args), run("code " args), tip.LB("code " args)

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
                case "ulpb": toggleDoublePin()
                case "bluetooth": Run("control.exe bthprops.cpl")
                    ; case "timer": timeh.toggleshow()
                case "env":
                    run("sysdm.cpl"), WinWaitActive("系统属性")
                    send("{ctrl Down}{Tab 2}{ctrl Up}!n")
                case "ahkmanager": ahkManager()
                case "ls": tip.RB(ahk("ls"), 5000)
                case "reload": run("*runAs " A_ScriptName) ;管理员
                case "quit": (MsgBox("quit?", , 1) == "OK") ? ahk("q", "woz.ahk") : 0
                case "nas": private.nas()
                case "ahkq": ahk("q", args)
                case "kill": mytaskkill(args)
                case "lock": lockComputer()

                default: return 0
            }
            return keep ;if keep == 1 ,dont exit
        }
        catch as e {
            log(e)
        }
    }

    toggleGui() {
        ; ahk_class AutoHotkeyGUI
        if (WinExist("ahk_exe AutoHotkey64.exe ahk_id " this.g.Hwnd))
            this.hideGui()
        else
            this.showGui()
    }

    hideGui(keepTip := 100) {
        SetTimer(() => this.unShowHints(), -keepTip) ;慢点消失避免看不到执行的命令
        this.mode := 'hide'
        this.g.hide()
    }

    showGui() {
        this.g.Show("y" . this.showy)
        this.g["edit1"].Value := "tab: " . this.lastcmd
        send("^a")
        ; SetTimer(this.timer, 200)
        ; this.updateOSD()
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
