#HotIf WinActive(win_explorer) and !inputfoucs()
:*x?b0zc:yy:: copyandshow(WinGetTitle("A"))
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