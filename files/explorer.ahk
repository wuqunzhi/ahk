#HotIf WinActive(win_explorer) and !inputfocus()
; :*x?b0zc:yy:: copyandshow(WinGetTitle("A"))
~y:: {
    stupid := A_TimeSincePriorHotkey = "" ? 501 : A_TimeSincePriorHotkey    ;V2的bug
    if (A_PriorKey = "y" and stupid < 500)
        copyandshow(WinGetTitle("A"))
}
~t:: {
    stupid := A_TimeSincePriorHotkey = "" ? 501 : A_TimeSincePriorHotkey    ;V2的bug
    if (A_PriorKey = "y" and stupid < 500)
        try Run("explorer.exe " WinGetTitle("A"))
        catch as e
            run("explorer.exe " A_userpath)
}
:*x?b0zc:  d:: run("explore d:")
:*x?b0zc:  e:: run("explore e:")
:*x?b0zc:  c:: run("explore c:")
:*x?b0zc:  o:: winO()
:*x?b0zc:  ~:: run("explore " A_userpath)
`;:: send("{enter}")


#HotIf WinActive(win_explorer)
<^n:: run("explorer.exe")
<^o::!left
<^i::!right
<^b::!Up
<!o::!Up
<!i::!left
<!h::!Up
<!l::!left
<!`:: runCmdInCurrentDir()
runCmdInCurrentDir() {
    try Run(A_ComSpec, WinGetTitle("A"))
    catch as e
        run(A_ComSpec, A_userpath)
}

#HotIf