; #SingleInstance Force
; SetMouseDelay(-1)
#HotIf
class zvim {
    static mode := "i"
    static GN_x := 5
    static GN_y := 5
    static GN_xx := 30 ;20
    static GN_yy := 30 ;20
    static GN_xxx := 50
    static GN_yyy := 50
    static GN_showMode := "ms"
    static GW_m := 50    ;刚好是任务栏高度

    static go(mode) {
        zvim.mode := mode
        switch zvim.mode {
            case "g_n":
                tip("-- GUI Normal --", "oo", 0.45, 1, 16)
                removeAllSpy()
                SetTimer(winSpyGN, 250)
            case "g_w":
                tip("-- GUI Window --", "oo", 0.45, 1, 16)
                removeAllSpy()
                SetTimer(winSpyGW, 250)
            case "e_n":
                removeAllSpy()
                tip("-- Edit Normal --", "oo", 0.45, 1, 16)
            case "e_v":
                removeAllSpy()
                tip("-- Edit Visual --", "oo", 0.45, 1, 16)
            case "e_i":
                removeAllSpy()
                tip("-- Edit Insert --", "oo", 0.45, 1, 16)
            case "e_o":
                removeAllSpy()
                tip("-- Edit Oppend --", "oo", 0.45, 1, 16)
            case "tmpi": nop() ; 同i 但不要取消tip
            default:    ;insert
                removeAllSpy()
                tip(, , , , 16)
                tip("-- Insert --", 1000, 0.45, 1)
        }
        removeAllSpy() {
            SetTimer(winSpyGN, 0)
            SetTimer(winSpyGW, 0)
        }
        winSpyGW() {
            str := Format("-- Gui Window {} --", debugInfo("wcpos"))
            tip(str, "oo", 0.45, 1, 16)
        }
        winSpyGN() {
            str := Format("-- Gui Normal {} --", debugInfo(zvim.GN_showMode, ' '))
            tip(str, "oo", 0.45, 1, 16)
        }
    }

