; #SingleInstance Force
; SetMouseDelay(-1)
#HotIf
global gui_y := 5
global gui_yy := 30 ;20
global gui_yyy := 50
global gui_x := 5
global gui_xx := 30 ;20
global gui_xxx := 50
global gui_m := 50    ;刚好是任务栏高度
global zvim_mode := "i"

zvim(mode := "") {
    if (!mode)
        return zvim_mode
    global zvim_mode := mode
    switch zvim_mode {
        case "g_n":
            tip("-- GUI Normal --", "oo", 0.45, 1, 16)
        case "g_w":
            tip("-- GUI Window --", "oo", 0.45, 1, 16)
            SetTimer(winSpy, 250)
        case "e_n":
            tip("-- Edit Normal --", "oo", 0.45, 1, 16)
        case "e_v":
            tip("-- Edit Visual --", "oo", 0.45, 1, 16)
        case "e_i":
            tip("-- Edit Insert --", "oo", 0.45, 1, 16)
        case "e_o":
            tip("-- Edit Oppend --", "oo", 0.45, 1, 16)
        default:    ;insert
            SetTimer(winSpy, 0)
            tip(, , , , 16)
            tip("-- Insert --", 1000, 0.45, 1)
    }
    winSpy() {
        str := Format("-- Gui Move {} --", debugInfo("wcpos"))
        tip(str, "oo", 0.45, 1, 16)
    }
}

#HotIf zvim_mode = "g_n"
q::LButton
e::RButton
t:: zvim("g_w")
c:: Click(0.5 * winw() . " " . 0.5 * winh() " 0")
w:: send("{WheelUp}")
s:: send("{wheelDown}")
i:: zvim("i")
v:: togglekey("LButton")
n:: click()
+n:: send("{blink}+{click}")
^n:: send("{blink}^{click}")
m:: click("r")
+m:: send("{blink}+{RButton}")
^m:: send("{blink}^{RButton}")
o:: send("{enter}")
j:: click("0," gui_yy ",0,Rel")
k:: click("0," . -gui_yy ",0,Rel")
h:: click(-gui_xx ",0,0,Rel")
l:: click(gui_xx ",0,0,Rel")
+j:: click("0," gui_yyy ",0,Rel")
+k:: click("0," . -gui_yyy ",0,Rel")
+h:: click(-gui_yyy ",0,0,Rel")
+l:: click(gui_yyy ",0,0,Rel")
!j:: click("0," gui_y ",0,Rel")
!k:: click("0," . -gui_y ",0,Rel")
!h:: click(-gui_x ",0,0,Rel")
!l:: click(gui_x ",0,0,Rel")
::: guiset()
guiset() {
    zvim("i")
    curArg := Format("j {} {} {}`nh {} {} {}`nm {}", gui_yy, gui_yyy, gui_y, gui_xx, gui_xxx, gui_x, gui_m)
    IB := InputBox(curArg, , "W100 H130")
    if (IB.result = "Cancel")
        return
    res := Trim(IB.Value)
    setarg(StrSplit(res, '|'))
    setarg(cmds) {
        for cmd in cmds {
            opd_opr := StrSplit(Trim(cmd), ' ', , 2)
            opd := opd_opr[1]    ; j
            opr := opd_opr.Length > 1 ? opd_opr[2] : ""    ;20,50,5
            switch opd {
                case 'reset':
                    gui_reset()
                case 'j', 'y':
                    steps := StrSplit(opr, [',', ' '])
                    global gui_yy := (steps.Length >= 1 and IsInteger(steps[1])) ? Integer(steps[1]) : gui_yy
                    global gui_yyy := (steps.Length >= 2 and IsInteger(steps[2])) ? Integer(steps[2]) : gui_yyy
                    global gui_y := (steps.Length >= 3 and IsInteger(steps[3])) ? Integer(steps[3]) : gui_y
                    tipLB("new j:" gui_yy "," gui_yyy "," gui_y)
                case 'h', 'x':
                    steps := StrSplit(opr, [',', ' '])
                    global gui_xx := (steps.Length >= 1 and IsInteger(steps[1])) ? Integer(steps[1]) : gui_xx
                    global gui_xxx := (steps.Length >= 2 and IsInteger(steps[2])) ? Integer(steps[2]) : gui_xxx
                    global gui_x := (steps.Length >= 3 and IsInteger(steps[3])) ? Integer(steps[3]) : gui_x
                    tipLB("new h:" gui_xx "," gui_xxx "," gui_x)
            }
        }
    }
    gui_reset() {
        global gui_y := 5
        global gui_yy := 20
        global gui_yyy := 50
        global gui_x := 5
        global gui_xx := 20
        global gui_xxx := 50
        global gui_m := 50
    }
    zvim("g_n")
}

global x1 := 0, y1 := 0, x2 := 0, y2 := 0
` & 1:: measure1()
` & 2:: measure2()
measure1() {
    global x1 := mx()
    global y1 := my()
    tip(Format("mark {} {}", x1, y1), 2000, 1, 1)
}
measure2() {
    global x2 := mx()
    global y2 := my()
    copyandshow(Format("{} {}", x2 - x1, y2 - y1))
}
#HotIf


