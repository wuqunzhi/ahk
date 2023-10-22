#HotIf WinActive(win_edge)
:*x?b0z:asdasd:: vim_edge(-1)
#HotIf WinActive(win_edge) and vim_edge()
a:: send("^+{Tab}")
d:: send("^{Tab}")
k:: wheelU()
j:: wheelD()
w:: wheelU()
s:: wheelD()
i:: vim_edge(0)
#HotIf

vim_edge(vim?) {
    static use := 0
    if (!isset(vim))
        return use
    use := (vim = -1) ? !use : vim
    return use

}