#HotIf WinActive(win_clash)
<^<+c:: vim_clash(1)

#HotIf WinActive(win_clash) and vim_clash()
i:: vim_clash(0)
q:: vim_clash(0)
n:: click()
f:: clk.back("968,174"), clk.blink("525 250 0")
s:: wheelD()
w:: wheelU()
j:: moveD(80)
k:: moveU(80)
h:: moveL(400)
a:: moveL(400)
l:: moveR(400)
d:: moveR(400)
#HotIf

vim_clash(vim?) {
    static use := 1
    if (!isset(vim))
        return use
    use := (vim = -1) ? !use : vim
    return use
}