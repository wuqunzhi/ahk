#HotIf WinActive(win_cloudmusic)
global wyy_h := 42
<^<+c:: vim_wyy(1)
<^<!l:: clickb("300 784")
^m:: sbclick("40 800"), sleep(200), sbclick("1111 400 0")
^i:: sbclick("40 800"), sleep(200), sbclick("1111 400 0")
^o:: clickb("54 43")
^f:: clickb("520 40"), vim_wyy(0)

#HotIf WinActive(win_cloudmusic) and vim_wyy()
i:: vim_wyy(0)
q:: vim_wyy(0)

c:: winReset(1277, 837)
h:: moveL(50)
l:: moveR(50)
~h & j::move(-50,50)
a:: moveL(50)
d:: moveR(50)
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