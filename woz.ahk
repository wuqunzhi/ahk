#SingleInstance Force
#NoTrayIcon
#Include Lib\funcs.ahk
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
    addCommand("nop")
    addCommand("-v", "-v", , A_AhkVersion)
    addCommand("timer")
    addCommand("game", "game", , "switch in game")
    addCommand("showintxt")
    addCommand("bluetooth")
    addCommand("ls", , , "list all ahk")
    addCommand("clear", "recycleEmpty", "", "FileRecycle Empty")
    addCommand("restartexplorer")
    addCommand("ps", , , "processManager")
    addCommand("touchpad")
    addCommand("remote", "run", "mstsc", "远程桌面连接")
    addCommand("mstsc", "run", "mstsc", "远程桌面连接")
    addCommand("highconstract")
    addCommand("colorhook") ; *useful
    addCommand("record")
    addCommand("quit")
    addCommand("reload")
    addCommand("ahkmanager")
    addCommand("ck", "click", "", "focus center")


    addCommand("taskmgr", "run", "taskmgr", "open taskmgr")
    addCommand("main", "runAs", "main.ahk", "runAs main.ahk")
    addCommand("woz", "runAs", "woz.ahk", "runAs woz.ahk")
    addCommand("test", "runAs", "test.ahk", "runAs test.ahk")

    ; -------------------- 打开软件 建一个文件夹放到env放快捷方式
    addCommand("vscode", "run", "code.exe", "run vscode")
    addCommand("cpp", "run", "code.exe D:\VSCodeDeemo\c_cpp", "run vscode cpp")
    addCommand("dy", "run", "code.exe E:\垃圾桶\dy.txt", "code dy.txt")

    addCommand("notepad", "run", "notepad.exe", "run notepad")
    addCommand("edge", "runAs", "edge", "runAs edge")
    addCommand("wt", "runAs", "wt", "runAs WindowsTerminal")
    addCommand("chrome", "runAs", "chrome.exe", "runAs chrome")
    addCommand("google", "runAs", "chrome.exe", "runAs google")

    dk2 := A_Desktop . "\桌面2\" ;LocalAppData := EnvGet("LocalAppData")
    addCommand("myPDF", "run", dk2 "myPDF.exe", "run myPDF.exe")
    addCommand("myMat", "run", dk2 "myMat", "run myMat")
    addCommand("winvind", "HrunAs", "win-vind", "run win-vind")
    addCommand("clash", "runAs", dk2 "Clash", "runAs clash")

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
    cccpaths := ["C:\Users\79481\AppData\Local\temp",
        "C:\Users\79481\AppData\Roaming\pyinstaller",
        "C:\Windows\servicing\LCU"
    ]
    addCommand("ccc", "runs", strJoin(cccpaths, '|'), "打开c盘可以删的文件夹")
    addCommand("~", "run", "C:\Users\79481\", "C:\Users\79481")
    addCommand("program", "run", "C:\Program Files\", "C:\Program Files")
    addCommand("pro86", "run", "C:\Program Files (x86)\", "C:\Program Files (x86)")
    addCommand("document", "run", "C:\Users\79481\Documents\", "C:\Users\79481\Documents")
    addCommand("system", "run", "C:\Windows\System\", "C:\Windows\System")
    addCommand("sys32", "run", "C:\Windows\System32\", "C:\Windows\System32")
    addCommand("dk2", "run", "C:\Users\79481\Desktop\桌面2", "桌面2")
    addCommand("appdata", "run", "C:\Users\79481\AppData\", "~\AppData")
    addCommand("roam", "run", "C:\Users\79481\AppData\Roaming\", "%AppData%")
    addCommand("host", "run", "C:\Windows\System32\drivers\etc", "host")
    addCommand("startm", "run", A_StartMenu, "Start Menu")
    addCommand("startup", "run", A_Startup, "shell:startup")
    addCommand("cbh", "run", "~/ClipboardHistory.txt", "~/ClipboardHistory.txt")

    ; -------------------- 软件目录
    addCommand("wsl", "run", "\\wsl$\Ubuntu-20.04", "wsl")
    addCommand("vscdeemo", "run", "D:\VSCodeDeemo\", "D:\VSCodeDeemo\")
    addCommand("vscsetting", "run", "C:\Users\79481\AppData\Roaming\Code\User", "vscode Setting.json 文件夹")
    addCommand("vscsetting", "run", "C:\Users\79481\AppData\Roaming\Code\User", "vscode Setting.json 文件夹")
    addCommand("scoop", "run", "D:\Scoop", "scoop")
    ; -- vim/nvim目录
    addCommand("vim", "run", "D:\vim\vim90\", "D:\vim\vim90\")
    addCommand("vimrc\", "run", "C:\Users\79481\vimfiles\", "C:\Users\79481\vimfiles\")
    addCommand("vimfiles", "run", "C:/Users/79481/vimfiles/", "~/vimfiles/")
    addCommand("nvim", "runs", "C:/Users/79481/AppData/Local/nvim/" . "|"
        . "C:/Users/79481/AppData/Local/nvim-data", "nvim/") ;"C:/Users/79481/.config/nvim/

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
    keep := 0
    switch cmd {
        case "-v": tipRB(A_ScriptName "version AHK " A_AhkVersion)
        case "restartexplorer": restartExplorer()
        case "game": togglegame()
        case "ps": processManager()
        case "showintxt": showIntxt(A_Clipboard)
        case "recycleEmpty":
            if (MsgBox("是否清空回收站?", "", 1) = "ok")
                FileRecycleEmpty(), tipLB("FileRecycleEmpty")
        case "record": ahk("t", "record.ahk", ".\utils\record.ahk")
            ; case "colorhook": ahk("t", "colorhook.ahk", ".\utils\colorhook.ahk")
        case "colorhook": colorg.toggleshow() ;!!!!!
        case "touchpad": toggleTouchpad()
        case "bluetooth": Run("control.exe bthprops.cpl")
        case "highconstarct": highConstract()
            ; case "timer": timeh.toggleshow()
            ; case "sett": timeh.isshow() and timeh.setdeadline()
        case "click":
            if (arg = "") {
                click(A_ScreenWidth // 2 ", " A_ScreenHeight // 2)
            } else
                click(arg)
        case "runAs": run("*runAs " arg), tipLB("*runAs " arg)
        case "HrunAs": run("*runAs " arg, , "Hide"), tipLB("*HrunAs " arg)
        case "run": run(arg), tipLB("run " arg)
        case "Hrun": run(arg, , "Hide"), tipLB("Hrun " arg)
        case "runs":
            for s in StrSplit(arg, "|", ' ')
                run(s)
            tipLB("runs: `n" StrReplace(arg, "|", "`n"))
        case "env":
            run("sysdm.cpl"), WinWaitActive("系统属性")
            send("{ctrl Down}{Tab 2}{ctrl Up}!n")
        case "ahkmanager": ahkManager()
        case "ls": tipRB(ahk("ls"), 5000)
            ; case "reload": Reload
        case "reload": run("*runAs woz.ahk") ;管理员
        case "quit":
            if (MsgBox("quit?", , 1) = "ok")
                ExitApp
        default: return 0
    }
    return keep ;if keep == 1 ,dont exit
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
        ; ih := InputHook("T0.5")
        ; ih.Start()    ;唯一匹配即执行 所以拦截用户溢出的多余输入1秒
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
