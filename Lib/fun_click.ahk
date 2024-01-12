mouseMoveFix(x, y) {
    ; 多显示器下 mousemove , click 等有bug
    ; https://www.autohotkey.com/boards/viewtopic.php?t=61242
    DllCall("SetCursorPos", "int", x, "int", y)
}
; (左-右+, 上-下+)
moveL(n) {
    ;1. send("{blink}{click 50 0 Rel}")
    ;2. MouseMove(-n, 0, , "R")
    xy := mouses()
    x := xy[1], y := xy[2]
    mouseMoveFix(x - n, y)
}
moveR(n) {
    ; MouseMove(n, 0, , "R")
    xy := mouses()
    x := xy[1], y := xy[2]
    mouseMoveFix(x + n, y)
}
moveU(n) {
    ; MouseMove(0, -n, , "R")
    xy := mouses()
    x := xy[1], y := xy[2]
    mouseMoveFix(x, y - n)
}
moveD(n) {
    ; MouseMove(0, n, , "R")
    xy := mouses()
    x := xy[1], y := xy[2]
    mouseMoveFix(x, y + n)
}
move(dx, dy) {
    ; MouseMove(dx, dy, , "R")
    xy := mouses()
    x := xy[0], y := xy[1]
    DllCall("SetCursorPos", "int", x + dx, "int", y + dy)
}
moveDMost() {
    clk.s(Format("{} {} 0", msx(), A_ScreenHeight - 20))
}
moveUMost() {
    clk.s(Format("{} {} 0", msx(), 0))
}
moveLMost() {
    clk.s(Format("{} {} 0", 0, msy()))
}
moveRMost() {
    clk.s(Format("{} {} 0", A_ScreenWidth - 10, msy()))
}
wheelD(count := 1) {
    ; clk.blink("WD " count)
    send("{blink}{click WD " count "}")
}
wheelU(count := 1) {
    send("{blink}{click WU " count "}")
}
wheelL(count := 1) {
    send("{blink}{click WL " count "}")
}
wheelR(count := 1) {
    send("{blink}{click WR " count "}")
}


class clk {

    ; str, rel := 'c', back := false, blink := true, clickif := false
    static k(str, rel := 'c', back := false, blink := true, clickif := false) {
        try {
            if (clickif) {
                poslist := StrSplitFix(str, ' ')
                dstx := Integer(poslist[1]), dsty := Integer(poslist[2])
                curx := mx(rel), cury := my(rel)
                if (dstx == curx && dsty == cury)
                    return
            }
            switch rel {
                case 's': coordmode('mouse', 'Screen')
                case 'w': coordmode('mouse', 'Window')
                case 'c': coordmode('mouse', 'Window')
                case 'm': rel := 'Rel'
                case 'rel': rel := 'Rel'
                default: coordmode('mouse', 'Client')
            }
            x := 0, y := 0
            back ? MouseGetPos(&x, &y) : 0
            blink ? blink := '{blink}' : ''
            send(blink '{click ' str ' ' rel '}')
            back ? send(blink '{click ' x ' ' y ' 0 ' rel '}') : 0
            CoordMode('Mouse', 'Client')
        } catch error as e {
            log(e)
        }
    }
    ; click only if no in giving pos
    static onlyif(x, y, c := 1) {
        c := c = 0 ? " 0" : c
        mousegetpos(&mx, &my)
        if (!(x = mx and y = my))
            send("{blink}{click " x " " y " " c "}")
    }


