#HotIf
class zvim {
    static mode := "i"
    static GN_x := [5, 30, 80]
    static GN_y := [5, 30, 80]
    static GN_showMode := "ms"
    static GN_default := [5, 5, 30, 30, 80, 80, "ms"]
    static GW_m := 50    ;刚好是任务栏高度

    static go(mode) {
        zvim.mode := mode
        switch zvim.mode {
            case "tmpi": nop() ; 同i 但不要取消tip
            case "g_n":
                removeAllSpy()
                winSpy_GN(), SetTimer(winSpy_GN, 250)
            case "g_w":
                removeAllSpy()
                winSpy_GW(), SetTimer(winSpy_GW, 250)
            case "e_n":
                removeAllSpy()
                tip.MB("-- Edit Normal --", "oo")
            case "e_v":
                removeAllSpy()
                tip.MB("-- Edit Visual --", "oo")
            case "e_i":
                removeAllSpy()
                tip.MB("-- Edit Insert --", "oo")
            case "e_o":
                removeAllSpy()
                tip.MB("-- Edit Oppend --", "oo")
            default:    ;insert
                removeAllSpy()
                ; ti.MB()
                tip.MB("-- Insert --", 1000)
        }
        removeAllSpy() {
            SetTimer(winSpy_GN, 0)
            SetTimer(winSpy_GW, 0)
        }
        winSpy_GW() {
            str := Format("-- Gui Window {} --", debugInfo("wcpos"))
            tip.MB(str, "oo")
        }
        winSpy_GN() {
            str := Format("-- Gui Normal {} --", debugInfo(zvim.GN_showMode, ' '))
            tip.MB(str, "oo")
        }
    }

    static GN_adjust(parm, dif) {
        switch parm {
            case 'x1': zvim.GN_x[1] += dif, tip.p(parm " " zvim.GN_x[1])
            case 'x2': zvim.GN_x[2] += dif, tip.p(parm " " zvim.GN_x[2])
            case 'x3': zvim.GN_x[3] += dif, tip.p(parm " " zvim.GN_x[3])
            case 'y1': zvim.GN_y[1] += dif, tip.p(parm " " zvim.GN_y[1])
            case 'y2': zvim.GN_y[2] += dif, tip.p(parm " " zvim.GN_y[2])
            case 'y3': zvim.GN_y[3] += dif, tip.p(parm " " zvim.GN_y[3])
            case 'xy1': zvim.GN_x[1] += dif, zvim.GN_y[1] += dif, tip.p(parm " " zvim.GN_x[1] " " zvim.GN_y[1])
            case 'xy2': zvim.GN_x[2] += dif, zvim.GN_y[2] += dif, tip.p(parm " " zvim.GN_x[2] " " zvim.GN_y[2])
            case 'xy3': zvim.GN_x[3] += dif, zvim.GN_y[3] += dif, tip.p(parm " " zvim.GN_x[3] " " zvim.GN_y[3])
            default:
        }
    }

