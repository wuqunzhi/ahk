; (左-右+, 上-下+)
moveL(n) {
    ; sbclick("0 " n " 0 rel")
    ; click("0," n ",0,Rel")
    MouseMove(-n, 0, , "R")
}
moveR(n) {
    MouseMove(n, 0, , "R")
}
moveU(n) {
    MouseMove(0, -n, , "R")
}
move(x, y) {
    MouseMove(x, y, , "R")
}
moveD(n) {
    MouseMove(0, n, , "R")
}
moveDMost() {
    clickRelS(Format("{} {} 0", msx(), A_ScreenHeight - 20))
}
moveUMost() {
    clickRelS(Format("{} {} 0", msx(), 0))
}
moveLMost() {
    clickRelS(Format("{} {} 0", 0, msy()))
}
moveRMost() {
    clickRelS(Format("{} {} 0", A_ScreenWidth - 10, msy()))
}
wheelD(count := 1) {
    ; sbclick("WD " count)
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


focusCenter(count := 0, rel := 's') {
    ; todo rel:='c'
    str := Format("{} {} {}", A_ScreenWidth // 2, A_ScreenHeight // 2, count)
    clickk(str, rel, back := false, blink := true, clickif := true)
}

; search img in client and click
imgclick(file, back := 0, count := 1, offsetX := 10, offsetY := 10) {
    ; file := "*22 " . file
    mousegetpos(&savex, &savey)
    res := imagesearch(&x, &y, 0, 0, winw(), winh(), file)
    if (res) {
        click(x + offsetX " " y + offsetY " " count)
        if (back)
            click(savex " " savey " 0")
    } else tip.p("no found: " file)
    return res ? x + offsetX " " y + offsetY : 0
}

;click and mouse move back
clickb(str) {
    mousegetpos(&x, &y)
    send("{blink}{click " str "}")
    send("{blink}{click " x ", " y ", 0" "}")
    ; click(str)
    ; click(x "," y ",0")
}

;send("{blink}{click " str "}")
sbclick(str, rel := 'c') {
    switch rel {
        case 's': coordmode("mouse", "Screen")
        case 'w': coordmode("mouse", "Window")
        default: coordmode("mouse", "Client")
    }

    send("{blink}{click " str "}")
    CoordMode("Mouse", "Client")
}

clickk(str, rel := 'c', back := false, blink := true, clickif := false) {
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
        case 'm': nop()
        case 'rel': nop()
        default: coordmode('mouse', 'Client')
    }
    x := 0, y := 0
    back ? MouseGetPos(&x, &y) : 0
    blink ? blink := '{blink}' : ''
    rel == 'm' ? rel := 'Rel' : ''
    send(blink '{click ' str ' ' rel '}')
    back ? send(blink '{click ' x ' ' y ' 0 ' rel '}') : 0
    CoordMode('Mouse', 'Client')
}

; click rel to Screen
clickRelS(str) {
    coordmode("mouse", "Screen")
    click(str)
    CoordMode("Mouse", "Client")
}
; click rel to Window
clickRelW(str) {
    coordmode("mouse", "Window")
    click(str)
    CoordMode("Mouse", "Client")
}
; click rel to Client
clickRelC(str) {
    CoordMode("Mouse", "Client")
    click(str)
}
; click rel to Client
clickRel(str, rel := 'c') {
    switch rel {
        case 'c': clickRelC(str)
        case 's': clickRelS(str)
        case 'w': clickRelW(str)
    }
}


; click only if no in giving pos
clickif(x, y, c := 1) {
    c := c = 0 ? " 0" : c
    mousegetpos(&mx, &my)
    if (!(x = mx and y = my))
        send("{blink}{click " x " " y " " c "}")
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


/**
 * @param {any} xypos ["10 20 1","10 20"]
 * @param {string} cmp 1 n l2r u2d
 * @returns {void}
 */
/*
cycleclick(xypos, cmp := "n") {
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
    d(str) {
        return (x(str) - msx) ** 2 + (y(str) - (msy)) ** 2
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
        ; a_clipboard := ("{blink}{click " . " " . xx . " " . yy . " " . cc "}")
    }
    for str in xypos {
        if (d(str) = 0) {
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
                if d(str) < min
                    min := d(str), minid := a_index
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
*/