#HotIf zvim_mode = "g_w"
t:: zvim("g_n")
i:: zvim("i")
c:: winCenter()
m:: WinToggleMaximize()
n:: winReset(0, 0)
k:: winMoved(, -gui_m)
j:: winMoved(, gui_m)
h:: winMoved(-gui_m)
l:: winMoved(gui_m)
s:: winMoved(, , , gui_m)
w:: winMoved(, , , -gui_m)
a:: winMoved(, , -gui_m)
d:: winMoved(, , gui_m)
+k:: WinMove(, 0, , , "A")
+j:: WinMove(, A_ScreenHeight - winh(), , , "A")
+h:: WinMove(0, , , , "A")
+l:: WinMove(A_ScreenWidth - winw(), , , , "A")
+s:: WinMove(, , , A_ScreenHeight - winy(), "A")
+w:: WinMove(, , , 0, "A")
+a:: WinMove(, , 0, , "A")
+d:: WinMove(, , A_ScreenWidth - winx(), , "A")
;!!!
t_wyylyric := "ahk_exe cloudmusic.exe ahk_class DesktopLyrics"
t_qmlyric := "桌面歌词 ahk_exe QQMusic.exe ahk_class TXGuiFoundation"
GroupAdd("lyric", t_qmlyric)
GroupAdd("lyric", t_wyylyric)
f:: WinActivateBottom("ahk_group lyric") ;显示隐藏窗口
#HotIf

; -------------------------------------------- zvim
; #SuspendExempt
; >^[:: Suspend(), tip(A_IsSuspended ? "suspend" : "active", , 0, 1, 16)
; #SuspendExempt False
; GroupAdd("nozvim", "ahk_exe Code.exe")
; GroupAdd("nozvim", "ahk_class CabinetWClass")
; GroupAdd("nozvim", "woz.ahk ahk_exe AutoHotkey64.exe")
GroupAdd("jkl2e_n", "ahk_exe chrome.exe")

#HotIf WinActive("ahk_group jkl2e_n") and zvim_mode = "i"
;jkl to enter edit_normal
~j:: {
    if KeyWait("k", "D T0.5") {
        if KeyWait("l", "D T0.5") {
            send("{bs 3}")
            zvim("e_n")
        }
    }
}

/* watchIfAchange() {
    global preA, mode
    curA := WinExist("A")
    if (preA != curA) {
        zvim("i")
        if (WinActive("ahk_group nozoevim")) {
            tip("-- ------ --", , 0, 1, 16)
        } else
            tip("-- " mode " --", "oo", 0, 1, 16)
    }
    preA := curA
} */


#HotIf zvim_mode = "e_v" or zvim_mode = "e_o"
~esc:: zvim("e_n")
i:: zvim("e_i")

#HotIf zvim_mode = "e_n"
h:: send("{left}")
j:: send("{down}")
k:: send("{up}")
l:: send("{right}")
w:: send("^{right}")
b:: send("^{left}")
+d:: send("+{end}{bs}")
+c:: send("+{end}{bs}"), zvim("e_i")
u:: send("^z")
p:: send("^v")
^d:: send("{Blind}{down 10}")
^u:: send("{Blind}{up 10}")
x:: send("{bs}")
; +h:: send("{Blind}{home}{right}{left}")
; +l:: send("{Blind}{end}{left}{right}{up}{down}")
+h:: send("{Blind}{home}"), KeyWait("shift"), Send("{left}")
+l:: send("{Blind}{end}"), KeyWait("shift"), Send("{right}")
0:: send("{Blind}{home}")
$:: send("{Blind}{end}")
y:: oppend("y")
d:: oppend("d")
c:: oppend("c")
+g:: send("^{end}")
:*cx?:gg:: send("^{home}")
v:: zvim("e_v")
o:: send("{end}{enter}"), zvim("e_i")
i:: zvim("e_i")
a:: zvim("e_i")

#HotIf zvim_mode = "e_i"
~j:: {
    if KeyWait("k", "D T0.5") {
        send("{bs 2}")
        zvim("e_n")
    }
}

#HotIf zvim_mode = "e_v"
d:: send("{bs}"), zvim("e_n")
y:: send("^c"), showcopy(), zvim("e_n")
p:: send("^v"), zvim("e_n")
v:: send("{down}{up}"), zvim("e_n")
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

oppend(key) {
    zvim("e_o")
    ih := InputHook("T3 L1")
    ih.Start()
    ih.Wait()
    res := ih.Input
    switch key . res {
        case "yw": send("^{left}+^{right}^c"), showcopy(), zvim("e_n")
        case "yy": send("{home}+{end}^c"), showcopy(), zvim("e_n")
        case "yj": send("{home}+{down}+{end}+{right}^c"), showcopy(), zvim("e_n")
        case "yk": send("{end}+{up}+{home}+{left}^c"), showcopy(), zvim("e_n")
        case "yH": send("+{home}^c"), showcopy(), zvim("e_n")
        case "yL": send("+{end}^c"), showcopy(), zvim("e_n")
        case "dw": send("^{left}+^{right}{bs}"), zvim("e_n")
        case "dd": send("{home}+{end}{bs}"), zvim("e_n")
        case "dj": send("{home}+{down}+{end}+{right}{bs}"), zvim("e_n")
        case "dk": send("{end}+{up}+{home}+{left}{bs}"), showcopy(), zvim("e_n")
        case "dH": send("+{home}{bs}"), zvim("e_n")
        case "dL": send("+{end}{bs}"), zvim("e_n")
        case "cw": send("^{left}+^{right}{bs}"), zvim("e_i")
        case "cc": send("{home}+{end}{bs}"), zvim("e_i")
        case "cj": send("{home}+{down}+{end}+{right}{bs}"), zvim("e_i")
        case "ck": send("{end}+{up}+{home}+{left}{bs}"), showcopy(), zvim("e_i")
        case "cH": send("+{home}{bs}"), zvim("e_i")
        case "cL": send("+{end}{bs}"), zvim("e_i")
        default: zvim("e_n")
    }
}
#HotIf