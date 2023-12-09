#HotIf WinActive(win_cloudmusic)
global wyy_h := 42
global wyy_w := 50
<^<+c:: vim_wyy(1)
<^<!l:: send("{blink}>^l")
^m:: clk.blink("40 800"), sleep(200), clk.blink("1111 400 0")
^i:: clk.blink("40 800"), sleep(200), clk.blink("1111 400 0")
^o:: clk.back("54 43")
^f:: clk.blink("520 40"), clk.blink("666 40 0") vim_wyy(0)


#HotIf WinActive(win_cloudmusic) and vim_wyy()
i:: vim_wyy(0)
q:: vim_wyy(0)
f:: clk.cycle(["185 785", "104 297", "454 717"])
+f:: clk.cycle(["185 785", "104 297", "454 717"], , rev := 1)
r:: clk.back('512 785')
n:: click()
c:: winReset(1277, 837)
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

vim_wyy(vim?) {
    static use := 1
    if (!isset(vim))
        return use
    use := (vim == -1) ? !use : vim
    return use
}
#HotIf