    ; count := 0, rel := 's'
    static center(count := 0, rel := 's') {
        ; todo rel:='c'
        str := Format("{} {} {}", A_ScreenWidth // 2, A_ScreenHeight // 2, count)
        clk.k(str, rel, back := false, blink := true, clickif := true)
    }

    ; search img in client and click
    static img(file, x1 := 0, y1 := 0, x2 := wincw(), y2 := winch(), err := 20, offsetX := 10, offsetY := 10, count := 1, back := 0) {
        file := Format('*{} {}', err, file)
        mousegetpos(&savex, &savey)
        res := imagesearch(&x, &y, x1, y1, x2, y2, file)
        if (res) {
            send('{blink}{click ' (x + offsetX) ' ' (y + offsetY) ' ' count '}')
            if (back)
                click(savex " " savey " 0")
        } else tip.p("no found: " file)
        return res ? x + offsetX " " y + offsetY : 0
    }

    ;click and mouse move back
    static back(str) {
        mousegetpos(&x, &y)
        send("{blink}{click " str "}")
        send("{blink}{click " x ", " y ", 0" "}")
        ; click(str)
        ; click(x "," y ",0")
    }

    ;send("{blink}{click " str "}")
    static blink(str, rel := 'c') {
        switch rel {
            case 's': coordmode("mouse", "Screen")
            case 'w': coordmode("mouse", "Window")
            default: coordmode("mouse", "Client")
        }
        send("{blink}{click " str "}")
        CoordMode("Mouse", "Client")
    }


    ; click rel to Screen
    static s(str) {
        coordmode("mouse", "Screen")
        click(str)
        CoordMode("Mouse", "Client")
    }
    ; click rel to Window
    static w(str) {
        coordmode("mouse", "Window")
        click(str)
        CoordMode("Mouse", "Client")
    }
    ; click rel to Client
    static c(str) {
        CoordMode("Mouse", "Client")
        click(str)
    }
    ; click rel to Client
    static rel(str, rel := 'c') {
        switch rel {
            case 'c': clk.c(str)
            case 's': clk.s(str)
            case 'w': clk.w(str)
        }
    }

    /**
     * @param {any} xypos ["10 20 1","10 20"]
     * @param {string} cmp 1 n l2r u2d
     * @param {bool} rev 
     */
    static cycle(xypos, cmp := "n", rev := 0) {
        len := xypos.length
        if (rev)
            xypos := reverseList(xypos)
        mousegetpos(&mx, &my)
        x(str) {
            xyc := strsplit(str, ' ')
            return xyc[1] = "x" ? msx : integer(xyc[1])
        }
        y(str) {
            xyc := strsplit(str, ' ')
            return xyc[2] = "y" ? msy : integer(xyc[2])
        }
        c(str) {
            xyc := strsplit(str, ' ')
            return (xyc.length >= 3) ? integer(xyc[3]) : 0
        }
        dist(str) {
            return (x(str) - mx) ** 2 + (y(str) - (my)) ** 2
        }
        next(i) {
            return mod(a_index, len) + 1
        }
        ret(i) {
            xx := x(xypos[i])
            yy := y(xypos[i])
            cc := c(xypos[i])
            xx := xx = 0 ? "0" : xx
            yy := yy = 0 ? "0" : yy
            cc := cc = 0 ? "0" : cc
            cc := cc = 1 ? "" : cc
            send("{blink}{click " . xx . " " . yy . " " . cc "}")
            return
            ; a_clipboard := ("{blink}{click " . " " . xx . " " . yy . " " . cc "}")
        }
        for str in xypos {
            if (dist(str) = 0) {
                ret(next(a_index))
                return
            }
        }
        switch cmp {
            case "1":
                ret(1)
            case "n": ;nearest
                min := 1000000000, minid := -1
                for str in xypos
                    if dist(str) < min
                        min := dist(str), minid := a_index
                ret(minid)
            case "l2r":
                for str in xypos {
                    if (x(str) < mx) {
                        ret(a_index)
                        return
                    }
                }
                ret(1)
            case "u2d":
                for str in xypos {
                    if (y(str) > my) {
                        ret(a_index)
                        return
                    }
                }
                ret(1)
        }

    }


}

mx(rel) {
    switch rel {
        case 'c': return mcx()
        case 's': return msx()
        case 'w': return mwx()
        default: return msx()
    }
}

my(rel) {
    switch rel {
        case 'c': return mcy()
        case 's': return msy()
        case 'w': return mwy()
        default: return msy()
    }
}

msx() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x)
    CoordMode("Mouse", "Client")
    return x
}
msy() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(, &y)
    CoordMode("Mouse", "Client")
    return y
}
mwx() {
    CoordMode("Mouse", "Window")
    MouseGetPos(&x)
    CoordMode("Mouse", "Client")
    return x
}
mwy() {
    CoordMode("Mouse", "Window")
    MouseGetPos(, &y)
    CoordMode("Mouse", "Client")
    return y
}
mcx() {
    CoordMode("Mouse", "Client")
    MouseGetPos(&x)
    CoordMode("Mouse", "Client")
    return x
}
mcy() {
    CoordMode("Mouse", "Client")
    MouseGetPos(, &y)
    CoordMode("Mouse", "Client")
    return y
}
mouses() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)
    CoordMode("Mouse", "Client")
    return [x, y]
}
mousew() {
    CoordMode("Mouse", "Window")
    MouseGetPos(&x, &y)
    CoordMode("Mouse", "Client")
    return [x, y]
}
mousec() {
    CoordMode("Mouse", "Client")
    MouseGetPos(&x, &y)
    CoordMode("Mouse", "Client")
    return [x, y]
}