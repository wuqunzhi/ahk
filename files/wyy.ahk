#HotIf WinActive(win_cloudmusic)
global wyy_h := 42
global wyy_w := 50
<^<+c:: vim_wyy(1)
<^<!l:: clickb("300 784")
^m:: sbclick("40 800"), sleep(200), sbclick("1111 400 0")
^i:: sbclick("40 800"), sleep(200), sbclick("1111 400 0")
^o:: clickb("54 43")
^f:: sbclick("520 40"),sbclick("666 40 0") vim_wyy(0)


#HotIf WinActive(win_cloudmusic) and vim_wyy()
i:: vim_wyy(0)
q:: vim_wyy(0)
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