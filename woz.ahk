#SingleInstance Force
#NoTrayIcon
#Include Lib\funcs.ahk
#Include private.ahk
#HotIf
setup()
global lastcmd := ""
MyGui := Gui()
MyGui.BackColor := "333333" ; EEAA99可以是任何 RGB 颜色(下面会变成透明的).
; WinSetTransColor(MyGui.BackColor " 225", MyGui)
MyGui.SetFont("cBlack s20 bold q5")
MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow") ; +ToolWindow 避免显示任务栏按钮和 alt-tab 菜单项.
edit1 := MyGui.Add("Edit", "WantTab t4 ym") ; ym 选项开始一个新的控件列.
<^space:: toggleGui(), KeyWait("space")
~esc:: hideGui(), removeAllTip(5)
>^space:: ahkManager()

setup() {
    global cmds := Map()
    CoordMode("ToolTip", "Screen")
    addCommand(id, func := id, funcArg := "", hint := id) {
        cmds.Set(id, [func, funcArg, hint])
    }
    dk2 := A_Desktop . "\桌面2\" ;用来存放快捷方式,自行将目录放入环境变量path里
    userpath := A_userPath() ; C:\Users\79481
    addCommand("nop")
    addCommand("-v", "-v", , A_AhkVersion)
    addCommand("timer")
    addCommand("game", "game", , "switch in game")
    addCommand("showintxt", , , "将剪贴板内容用vscode打开") ;
    addCommand("bluetooth")
    addCommand("ls", , , "list all ahk")
    addCommand("clear", "recycleEmpty", "", "清空回收站")
    addCommand("restartexplorer")
    addCommand("ps", , , "processManager")
    addCommand("touchpad") ;切换触摸板
    addCommand("remote", "run", "mstsc", "远程桌面连接")
    addCommand("mstsc", "run", "mstsc", "远程桌面连接")
    addCommand("colorhook") ; *useful
    addCommand("record")
    addCommand("quit")
    addCommand("taskmgr", "run", "taskmgr", "open taskmgr")
    addCommand("reload")
    addCommand("ahkmanager")


    addCommand("main", "runAs", "main.ahk", "runAs main.ahk")
    addCommand("woz", "runAs", "woz.ahk", "runAs woz.ahk")
    addCommand("test", "runAs", "test.ahk", "runAs test.ahk")

    addCommand("vscode", "run", "code.exe", "run vscode")
    addCommand("cpp", "run", "code.exe D:\projects\cpp", "run vscode cpp")
    addCommand("dy", "run", "code.exe E:\垃圾桶\dy.txt", "code dy.txt")

    addCommand("notepad", "run", "notepad.exe", "run notepad")
    addCommand("edge", "runAs", "edge", "runAs edge")
    addCommand("wt", "runAs", "wt", "runAs wt.exe")
    addCommand("chrome", "runAs", "chrome.exe", "runAs chrome")
    addCommand("clash", "runAs", dk2 "Clash", "runAs clash")
    addCommand("google", "runAs", "chrome.exe", "runAs google")

    addCommand("myPDF", "run", dk2 "myPDF.exe", "run myPDF.exe")
    addCommand("myMat", "run", dk2 "myMat", "run myMat")

    addCommand("wx", "run", dk2 "wechat", "run wechat")
    addCommand("qq", "run", dk2 "qq", "run QQ")
    addCommand("yd", "run", dk2 "yd", "run youdao")
    addCommand("qm", "run", dk2 "qm", "run QQMusic")
    addCommand("kugou", "run", dk2 "kugou", "run kugou")
    addCommand("wyy", "run", dk2 "wyy", "run cloudmusic")
    addCommand("bdwp", "run", dk2 "bdwp", "run baiduwanpan")

    addCommand("wicleanup", "run", dk2 "WICleanupUI", "run WICleanupUI")
    addCommand("idm", "runAs", dk2 "IDM", "runAs idm")
    addCommand("bandicam", "runAs", dk2 "bandicam", "runAs bandicam")
    addCommand("geek", "runAs", dk2 "geek", "runAs geek")
    addCommand("teamviewer", "run", dk2 "teamviewer", "run teamviewer")
    addCommand("steam", "runAs", dk2 "steam", "runAs steam")
    addCommand("ccleaner", "runAs", dk2 "ccleaner", "runAs ccleaner")
    addCommand("Snipaste", "runAs", dk2 "Snipaste", "runAs Snipaste")
    addCommand("spacesniffer", "runAs", dk2 "spacesniffer", "runAs spacesniffer")
    addCommand("DefenderC", "runAs", dk2 "DefenderControl", "runAs DefenderControl")
    addCommand("photoshop", "runAs", dk2 "ps", "runAs photoshop")
    addCommand("ncm", "runAs", dk2 "ncm", "runAs ncm")
    addCommand("everything", "runAs", dk2 "everything", "runAs everything")
    addCommand("Final2x", "run", dk2 "Final2x", "run Final2x")
    addCommand("snapdrop", "run", dk2 "snapdrop", "run snapdrop")

    ; -------------------- 系统配置
    addCommand("env", "env", "", "环境变量")
    addCommand("regedit", "run", "regedit", "regedit")
    addCommand("dxdiag", "run", "dxdiag", "dxdiag")
    addCommand("services.msc", "run", "services.msc", "services.msc")
    addCommand("cont", "run", "control", "control")

    ; -------------------- 系统文件目录
    addCommand("nas", "nas", "", "nas") ;
    addCommand("~", "run", userpath, userpath)
    addCommand("program", "run", "C:\Program Files\", "C:\Program Files")
    addCommand("pro86", "run", "C:\Program Files (x86)\", "C:\Program Files (x86)")
    addCommand("document", "run", A_MyDocuments, A_MyDocuments)
    ; addCommand("document", "run", userpath . "\Documents\", "C:\Users\79481\Documents")
    addCommand("system", "run", "C:\Windows\System\", "C:\Windows\System")
    addCommand("sys32", "run", "C:\Windows\System32\", "C:\Windows\System32")
    addCommand("dk2", "run", dk2, "桌面2")
    addCommand("appdata", "run", userpath "\AppData\", "~\AppData")
    addCommand("roam", "run", A_AppData, "%AppData%")
    addCommand("host", "run", "C:\Windows\System32\drivers\etc", "host")
    addCommand("startm", "run", A_StartMenu, "Start Menu")
    addCommand("startup", "run", A_Startup, "shell:startup")

    ; -------------------- 软件目录
    addCommand("wsl", "run", "\\wsl$\Ubuntu-20.04", "wsl")
    addCommand("vscdeemo", "run", "D:\VSCodeDeemo\", "D:\VSCodeDeemo\")
    addCommand("vscsetting", "run", "C:\Users\79481\AppData\Roaming\Code\User", "vscode Setting.json 文件夹")
    addCommand("vscsetting", "run", "C:\Users\79481\AppData\Roaming\Code\User", "vscode Setting.json 文件夹")
    addCommand("scoop", "run", "D:\Scoop", "scoop")
    ; -- vim/nvim目录
    addCommand("vim", "run", "D:\vim\vim90\", "D:\vim\vim90\")
    addCommand("vimrc\", "run", "C:\Users\79481\vimfiles\", "C:\Users\79481\vimfiles\")
    addCommand("vimfiles", "run", "C:\Users\79481\vimfiles\", "~\vimfiles\")
    addCommand("nvim", "runs", "C:\Users\79481\AppData\Local\nvim\" . "|"
        . "C:\Users\79481\AppData\Local\nvim-data", "nvim\") ;"C:\Users\79481\.config\nvim\

    ; -------------------- 网站
    addCommand("v2", "run", "https://wyagd001.github.io/v2/docs", "ahkv2")
    addCommand("win32api", "run", "https://learn.microsoft.com/zh-cn/windows/win32/api", "win32api")
    addCommand("winkjj", "runs", "https://support.microsoft.com/zh-cn/windows/windows-的键盘快捷方式8F-dcc61a57-8ff0-cffe-9796-cb9706c75eec#WindowsVersion=Windows_10" . "|"
        . "https://support.google.com/chrome/answer/157179#zippy=%2C标签页和窗口快捷键%2Cgoogle-chrome-功能快捷键%2C地址栏快捷键%2C网页快捷键", "win快捷键")
    addCommand("regex", "runs", "https://regex101.com" . "|"
        . "https://tool.oschina.net/uploads/apidocs/jquery/regexp.html", "正则表达式参考网站")
    addCommand("rgb", "run", "https://www.gairuo.com/p/web-color", "rgb")
    addCommand("fdu", "runs", "http://ehall.fudan.edu.cn/ywtb-portal/fudan/index.html#/hall" . "|"
        . "http://yjsxk.fudan.edu.cn/yjsxkapp/sys/xsxkappfudan/xsxkHome/gotoChooseCourse.do" . "|"
        . "https://elearning.fudan.edu.cn/courses", "fdu")
}

deal(cmd, arg) {
    try {
        keep := 0
        switch cmd {
            case "run": run(arg), tipLB("run " arg)
            case "runAs": run("*runAs " arg), tipLB("*runAs " arg)
            case "Hrun": run(arg, , "Hide"), tipLB("Hrun " arg)
            case "HrunAs": run("*runAs " arg, , "Hide"), tipLB("*HrunAs " arg)
            case "runs":
                for s in StrSplit(arg, "|", ' ')
                    run(s)
                tipLB("runs: `n" StrReplace(arg, "|", "`n"))

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
            default: return 0
            case "nas": private.nas()
        }
        return keep ;if keep == 1 ,dont exit
    }
    catch as e {
        log(e)
    }
}

updateOSD() {
    ; 记录之前的输入与结果
    static text := ""
    static hints := ""
    static uniqueMatch := "" ;唯一匹配的cmd
    static matchCommands := Map()
    input := MyGui["edit1"].Value

    if (input == "")
        return
    if (input == "`t")
        input := lastcmd
    if (input != text) {
        ;有变化才更新
        text := input
        matchCommands.Clear()
        hints := "", uniqueMatch := ""

        for k, v in cmds {
            if (k == text) { ;全匹配
                matchCommands.Clear()
                matchCommands.Set(k, v), uniqueMatch := k
                break
            }
            if (Instr(k, text)) {
                matchCommands.Set(k, v), uniqueMatch := k
                hints .= Format("{:-30}`t# {}", k, v[3]), hints .= "`n"
            }
        }
    }

    static num := 1
    num := nextn(num, 3)
    tip(hints, 500, 771, 276, num)

    if (matchCommands.Count = 1) { ;唯一匹配
        global lastcmd := uniqueMatch
        hideGui()
        ih := InputHook("T1")
        ih.Start()    ;唯一匹配即执行 所以拦截用户溢出的多余输入1秒
        ; ih.Wait() ;会阻塞
        if (deal(matchCommands[uniqueMatch][1], matchCommands[uniqueMatch][2]))
            showGui()
    }

}

toggleGui() {
    ; ahk_class AutoHotkeyGUI
    if (WinExist("ahk_exe AutoHotkey64.exe ahk_id " MyGui.Hwnd))
        hideGui()
    else
        showGui()
}
hideGui() {
    SetTimer(updateOSD, 0)
    MyGui.hide()
}
showGui() {
    MyGui.Show("y200")
    MyGui["edit1"].Value := "tab: " lastcmd
    send("^a")
    ; SetTimer(UpdateOSD, 250)
    SetTimer(updateOSD, 200)
}


; ==========o==========o==========o==========o==========o hooks
colorg := colorhook()
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
