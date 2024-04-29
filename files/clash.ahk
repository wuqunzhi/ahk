#HotIf WinActive(win_clash)
<^<+c:: Clash.vim(1)
#HotIf WinActive(win_clash) and Clash.vim()
i:: Clash.vim(0)
q:: Clash.vim(0)
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
class Clash extends VimController {
}