    static GN_setting() {
        zvim.go("tmpi")
        try {
            prompt := "
            (
                支持命令:
                :set x 30 y 50 mode mc,ms
                :go [c/s/w] 100 200
                :reset
            )" . "`n" . GN_getsettings()

            IB := InputBox(prompt, "-- GUI Normal Setting --", "w400 h240") ;"w640 h480"
            if (IB.result = "Cancel")
                return
            res := Trim(IB.Value)
            dealcmd(res)
            dealcmd(cmd) {
                if (cmd == "")
                    return
                if (cmd == "reset") {
                    GN_reset()
                    GN_showSettings()
                    return
                }
                args := StrSplit(cmd, A_Space)
                for a in args {
                    MsgBox(a)
                }
                ; go [c/s/w] 100 200
                if (args[1] == "go") {
                    x := args[2]
                    y := args[3]
                    if (args.Length == 4) {
                        x := args[3]
                        y := args[4]
                        switch args[2] {
                            case "s": clickRelToScreen(Format("{} {} 0", x, y))
                            case "w": clickRelToWindow(Format("{} {} 0", x, y))
                            case "c": clickRelToClient(Format("{} {} 0", x, y))
                        }
                        x := args[3]
                        y := args[4]
                    }
                    else {
                        clickRelToClient(Format("{} {} 0", x, y))
                    }
                    CoordMode "mouse", "Client"
                    return
                }
                ; mode mc,ms
                if (args[1] == "mode") {
                    zvim.GN_showMode := args[2]
                    GN_showSettings()
                    return
                }
                if (args[1] == "set") {
                    args.RemoveAt(1)
                    loop args.Length // 2 {
                        GN_set(args[2 * A_Index - 1], args[2 * A_Index])
                    }
                    GN_showSettings()
                    return
                }
            }
        } catch Error as e {
            logM(e)
        }
        zvim.go("g_n")
        GN_set(parm, value) {
            switch parm {
                case 'x': zvim.GN_x := Integer(value)
                case 'y': zvim.GN_y := Integer(value)
                case 'xx': zvim.GN_xx := Integer(value)
                case 'yy': zvim.GN_yy := Integer(value)
                case 'xxx': zvim.GN_xxx := Integer(value)
                case 'yyy': zvim.GN_yyy := Integer(value)
                case 'mode': zvim.GN_showMode := value
            }
            GN_showSettings()
        }
        GN_reset() {
            zvim.GN_x := 5
            zvim.GN_y := 5
            zvim.GN_xx := 30
            zvim.GN_yy := 30
            zvim.GN_xxx := 50
            zvim.GN_yyy := 50
            zvim.GN_showMode := "ms"
            GN_showSettings()
        }
        GN_showSettings() {
            tipLB(GN_getsettings())
        }
        GN_getsettings() {
            return Format("
            (
                当前设置:
                x  ,y  : {},{}
                xx ,yy : {},{}
                xxx,yyy: {},{}
                mode: {}
            )", zvim.GN_x, zvim.GN_y, zvim.GN_xx, zvim.GN_yy,
                zvim.GN_xxx, zvim.GN_yyy, zvim.GN_showMode)
        }
    }

    static EN_oppend(key) {
        zvim.go("e_o")
        ih := InputHook("T3 L1")
        ih.Start()
        ih.Wait()
        res := ih.Input
        switch key . res {
            case "vgg": send("+^{home}"), zvim.go("e_v")
            case "gg": send("^{home}"), zvim.go("e_n")
            case "yw": send("^{left}+^{right}^c"), showcopy(), zvim.go("e_n")
            case "yy": send("{home}+{end}^c"), showcopy(), zvim.go("e_n")
            case "yj": send("{home}+{down}+{end}+{right}^c"), showcopy(), zvim.go("e_n")
            case "yk": send("{end}+{up}+{home}+{left}^c"), showcopy(), zvim.go("e_n")
            case "yH": send("+{home}^c"), showcopy(), zvim.go("e_n")
            case "yL": send("+{end}^c"), showcopy(), zvim.go("e_n")
            case "dw": send("^{left}+^{right}{bs}"), zvim.go("e_n")
            case "dd": send("{home}+{end}{bs}"), zvim.go("e_n")
            case "dj": send("{home}+{down}+{end}+{right}{bs}"), zvim.go("e_n")
            case "dk": send("{end}+{up}+{home}+{left}{bs}"), showcopy(), zvim.go("e_n")
            case "dH": send("+{home}{bs}"), zvim.go("e_n")
            case "dL": send("+{end}{bs}"), zvim.go("e_n")
            case "cw": send("^{left}+^{right}{bs}"), zvim.go("e_i")
            case "cc": send("{home}+{end}{bs}"), zvim.go("e_i")
            case "cj": send("{home}+{down}+{end}+{right}{bs}"), zvim.go("e_i")
            case "ck": send("{end}+{up}+{home}+{left}{bs}"), showcopy(), zvim.go("e_i")
            case "cH": send("+{home}{bs}"), zvim.go("e_i")
            case "cL": send("+{end}{bs}"), zvim.go("e_i")
            default: zvim.go("e_n")
        }

    }
}

; -------------------- GUI Normal --------------------
#HotIf zvim.mode = "g_n"
; -------------------- 移动鼠标
j:: moveD(zvim.GN_yy)
k:: moveU(zvim.GN_yy)
h:: moveL(zvim.GN_xx)
l:: moveR(zvim.GN_xx)
+j:: moveD(zvim.GN_yyy)
+k:: moveU(zvim.GN_yyy)
+h:: moveL(zvim.GN_yyy)
+l:: moveR(zvim.GN_yyy)
!j:: moveD(zvim.GN_x)
!k:: moveU(zvim.GN_x)
!h:: moveL(zvim.GN_y)
!l:: moveR(zvim.GN_y)
; -------------------- 鼠标键盘按键
q::LButton
e::RButton
n:: click()
+n:: send("{blink}+{click}")
^n:: send("{blink}^{click}")
m:: click("r")
+m:: send("{blink}+{RButton}")
^m:: send("{blink}^{RButton}")
w:: wheelU()
s:: wheelD()
+w:: wheelU(3)
+s:: wheelD(3)
v:: togglekey("LButton")
o:: send("{enter}")
; -------------------- 模式切换
t:: zvim.go("g_w")
i:: zvim.go("i")
; -------------------- 参数设置
::: zvim.GN_setting()

; -------------------- GUI Window --------------------
#HotIf zvim.mode = "g_w"
; -------------------- 窗口位置
j:: winMoveD(zvim.GW_m)
k:: winMoveU(zvim.GW_m)
h:: winMoveL(zvim.GW_m)
l:: winMoveR(zvim.GW_m)
+j:: winMoveDMost()
+k:: winMoveUMost()
+h:: winMoveLMost()
+l:: winMoveRMost()
; -------------------- 窗口大小
s:: winResizeD(zvim.GW_m)
w:: winResizeU(zvim.GW_m)
a:: winResizeH(zvim.GW_m)
d:: winResizeL(zvim.GW_m)
!s:: winResizeD(-zvim.GW_m)
!w:: winResizeU(-zvim.GW_m)
!a:: winResizeH(-zvim.GW_m)
!d:: winResizeL(-zvim.GW_m)
+s:: winResizeDMost()
+w:: winResizeUMost()
+a:: winResizeHMost()
+d:: winResizeLMost()
; -------------------- 窗口模式调整
m:: WinToggleMaximize()
n:: winReset(0, 0)
c:: winCenter()
r:: WinRestore("A")
; -------------------- 模式切换
t:: zvim.go("g_n")
i:: zvim.go("i")
#HotIf


; -------------------- Edit Normal --------------------
#HotIf zvim.mode = "e_n"
; -------------------- 移动
h:: send("{left}")
j:: send("{down}")
k:: send("{up}")
l:: send("{right}")
w:: send("^{right}")
b:: send("^{left}")
+h:: send("{Blind}{home}"), KeyWait("shift"), Send("{left}")
+l:: send("{Blind}{end}"), KeyWait("shift"), Send("{right}")
0:: send("{Blind}{home}")
$:: send("{Blind}{end}")
g:: zvim.EN_oppend("g")
+g:: send("^{end}")
^d:: send("{Blind}{down 10}")
^u:: send("{Blind}{up 10}")
; -------------------- 操作
x:: send("{bs}")
+d:: send("+{end}{bs}")
+c:: send("+{end}{bs}"), zvim.go("e_i")
u:: send("^z")
p:: send("^v")
; -------------------- oppend
y:: zvim.EN_oppend("y")
d:: zvim.EN_oppend("d")
c:: zvim.EN_oppend("c")
; -------------------- 模式切换
i:: zvim.go("e_i")
a:: zvim.go("e_i")
o:: send("{end}{enter}"), zvim.go("e_i")
v:: zvim.go("e_v")

; -------------------- Edit Insert --------------------
#HotIf zvim.mode = "e_i"
~j:: {
    if KeyWait("k", "D T0.5") {
        send("{bs 2}")
        zvim.go("e_n")
    }
}
esc:: zvim.go("e_n")

; -------------------- Edit Visual --------------------
#HotIf zvim.mode = "e_v"
; -------------------- 移动
j:: send("+{down}")
k:: send("+{up}")
h:: send("+{left}")
l:: send("+{right}")
+h:: send("+{home}")
+l:: send("+{end}")
0:: send("+{home}")
$:: send("+{end}")
w:: send("+^{right}")
b:: send("+^{left}")
g:: zvim.EN_oppend("vg")
+g:: send("+^{end}")

; -------------------- 操作和切换
~esc:: zvim.go("e_n")
c:: send("{bs}"), zvim.go("e_i")
d:: send("{bs}"), zvim.go("e_n")
y:: send("^c"), showcopy(), zvim.go("e_n")
p:: send("^v"), zvim.go("e_n")
v:: send("{down}{up}"), zvim.go("e_n")

; -------------------- Edit Oppend --------------------
#HotIf zvim.mode = "e_o"
~esc:: zvim.go("e_n")


; -------------------- jkl enter Edit_normal --------------------
; #SuspendExempt
; >^[:: Suspend(), tip(A_IsSuspended ? "suspend" : "active", , 0, 1, 16)
; #SuspendExempt False
GroupAdd("jkl2e_n", "ahk_exe chrome.exe")

#HotIf WinActive("ahk_group jkl2e_n") and zvim.mode = "i"
;jkl to enter Edit_Normal
~j:: {
    if KeyWait("k", "D T0.5") {
        if KeyWait("l", "D T0.5") {
            send("{bs 3}")
            zvim.go("e_n")
        }
    }
}
#HotIf