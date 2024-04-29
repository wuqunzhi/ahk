#HotIf WinActive(win_edge)
:*x?b0z:asdasd:: Edge.vim(-1)
#HotIf WinActive(win_edge) and Edge.vim()
a:: send("^+{Tab}")
d:: send("^{Tab}")
k:: wheelU()
j:: wheelD()
w:: wheelU()
s:: wheelD()
i:: Edge.vim(0)
#HotIf

class Edge extends VimController {

}