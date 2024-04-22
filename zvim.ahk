#HotIf
class zvim {
    static mode := "i"
    static GN_val := Map('x1', 5, 'y1', 5, 'x2', 30, 'y2', 30, 'x3', 80, 'y3', 80, 'showmode', 'ms')
    static GN_valDefault := zvim.GN_val
    ; Map('x1', 5, 'y1', 5, 'x2', 30, 'y2', 30, 'x3', 80, 'y3', 80, 'showmode', 'ms')
    static GN_x := [5, 30, 80]    ;鼠标移动步伐，份3档
    static GN_y := [5, 30, 80]    ;鼠标移动步伐，份3档
    static GN_showMode := "ms"
    ; static GN_default := [5, 5, 30, 30, 80, 80, "ms"]
    static GN_mouse_portal := [0, 0] ;鼠标sl记录

    static GW_step := 50    ;窗口移动步伐，50刚好是任务栏高度
    static GW_v_m := 1      ;dwm 列数
    static GW_v_n := 1      ;dwm 行数

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
            str := Format("-- Gui Normal {} --", debugInfo(zvim.GN_val['showmode'], ' '))
            tip.MB(str, "oo")
        }
    }

    static GN_adjust(key, dif) {
        switch key {
            case 'x1', 'x2', 'x3', 'y1', 'y2', 'y3':
                zvim.GN_val[key] += dif, tip.p(key " : " zvim.GN_val)
            case 'xy1':
                zvim.GN_val['x1'] += dif, zvim.GN_val['y1'] += dif
                tip.p("x1 y1 : " zvim.GN_val['x1'] " " zvim.GN_val['y1'])
            case 'xy2':
                zvim.GN_val['x2'] += dif, zvim.GN_val['y2'] += dif
                tip.p("x2 y2 : " zvim.GN_val['x2'] " " zvim.GN_val['y2'])
            case 'xy3':
                zvim.GN_val['x3'] += dif, zvim.GN_val['y3'] += dif
                tip.p("x3 y3 : " zvim.GN_val['x3'] " " zvim.GN_val['y3'])
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
        SettingsGUI.run(this.GN_val, this.GN_valDefault, 'GUI_Normal Setting')
        zvim.go("g_n")
    }

    static GN_mouse_save() {
        zvim.GN_mouse_portal := mouses()
    }
    static GN_mouse_load() {
        ; 鼠标位置y, 相对rel:c,s,w
        x := zvim.GN_mouse_portal[1]
        y := zvim.GN_mouse_portal[2]
        clk.s(x " " y " 0")
    }

    static GN_oppend(key) {
        zvim.go("tmpi")
        ih := InputHook("T3 L1")
        ih.Start()
        ih.Wait()
        res := ih.Input
        switch key . res, true {
            case "yy": copyandshow(debugInfo(zvim.GN_val['showmode'], ' '))
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
    static GW_oppend(key) {
        zvim.go("tmpi")
        ih := InputHook("T3 L1")
        ih.Start()
        ih.Wait()
        res := ih.Input
        switch key . res, true {
            case "v2": DWM.setMN(2, 1).fill(recentWins(2))
            case "vv": DWM.setMN(2, 1).fill(recentWins(2))
            case "vV": DWM.setMN(1, 2).fill(recentWins(2))
            case "vo": DWM.setMN(0).fill(getWinO("A"))
            case "vt": DWM.transpose().reload()
            case "v4": DWM.setMN(2, 2)
        }
        zvim.go("g_w")
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
!j:: moveD(zvim.GN_val['x1'])
!k:: moveU(zvim.GN_val['x1'])
!h:: moveL(zvim.GN_val['y1'])
!l:: moveR(zvim.GN_val['y1'])
j:: moveD(zvim.GN_val['y2'])
k:: moveU(zvim.GN_val['y2'])
h:: moveL(zvim.GN_val['x2'])
l:: moveR(zvim.GN_val['x2'])
+j:: moveD(zvim.GN_val['y3'])
+k:: moveU(zvim.GN_val['y3'])
+h:: moveL(zvim.GN_val['y3'])
+l:: moveR(zvim.GN_val['y3'])
Numpad5:: zvim.GN_mouse_save()
Numpad8:: zvim.GN_mouse_load()
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
; 5:: DWM.winMoveXYth()
j:: winMoveD(zvim.GW_step)
k:: winMoveU(zvim.GW_step)
h:: winMoveL(zvim.GW_step)
l:: winMoveR(zvim.GW_step)
+j:: winMoveDMost()
+k:: winMoveUMost()
+h:: winMoveLMost()
+l:: winMoveRMost()
; -------------------- 窗口大小
s:: winResizeD(zvim.GW_step)
w:: winResizeD(-zvim.GW_step)
a:: winResizeL(-zvim.GW_step)
d:: winResizeL(zvim.GW_step)
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
; -------------------- dwm
v:: zvim.GW_oppend('v')
#HotIf zvim.mode = "g_w" and zvim.GW_v_m * zvim.GW_v_n != 1
; Left:: winSplitMove(zvim.GW_v_m, zvim.GW_v_n,)

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
+o:: send("{home}{enter}{up}"), zvim.go("e_i")
+c:: send("+{end}{bs}"), zvim.go("e_i")
+i:: send("{Blind}{home}"), KeyWait("shift"), Send("{left}"), zvim.go("e_i")
+a:: send("{Blind}{end}"), KeyWait("shift"), Send("{right}"), zvim.go("e_i")
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
GroupAdd("jkl2e_n", win_chrome)
GroupAdd("jkl2e_n", win_notepad)


#HotIf WinActive("ahk_group jkl2e_n") and zvim.mode == "i"
;jkl to enter Edit_Normal
~j:: {
    if (KeyWait("k", "T0.5"))
        if KeyWait("k", "D T0.5")
            if KeyWait("l", "T0.5")
                if KeyWait("l", "D T0.5") {
                    send("{bs 3}")
                    zvim.go("e_n")
                }
}
#HotIf