    static GN_multiMoveFix() {
        if (GetKeyState('d', 'p')) {
            ; SendEvent("{d up}{d Down}")
        }
    }
    static GN_multiMove(keys) {
        x := 0, y := 0, i := 2
        i := GetKeyState('Shift', 'p') ? 3 : i
        i := GetKeyState('Alt', 'p') ? 1 : i
        switch keys {
            case 'sa': move(-zvim.GN_x[i], zvim.GN_y[i])
            case 'sd': move(zvim.GN_x[i], zvim.GN_y[i])
            case 'wa': move(-zvim.GN_x[i], -zvim.GN_y[i])
            case 'wd': move(zvim.GN_x[i], -zvim.GN_y[i])
        }
    }
    static GN_setting() {
        zvim.go("tmpi")
        prompt := "
            (
                支持命令:
                :set x 30 y 50 x1 5 x3 80
                :set mode ms c
                :go 100 200 [c/s/w]
                :reset
            )" . "`n" . zvim.GN_getSettings()

        IB := InputBox(prompt, "-- GUI Normal Setting --", "w400 h240") ;"w640 h480"
        if (IB.result = "Cancel") {
            zvim.go("g_n")
            return
        }
        res := Trim(IB.Value)
        try dealcmd(res)
        catch Error as e {
            logM(e)
        }
        zvim.go("g_n")
        dealcmd(cmd) {
            if (cmd == "")
                return
            if (cmd == "reset") {
                zvim.GN_reset()
                zvim.GN_showSettings()
                return
            }
            args := StrSplit(cmd, A_Space)
            ; go 100 200 [s/c/w]
            if (args[1] == "go") {
                x := args[2], y := args[3]
                rel := (args.Length == 4) ? args[4] : 's'
                clk.Rel(Format("{} {} 0", x, y), rel)
                return
            }
            if (args[1] == "set") {
                if (args[2] == 'mode')
                    GN_set(args[2], StrSplit(cmd, A_Space, , 3)[3])
                else {
                    args.RemoveAt(1)
                    loop args.Length // 2
                        GN_set(args[2 * A_Index - 1], args[2 * A_Index])
                    zvim.GN_showSettings()
                    return
                }
            }
        }
        GN_set(parm, value) {
            switch parm {
                case 'x': zvim.GN_x[2] := Integer(value)
                case 'y': zvim.GN_y[2] := Integer(value)
                case 'x1': zvim.GN_x[1] := Integer(value)
                case 'y1': zvim.GN_y[1] := Integer(value)
                case 'x3': zvim.GN_x[2] := Integer(value)
                case 'y2': zvim.GN_y[2] := Integer(value)
                case 'x3': zvim.GN_x[3] := Integer(value)
                case 'y3': zvim.GN_y[3] := Integer(value)
                case 'mode': zvim.GN_showMode := value
            }
            zvim.GN_showSettings()
        }
    }
    static GN_showSettings() {
        tip.LB(zvim.GN_getSettings())
    }
    static GN_getSettings() {
        return Format("
        (
            当前设置:
            x1, y1 : {}, {}
            x2, y2 : {}, {}
            x3, y3 : {}, {}
            showMode: {}
        )", zvim.GN_x[1], zvim.GN_y[1], zvim.GN_x[2], zvim.GN_y[2],
            zvim.GN_x[3], zvim.GN_y[3], zvim.GN_showMode)
    }

    static GN_reset() {
        zvim.GN_x[1] := zvim.GN_default[1]
        zvim.GN_y[1] := zvim.GN_default[2]
        zvim.GN_x[2] := zvim.GN_default[3]
        zvim.GN_y[2] := zvim.GN_default[4]
        zvim.GN_x[3] := zvim.GN_default[5]
        zvim.GN_y[3] := zvim.GN_default[6]
        zvim.GN_showMode := zvim.GN_default[7]
        zvim.GN_showSettings()
    }

    static GN_oppend(key) {
        zvim.go("tmpi")
        ih := InputHook("T3 L1")
        ih.Start()
        ih.Wait()
        res := ih.Input
        switch key . res, true {
            case "yy": copyandshow(debugInfo(zvim.GN_showMode, ' '))
            case " j": moveDMost()
            case " k": moveUMost()
            case " h": moveLMost()
            case " l": moveRMost()
            case " m": clk.center()
            case "gg": moveUMost()
            case "gh": moveLMost()
            case "gH": moveLMost()
            case "gl": moveRMost()
            case "gL": moveRMost()
            case "zz": clk.center()
            case "gm": clk.center()
        }
        zvim.go("g_n")
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
!j:: moveD(zvim.GN_x[1])
!k:: moveU(zvim.GN_x[1])
!h:: moveL(zvim.GN_y[1])
!l:: moveR(zvim.GN_y[1])
j:: moveD(zvim.GN_y[2])
k:: moveU(zvim.GN_y[2])
h:: moveL(zvim.GN_x[2])
l:: moveR(zvim.GN_x[2])
+j:: moveD(zvim.GN_y[3])
+k:: moveU(zvim.GN_y[3])
+h:: moveL(zvim.GN_y[3])
+l:: moveR(zvim.GN_y[3])
Numpad5:: copyandshow(debugInfo(zvim.GN_showMode))
Numpad8:: clk.k(A_Clipboard)
; ~s & a::
; ~w & a:: zvim.GN_multiMove('wa')
; ~a & w::
; ~a & s:: zvim.GN_multiMove('sa')
; ~s & d::
; ~d & s:: zvim.GN_multiMove('sd')
; ~w & d::
; ~d & w:: zvim.GN_multiMove('wd')
space:: zvim.GN_oppend(' ')
+g:: moveDMost()
g:: zvim.GN_oppend('g')
z:: zvim.GN_oppend('z')
<^<+c:: clk.center(0)
; -------------------- 设置调整
y:: zvim.GN_oppend('y')
-:: zvim.GN_adjust('xy2', -5)
=:: zvim.GN_adjust('xy2', 5)
_:: zvim.GN_adjust('xy3', -10)
+:: zvim.GN_adjust('xy3', 10)
<!-:: zvim.GN_adjust('xy1', -1)
<!=:: zvim.GN_adjust('xy1', 1)
<^0:: zvim.GN_reset()
; -------------------- 鼠标左右键
q::LButton
e::RButton
n:: click()
m:: click("r")
v:: togglekey("LButton")
+n:: send("{blink}+{click}")
^n:: send("{blink}^{click}")
+m:: send("{blink}+{RButton}")
^m:: send("{blink}^{RButton}")
; -------------------- 其他按键(滚轮,回车)
s:: wheelD()
w:: wheelU()
a:: wheelL()
d:: wheelR()
+a:: wheelL(3)
+d:: wheelR(3)
+w:: wheelD(3)
+s:: wheelU(3)
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
w:: winResizeD(-zvim.GW_m)
a:: winResizeL(-zvim.GW_m)
d:: winResizeL(zvim.GW_m)
; !s:: winResizeD(-zvim.GW_m)
; !w:: winResizeU(-zvim.GW_m)
; !a:: winResizeH(-zvim.GW_m)
; !d:: winResizeL(-zvim.GW_m)
+s:: winResizeDMost()
+d:: winResizeLMost()
; +w:: winResizeUMost()
; +a:: winResizeHMost()
+w:: WinMove(, , , 0, "A")
+a:: WinMove(, , 0, , "A")

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


#HotIf WinActive("ahk_group jkl2e_n") and zvim.mode == "i"
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