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
moveD(n) {
    MouseMove(0, n, , "R")
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

; search img in client and click
imgclick(file, back := 0, count := 1, offsetX := 10, offsetY := 10) {
    ; file := "*22 " . file
    mousegetpos(&savex, &savey)
    res := imagesearch(&x, &y, 0, 0, winw(), winh(), file)
    if (res) {
        click(x + offsetX " " y + offsetY " " count)
        if (back)
            click(savex " " savey " 0")
    } else tip("no found: " file)
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
sbclick(str) {
    send("{blink}{click " str "}")
}

;click relative to screen
clickRelToScreen(str) {
    coordmode("mouse", "Screen")
    click(str)
    CoordMode("Mouse", "Client")
}

;click relative to window
clickRelToWindow(str) {
    coordmode("mouse", "Window")
    click(str)
    CoordMode("Mouse", "Client")
}

;click relative to Client
clickRelToClient(str) {
    coordmode("mouse", "Client")
    click(str)
    CoordMode("Mouse", "Client")
}

; click only if no in giving pos
clickif(x, y, c := 1) {
    c := c = 0 ? " 0" : c
    mousegetpos(&mx, &my)
    if (!(x = mx and y = my))
        send("{blink}{click " x " " y " " c "}")
}

;click(x*w, y*h) ;(coord to client)
clickfocus(x := 0.5, y := 0.5) {
    WinGetPos(, , &w, &h, "A")
    x := x <= 1 ? Integer(x * w) : x
    y := y <= 1 ? Integer(y * h) : y
    click(x ", " y)
}

/**
 * @param {any} xypos ["10 20 1","10 20"] or "10 20 c" (c:=1 clickif c:=0 move)
 * @param {string} cmp 1 n l2r u2d
 * @returns {void}
 */
cycleclick(xypos, cmp := "n") {
    ; 一坨屎,没用过
    len := xypos.length
    if (len = 1) {
        x1 := x(xypos[1]), y1 := y(xypos[1]), c1 := c(xypos[1])
        if (c1)
            clickif(x1, y1)
        else
            send("{blink}{click " . x1 . " " . y1 . " 0 }")
        return
    }
    mousegetpos(&mx, &my)
    x(str) {
        xyc := strsplit(str, ' ')
        return xyc[1] = "x" ? mx : integer(xyc[1])
    }
    y(str) {
        xyc := strsplit(str, ' ')
        return xyc[2] = "y" ? my : integer(xyc[2])
    }
    c(str) {
        xyc := strsplit(str, ' ')
        sc := (xyc.length >= 3) ? integer(xyc[3]) : 0
        return sc
    }
    d(str) {
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