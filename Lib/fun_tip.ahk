class tip {
    static removeTips := []
    static randomMaxIndex := 10
    static tipWidth := A_ScreenWidth // 20
    static tipHeight := 25
    static pos_lt := 11
    static pos_mt := 12
    static pos_rt := 13
    static pos_lm := 14
    static pos_mm := 15
    static pos_rm := 16
    static pos_lb := 17
    static pos_mb := 18
    static pos_rb := 19
    static __New() {
        CoordMode("ToolTip", "Screen")
        loop 20
            tip.removeTips.Push(ToolTip.bind(, , , A_Index))
    }
    /**
     * @param x,y  
     * x,y为[0~1]时,被当成屏幕比例例如(0,1)左下角,(1,0.5)最右边中间  
     * x,y为空，鼠标附近  
     * @param time time为"oo",永久  
     * @param which which为空: 2-10  
     * 12 12 13  
     * 15 15 16  
     * 18 18 19  
     * @param rel   
     * s:screen   
     * w:client   
     * r:random   
     * m:mouse  
     * n:  
     * ;-----------------------  
     * ; 0,1,2...[x]...-2,-1(20)  
     * ; 1  
     * ; 2  
     * ; .  
     * ; [y]  
     * ; .  
     * ; -1  
     * ; 0 (40)  
     * ;-----------------------  
     */

    __New(str := unset, time := 500, x := unset, y := unset, which := unset, rel := 's') {
        tip.pp(str := unset, time := 500, x := unset, y := unset, which := unset, rel := 's')
    }
    static pp(str := unset, time := 500, x := unset, y := unset, which := unset, rel := 's') {
        if (!IsSet(str)) {
            ToolTip(, , , which?)
            return
        }
        if (IsInteger(str))
            str := String(str)
        ; x,y
        switch rel {
            case "s": ; screen
                winx := 0, winy := 0, winw := A_ScreenWidth, winh := A_ScreenHeight
                x := !IsSet(x) ? unset : genxy(winx, winw, x?)
                y := !IsSet(y) ? unset : genxy(winy, winh, y?)
            case "c": ; client
                WinGetClientPos(&winx, &winy, &winw, &winh, "A")
                x := !IsSet(x) ? unset : genxy(winx, winw, x?)
                y := !IsSet(y) ? unset : genxy(winy, winh, y?)
            case "m": ; mouse
                x := !IsSet(x) ? unset : msx() + x
                y := !IsSet(y) ? unset : msy() + y
            case "r": ; random
                x := !IsSet(x) ? unset : Random(1, A_ScreenWidth)
                y := !IsSet(y) ? unset : Random(1, A_ScreenHeight)
            case "n": ; n
                x := !IsSet(x) ? unset : genn(A_ScreenWidth, tip.tipWidth, x)
                y := !IsSet(y) ? unset : genn(A_ScreenHeight - A_TaskbarHeight, tip.tipHeight, y)
                genxy(winx, winw, x) {
                    if (!(0 <= x and x <= 1))
                        winw := 1
                    return Integer(winx + x * winw)
                }
                genn(total, joint, pos) {
                    return pos < 0 ? total + pos * joint : pos * joint
                }
        }

        ; which
        static c := 1
        which := IsSet(which) ? which : Mod(c++, tip.randomMaxIndex) + 1

        ; ToolTip
        tooltip(str?, x?, y?, which)

        ; removeTip
        SetTimer(tip.removeTips[which], 0)
        if (time != "oo")
            SetTimer(tip.removeTips[which], -time)
    }

    static p(str := unset, time := 500) {
        tip.pp(str?, time)
    }
    static mouse(str := unset, time := 500, x := unset, y := unset, which := unset) {
        tip.pp(str?, time, x?, y?, which?, 'm')
    }
    static client(str := unset, time := 500, x := unset, y := unset, which := unset) {
        tip.pp(str?, time, x?, y?, which?, 'c')
    }
    static random(str, time := 500, which := unset) {
        tip.pp(str, time, , , which?, 'r')
    }
    static n(str := unset, time := 500, x := unset, y := unset, which := unset) {
        tip.pp(str?, time, x?, y?, which?, 'n')
    }
    static LT(str := unset, time := 3000) {
        tip.pp(str?, time, 0, 0, tip.pos_lt)
    }
    static MT(str := unset, time := 3000) {
        tip.pp(str?, time, 0.45, 0, tip.pos_mt)
    }
    static RT(str := unset, time := 3000) {
        tip.pp(str?, time, 1, 0, tip.pos_rt)
    }
    static LM(str := unset, time := 500) {
        tip.pp(str?, time, 0, 0.5, tip.pos_lm)
    }
    static MM(str := unset, time := 3000) {
        tip.pp(str?, time, 0.45, 0.5, tip.pos_mm)
    }
    static RM(str := unset, time := 3000) {
        tip.pp(str?, time, 1, 0.5, tip.pos_rm)
    }
    static LB(str := unset, time := 3000) {
        tip.pp(str?, time, 0, 1, tip.pos_lb)
    }
    static MB(str := unset, time := 3000) {
        tip.pp(str?, time, 0.4, 1, tip.pos_mb)
    }
    static RB(str := unset, time := 3000) {
        tip.pp(str?, time, 1, 1, tip.pos_rb)
    }

    static removeTip(num) {
        ToolTip(, , , num)
    }

    static removeAllTip(num := 20) {
        Loop num
            ToolTip(, , , A_Index)
    }

    static tipFullScreen(str, septime := 50) {
        loop 20 {
            tip.random(str, 2000, A_Index)
            sleep(septime)
        }
    }

    static pro(str := unset, time := 5000, x := unset, y := unset, which_ := unset) {
        ; !todo
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

}


log(e) {
    tip.MM(type(e) " in " e.What ", which was called at line " e.Line, 3000)
}
logM(e) {
    s := Format("{1}: {2}.`n`nFile:`t{3}`nLine:`t{4}`nWhat:`t{5}`nStack:`n{6}"
        , type(e), e.Message, e.File, e.Line, e.What, e.Stack)
    MsgBox(s)
}