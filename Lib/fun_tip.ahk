/**
 * @param x,y
 * x,y为[0~1]时,被当成屏幕比例例如(0,1)左下角,(1,0.5)最右边中间
 * x,y为空，鼠标附近
 * @param time time为"oo",don't disapear
 * @param which which为空: cycle 1-10
 *  18:cilpbHook 17:vimiumpp 16:zvim 13:music
 *  11: left bottom 3s
 *  12: for will remove after oo
 * *(repeat tip dont set which otherwise flash (kill pre))
 * @param rel  s:screen  w:client  r:random  m:mouse
 */
tip(str := unset, time := 500, x := unset, y := unset, which := unset, rel := 's') {
    ; !!! assert A_CoordModeToolTip == "Screen" !!!

    if (!IsSet(str)) {
        ToolTip(str?, x?, y?, which?)
        return
    }
    if(IsInteger(str)){
        str:=String(str)
    }
    winx := 0, winy := 0, winw := A_ScreenWidth, winh := A_ScreenHeight

    switch rel {
        case "c": WinGetClientPos(&winx, &winy, &winw, &winh, "A")
        case "m":
            CoordMode("Mouse", "Screen")
            MouseGetPos(&winx, &winy)
            CoordMode("Mouse", "Client")
        case "r":
            winx := Random(1, A_ScreenWidth), x := 0
            winy := Random(1, A_ScreenHeight), y := 0
    }

    ; x y
    x := IsSet(x) ? gen(x, winx, winw) : (x?)
    y := IsSet(y) ? gen(y, winy, winh) : (y?)
    gen(x, winx, winw) {
        if (!(0 <= x and x <= 1))
            winw := 1
        return Integer(winx + x * winw)
    }

    ; which
    static c := 1
    which := IsSet(which) ? which : Mod(c++, 10) + 1

    ; ToolTip
    tooltip(str?, x?, y?, which)

    ; removetip
    if (time != "oo")
        settimer () => tooltip(, , , which), -time
}

; tip left bottom 11
tipLB(str := unset, time := 3000) {
    tip(str?, time, 0, 1, 11)
}
; tip middle middle 16
tipMM(str := unset, time := 1000) {
    tip(str?, time, 0.45, 0.5, 19)
}
; tip middle bottom 12
tipMB(str := unset, time := 3000) {
    tip(str?, time, 0.45, 1, 12)
}
; tip right bottom 13
tipRB(str := unset, time := 3000) {
    tip(str?, time, 1, 1, 13)
}
; tip left middle
tipLM(str, time := 500) {
    ;不指定which,否则频繁执行会消掉原先tip
    tip(str, time, 0, 0.5)
}
; tip right middle 15
tipRM(str, time := 3000) {
    tip(str, time, 1, 0.5, 15)
}

log(e) {
    tipMM(type(e) " in " e.What ", which was called at line " e.Line, 3000)
}
logM(e) {
    s := Format("{1}: {2}.`n`nFile:`t{3}`nLine:`t{4}`nWhat:`t{5}`nStack:`n{6}"
        , type(e), e.Message, e.File, e.Line, e.What, e.Stack)
    MsgBox(s)
}

tipp(str := unset, time := 5000, x := unset, y := unset, which_ := unset) {
    ; todo no use
    ; owner := "a"
    ; owner := "a" ? wingetid("a") : owner
    ; tipgui.opt("+owner" owner "alwaysontop +toolwindow")

    tipgui := gui()
    ; tipgui.title := str
    ; tipgui.backcolor := "eeaa99"    ; eeaa99可以是任何 rgb 颜色(下面会变成透明的).
    ; winsettranscolor(tipgui.backcolor " 150", tipgui)
    pos := ""
    if (isset(x))
        pos .= "x " x
    if (isset(y))
        pos .= "y " y
    ; tipgui.add("text")    ; ym 选项开始一个新的控件列.
    tipgui.addtext(, str)
    tipgui.opt("-caption +toolwindow")
    tipgui.show("noactivate " pos)
    sleep(time)
    tipgui.destroy()
}

; loop num{Tooltip , , ,A_index}
removeAllTip(num := 20) {
    Loop num
        ToolTip(, , , A_Index)
}

;全屏提示
tipFullScreen(str, septime := 50) {
    loop 20 {
        tip(str, 2000, , , , 'r')
        sleep(septime)
    }
}