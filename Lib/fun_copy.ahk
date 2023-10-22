; * use ctrl-c
plaincopy() {
    ; send("+{AppsKey}a"), sleep(50)
    send "^c"
    sleep(300) ;等复制完
    A_Clipboard := A_Clipboard ;转纯文本
    sleep(300) ;等转化完
    tip(A_Clipboard)
}

; append to clipborad use "^c"
appendCopy(sep := "`n") {
    tmp := A_Clipboard . sep
    A_Clipboard := ""
    send("^c")
    ClipWait()
    tmp .= A_Clipboard
    tip(tmp)
    A_Clipboard := tmp
}

;sleep(delay) and tip clipboard
showcopy(delay := 200, time := 1000) {
    sleep(delay) ;must
    tip("已复制: " A_Clipboard, time, 0.8, 1)
}

;copy str and tip
copyandshow(str, append := "", time := 2000) {
    if (append) {
        A_Clipboard .= (append . str)
        Sleep(200)
        tip("附加到剪贴板: " str, time, 1, 1)
    } else {
        A_Clipboard := str
        if (InStr(str, '`n'))
            str := '`n' . str
        tip("已复制: " str, time, 1, 1)
    }
}

; time时间内按下key复制str到剪贴板
mayCopy(str := unset, key := "ctrl", time := 2) {
    if (KeyWait(key, 'DT' . time)) {
        A_Clipboard := str
        tip("已复制", , 0.5, 1)
    }
    ; SetTimer () => mayCopy(res), -50
    ; SetTimer () => mayCopy(rest, "t"), -50
    ; SetTimer () => mayCopy(resw, "w"), -50
}