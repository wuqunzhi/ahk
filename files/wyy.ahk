#HotIf WinActive(win_cloudmusic)
#c:: winReset(1277, 837)
global wyy_h := 42
global wyy_w := 50
<^<+c:: wyy.vim(1)
<^<!<l::>^l
<!h::^!,
<!l::^!.
; <^<!l:: send("{blink}>^l")
^m:: clk.blink("40 800"), sleep(200), clk.blink("1111 400 0")
^i:: clk.blink("40 800"), sleep(200), clk.blink("1111 400 0")
^o:: clk.back("54 43")
^f:: clk.blink("520 40"), clk.blink("666 40 0") wyy.vim(0)


#HotIf WinActive(win_cloudmusic) and wyy.vim()
c:: wyy.kuaijin(17)
z:: wyy.kuaijin(-15)
+c:: wyy.kuaijin(35)
+z:: wyy.kuaijin(-30)
i:: wyy.vim(0)
q:: wyy.vim(0)
f:: clk.cycle(["185 785", "104 297", "454 717"])
+f:: clk.cycle(["185 785", "104 297", "454 717"], , rev := 1)
r:: clk.back('512 785')
n:: click()
h:: moveL(wyy_w)
l:: moveR(wyy_w)
+h:: moveL(wyy_w * 4)
+l:: moveR(wyy_w * 4)
a:: moveL(wyy_w)
d:: moveR(wyy_w)
j:: moveD(wyy_h)
k:: moveU(wyy_h)
+j:: moveD(wyy_h * 4)
+k:: moveU(wyy_h * 4)
s:: wheelD()
w:: wheelU()
+s:: wheelD(3)
+w:: wheelU(3)

class wyy extends VimControl {
    static kuaijin(dif) {
        clk.img(A_ScriptDir '/img/wyy_bar1.bmp', 0, 800, wincw(), 830, 50, dif, 3, 1, 1) ||
            clk.img(A_ScriptDir '/img/wyy_bar2.bmp', 0, 800, wincw(), 830, 50, dif, 8, 1, 1)
    }
}
#HotIf