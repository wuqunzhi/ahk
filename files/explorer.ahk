#HotIf WinActive(win_explorer) and !inputfoucs()
; :*x?b0zc:yy:: copyandshow(WinGetTitle("A"))
~y:: {
    stupid := A_TimeSincePriorHotkey = "" ? 501 : A_TimeSincePriorHotkey    ;V2的bug
    if (A_PriorKey = "y" and stupid < 500)
        copyandshow(WinGetTitle("A"))
}
:*x?b0zc:  d:: run("explore d:")
:*x?b0zc:  e:: run("explore e:")
:*x?b0zc:  c:: run("explore c:")
:*x?b0zc:  ~:: run("explore " A_userpath)
`;:: send("{enter}")

#HotIf WinActive(win_explorer)
<^n:: run("explorer.exe")
<^o::!left
<^i::!right
<!o::!Up
<!`:: runCmdInCurrentDir()
runCmdInCurrentDir() {
    try Run("cmd", WinGetTitle("A"))
    catch as e
        run("cmd", get_A_userPath())
}

#HotIf