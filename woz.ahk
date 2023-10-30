#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon
#Include Lib\funcs.ahk
#Include private.ahk
#HotIf

SetTitleMatchMode("RegEx")
CoordMode("ToolTip", "Screen")

woz := WozManager()
<^space:: woz.toggleGui(), KeyWait("space")
~esc:: woz.hideGui(), removeAllTip(5)
>^space:: ahkManager()
win_woz := "woz.ahk ahk_exe AutoHotkey64.exe ahk_class AutoHotkeyGUI"
#HotIf WinActive(win_woz)
enter::tab
<^l::tab
#HotIf

class WozManager {
    lastcmd := ""
    g := this.creatGui()
    cmds := Map()
    timer := this.updateOSD.Bind(this)
    __New() {
        this.addcmds()
    }

    addcmds() {
        addcmd(id, func := id, args := "", hint := id, flag := "") {
            this.cmds.Set(id, [func, args, hint, flag])
        }
        dk2 := A_Desktop . "\桌面2\" ;用来存放快捷方式,自行将目录放入环境变量path里
        userpath := A_userPath() ; C:\Users\79481

        addcmd("^k (.*)`t$", "kill", "fromid", "kill (.*)", "reg")
        addcmd("^q (.*)`t$", "ahkq", "fromid", "quit (.*).ahk", "reg")

        addcmd("k qm", "kill", "qm", "kill qm", "full")
        addcmd("k wyy", "kill", "wyy", "kill cloudmusic", "full")
        addcmd("k wx", "kill", "wx", "kill WeChat.exe", "full")
        addcmd("k clash", "kill", "clash", "kill clash", "full")
        addcmd("k yd", "kill", "yd", "kill youdao", "full")

        addcmd("q main", "ahkq", "main", "quit main.ahk", "full")

        addcmd("nop")
        addcmd("-v", , , A_AhkVersion)
        addcmd("timer")

        ; addcmd("^k .* $", "kill", "fromid", "kill something", "reg")
        addcmd("game", , , "switch in game")
        addcmd("showintxt", , , "将剪贴板内容用vscode打开") ;
        addcmd("bluetooth", , , "打开蓝牙设置")
        addcmd("ls", , , "list all ahk")
        addcmd("clear", "recycleEmpty", , "清空回收站")
        addcmd("restartexplorer", , , "重启资源管理器")
        addcmd("ps", , , "processManager")
        addcmd("touchpad", , , "切换触摸板")
        addcmd("remote", "run", "mstsc", "远程桌面连接")
        addcmd("mstsc", "run", "mstsc", "远程桌面连接")
        addcmd("colorhook") 
        addcmd("record")
        addcmd("quit")
        addcmd("taskmgr", "run", "taskmgr", "open taskmgr")
        addcmd("reload")
        addcmd("ahkmanager")

        addcmd("main", "runAs", "main.ahk", "runAs main.ahk")
        addcmd("woz", "runAs", "woz.ahk", "runAs woz.ahk")
        addcmd("test", "runAs", "test.ahk", "runAs test.ahk")

        addcmd("code", "run", "code", "run vscode")
        addcmd("cpp", "run", "code D:\projects\cpp", "run vscode cpp")
        addcmd("dy", "run", "code E:\垃圾桶\dy.txt", "code dy.txt")

        addcmd("notepad", "run", "notepad.exe", "run notepad")
        addcmd("edge", "runAs", "edge", "runAs edge")
        addcmd("wt", "runAs", "wt", "runAs wt.exe")
        addcmd("chrome", "runAs", "chrome.exe", "runAs chrome")
        addcmd("clash", "runAs", dk2 "Clash", "runAs clash")
        addcmd("google", "runAs", "chrome.exe", "runAs google")

        addcmd("myPDF", "run", dk2 "myPDF.exe", "run myPDF.exe")
        addcmd("myMat", "run", dk2 "myMat", "run myMat")

        addcmd("wx", "run", dk2 "wechat", "run wechat")
        addcmd("qq", "run", dk2 "qq", "run QQ")
        addcmd("yd", "run", dk2 "yd", "run youdao")
        addcmd("qm", "run", dk2 "qm", "run QQMusic")
        addcmd("kugou", "run", dk2 "kugou", "run kugou")
        addcmd("wyy", "run", dk2 "wyy", "run cloudmusic")
        addcmd("bdwp", "run", dk2 "bdwp", "run baiduwanpan")

        addcmd("wicleanup", "run", dk2 "WICleanupUI", "run WICleanupUI")
        addcmd("idm", "runAs", dk2 "IDM", "runAs idm")
        addcmd("bandicam", "runAs", dk2 "bandicam", "runAs bandicam")
        addcmd("geek", "runAs", dk2 "geek", "runAs geek")
        addcmd("teamviewer", "run", dk2 "teamviewer", "run teamviewer")
        addcmd("steam", "runAs", dk2 "steam", "runAs steam")
        addcmd("ccleaner", "runAs", dk2 "ccleaner", "runAs ccleaner")
        addcmd("Snipaste", "runAs", dk2 "Snipaste", "runAs Snipaste")
        addcmd("spacesniffer", "runAs", dk2 "spacesniffer", "runAs spacesniffer")
        addcmd("DefenderC", "runAs", dk2 "DefenderControl", "runAs DefenderControl")
        addcmd("photoshop", "runAs", dk2 "ps", "runAs photoshop")
        addcmd("ncm", "runAs", dk2 "ncm", "runAs ncm")
        addcmd("everything", "runAs", dk2 "everything", "runAs everything")
        addcmd("Final2x", "run", dk2 "Final2x", "run Final2x")
        addcmd("snapdrop", "run", dk2 "snapdrop", "run snapdrop")

        ; -------------------- 系统配置
        addcmd("env", "env", "", "环境变量")
        addcmd("regedit", "run", "regedit", "regedit")
        addcmd("dxdiag", "run", "dxdiag", "dxdiag")
        addcmd("services.msc", "run", "services.msc", "services.msc")
        addcmd("cont", "run", "control", "control")

        ; -------------------- 系统文件目录
        addcmd("nas", "nas", "", "nas") ;
        addcmd("~", "run", userpath, userpath)
        addcmd("program", "run", "C:\Program Files\", "C:\Program Files")
        addcmd("pro86", "run", "C:\Program Files (x86)\", "C:\Program Files (x86)")
        addcmd("document", "run", A_MyDocuments, A_MyDocuments)
        ; addCommand("document", "run", userpath . "\Documents\", "C:\Users\79481\Documents")
        addcmd("system", "run", "C:\Windows\System\", "C:\Windows\System")
        addcmd("sys32", "run", "C:\Windows\System32\", "C:\Windows\System32")
        addcmd("dk2", "run", dk2, "桌面2")
        addcmd("appdata", "run", userpath "\AppData\", "~\AppData")
        addcmd("roam", "run", A_AppData, "%AppData%")
        addcmd("host", "run", "C:\Windows\System32\drivers\etc", "host")
        addcmd("startm", "run", A_StartMenu, "Start Menu")
        addcmd("startup", "run", A_Startup, "shell:startup")

        ; -------------------- 软件目录
        addcmd("wsl", "run", "\\wsl$\Ubuntu-20.04", "wsl")
        addcmd("vscdeemo", "run", "D:\VSCodeDeemo\", "D:\VSCodeDeemo\")
        addcmd("vscsetting", "run", "C:\Users\79481\AppData\Roaming\Code\User", "vscode Setting.json 文件夹")
        addcmd("vscsetting", "run", "C:\Users\79481\AppData\Roaming\Code\User", "vscode Setting.json 文件夹")
        addcmd("scoop", "run", "D:\Scoop", "scoop")
        ; -- vim/nvim目录
        addcmd("vim", "run", "D:\vim\vim90\", "D:\vim\vim90\")
        addcmd("vimrc\", "run", "C:\Users\79481\vimfiles\", "C:\Users\79481\vimfiles\")
        addcmd("vimfiles", "run", "C:\Users\79481\vimfiles\", "~\vimfiles\")
        addcmd("nvim", "runs", "C:\Users\79481\AppData\Local\nvim\" . "|"
            . "C:\Users\79481\AppData\Local\nvim-data", "nvim\") ;"C:\Users\79481\.config\nvim\

        ; -------------------- 网站
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
        static hints := ""
        static uniqueMatch := "" ;唯一匹配的cmd
        static matchCommands := Map()

        input := this.g["edit1"].Value
        if (input == "`t")
            input := this.lastcmd
        if (input == "")
            return
        if (input != text) {
            ;有变化才更新
            text := input
            matchCommands.Clear()
            hints := "", uniqueMatch := ""

            for k, v in this.cmds {
                if (k == text) { ;全匹配
                    hints := Format("{:-30}`t# {}`n", k, v[3])
                    matchCommands.Clear()
                    matchCommands.Set(k, v), uniqueMatch := k
                    break
                }

                flag := v[4]
                if (match(k, text, v[4])) {
                    matchCommands.Set(k, v), uniqueMatch := k
                    hints .= Format("{:-30}`t# {}`n", k, v[3])
                } else {
                    ; 不匹配也可能需要补充hint
                    if (flag == "reg") {
                        if (RegExMatch(SubStr(k, 1, StrLen(k) - 2), text))
                            hints .= Format("{:-30}`t# {}`n", k, v[3])
                    }
                    else if (flag == "full") {
                        if (startwith(k, text))
                            hints .= Format("{:-30}`t# {}`n", "^" k "$", v[3])
                    }
                    else if (flag == "$") {
                        if (InStr(k, text))
                            hints .= Format("{:-30}`t# {}`n", k "$", v[3])
                    }
                }

                match(k, text, flag) {
                    ; k      =   ^q main
                    ; text   =   q m
                    switch flag {
                        case "full":
                            return k == text
                        case "^":
                            return startwith(k, text)
                        case "$":
                            return endwith(k, text)
                        case "reg":
                            return RegExMatch(text, k)
                        default:
                            return InStr(k, text, true)
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
            if (flag == "reg") {
                RegExMatch(text, k, &matchs)
                args := matchs[1]
                this.lastcmd := input
            }
            if (this.deal(func, args))
                this.showGui()
        }

    }

    showHints(hints) {
        static num := 1
        num := nextn(num, 3)
        tip(hints, 500, 771, 276, num)
    }

    deal(func, args) {
        try {
            keep := 0
            switch func {
                case "run": run(args), tipLB("run " args)
                case "runAs": run("*runAs " args), tipLB("*runAs " args)
                case "Hrun": run(args, , "Hide"), tipLB("Hrun " args)
                case "HrunAs": run("*runAs " args, , "Hide"), tipLB("*HrunAs " args)
                case "runs":
                    for s in StrSplit(args, "|", ' ')
                        run(s)
                    tipLB("runs: `n" StrReplace(args, "|", "`n"))

                case "-v": tipRB(A_ScriptName " version AHK " A_AhkVersion)
                case "restartexplorer": restartExplorer()
                case "ps": processManager()
                case "showintxt": showIntxt(A_Clipboard)
                case "recycleEmpty":
                    if (MsgBox("是否清空回收站?", "", 1) = "ok")
                        FileRecycleEmpty(), tipLB("FileRecycleEmpty")
                case "record": ahk("t", "record.ahk", ".\utils\record.ahk")
                case "colorhook": colorg.toggleshow() ;!!!!!
                case "touchpad": toggleTouchpad()
                case "bluetooth": Run("control.exe bthprops.cpl")
                    ; case "timer": timeh.toggleshow()
                    ; case "sett": timeh.isshow() and timeh.setdeadline()
                case "env":
                    run("sysdm.cpl"), WinWaitActive("系统属性")
                    send("{ctrl Down}{Tab 2}{ctrl Up}!n")
                case "ahkmanager": ahkManager()
                case "ls": tipRB(ahk("ls"), 5000)
                case "reload": run("*runAs woz.ahk") ;管理员
                case "quit": MsgBox("quit?", , 1) = "ok" ? ExitApp : nop()
                case "nas": private.nas()
                case "ahkq": ahk("q", args)
                case "kill": taskkill(args)

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
        this.g.Show("y200")
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
