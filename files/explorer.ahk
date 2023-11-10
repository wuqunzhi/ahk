#HotIf WinActive(win_explorer) and !inputfoucs()
; :*x?b0zc:yy:: copyandshow(WinGetTitle("A"))
~y:: {
    stupid := A_TimeSincePriorHotkey = "" ? 501 : A_TimeSincePriorHotkey    ;V2的bug
    if (A_PriorKey = "y" and stupid < 500)
        tip("45364") ;, tip("中")    ; , setCusor(1)
}
:*x?b0zc:  d:: run("explore d:")
:*x?b0zc:  e:: run("explore e:")
:*x?b0zc:  c:: run("explore c:")
`;:: send("{enter}")

#HotIf WinActive(win_explorer)
<^n:: run("explorer.exe")
<^o::!left
<^i::!right
<!`:: runCmdInCurrentDir()
runCmdInCurrentDir() {
    try Run("cmd", WinGetTitle("A"))
    catch as e
        run("cmd", A_userPath())
}

#HotIf