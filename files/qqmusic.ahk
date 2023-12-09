#HotIf WinActive(win_qqmusic)
<^<+c:: vim_qm(1)
<^<!l:: clk.back("391 837")
^m:: clk.blink("335 822"), sleep(200), clk.blink("1200 460 0")
^i:: clk.blink("335 822"), sleep(200), clk.blink("1200 460 0")
^o:: clk.back("45 47")
^f:: clk.back("500 50"), vim_qm(0)

#HotIf WinActive(win_qqmusic) and vim_qm()
i:: vim_qm(0)
q:: vim_qm(0)

c:: winReset(0, 0)
n:: click()
j:: wheelD()
k:: wheelU()
s:: wheelD()
w:: wheelU()
+s:: wheelD(3)
+w:: wheelU(3)
+j:: wheelD(3)
+k:: wheelU(3)
#HotIf

vim_qm(vim?) {
    static use := 1
    if (!isset(vim))
        return use
    use := (vim == -1) ? !use : vim
    return use
}


;添加鼠标位置专辑的所有歌到第一个歌单
addAllInAlbum() {
    ; w := 230    ;album gap
    ; h := 320
    MouseGetPos(&x, &y)
    click()    ;点击专辑
    sleep(759), click("874, 291")    ;点击点点点...
    sleep(200), click("890, 406")    ;点击批量管理
    sleep(200), click("320, 202")    ;点击全选方框
    sleep(200), click("549, 129")    ;点击添加到
    sleep(150), click("668, 321")    ;点击第一个歌单
    sleep(200), click("311, 44")    ;点击后退
    sleep(500), click("311, 44")    ;点击后退
    Sleep(100), click(x "," y ",0")    ;回到原点
}

;添加当前播放歌曲到第一个歌单
addcurto1() {
    MouseGetPos(&x, &y)
    click("469,834")    ;点击点点点
    Sleep(100)
    click("535,546")    ;点击添加到
    Sleep(100)
    click("769,135")    ;点击第一个歌单
    Sleep(100), click(x "," y ",0")    ;回到原点
}