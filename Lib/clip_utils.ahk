class Clip {
    static clear() => (A_Clipboard := '', Clip)
    static Clip_Saved := ''
    static save() => (Clip.Clip_Saved := A_Clipboard, Clip)
    static load() => (A_Clipboard := Clip.Clip_Saved, Clip)
    static transplain() => (A_Clipboard := A_Clipboard, Clip) ;转纯文本
}

; * use ctrl-c
plaincopy() {
    ; send("+{AppsKey}a"), sleep(50)
    send "^c"
    sleep(300) ;等复制完
    Clip.transplain()
    sleep(300) ;等转化完
    tip.p(A_Clipboard)
}

; append to clipborad use "^c"
appendCopy(sep := "`n", usekey := "^c") {
    tmp := A_Clipboard . sep
    A_Clipboard := ""
    send(usekey)
    ClipWait()
    tmp .= A_Clipboard
    tip.p(tmp, 2000)
    A_Clipboard := tmp
}

;sleep(delay) and tip clipboard
showcopy(delay := 200, time := 2000) {
    sleep(delay) ;must
    tip.RB("已复制: " A_Clipboard, time)
}

;copy str and tip
copyandshow(str, time := 2000, x := unset, y := unset) {
    A_Clipboard := str
    if (InStr(str, '`n'))
        str := '`n' . str
    if (isSet(x) && isSet(y))
        tip.show("已复制: " str, time, x?, y?)
    else
        tip.RB("已复制: " str, time)
}

appendCopyAndShow(str, append := '`n', time := 2000, x := unset, y := unset) {
    A_Clipboard .= (append . str)
    if (isSet(x) && isSet(y))
        tip.show("附加到剪贴板: " str, time, x?, y?)
    else
        tip.RB("附加到剪贴板: " str, time)
}

; time时间内按下key复制str到剪贴板
mayCopy(str := unset, key := "ctrl", time := 2) {
    if (KeyWait(key, 'DT' . time)) {
        A_Clipboard := str
        tip.MM("已复制")
    }
    ; SetTimer () => mayCopy(res), -50
    ; SetTimer () => mayCopy(rest, "t"), -50
    ; SetTimer () => mayCopy(resw, "w"), -50
}


;todo no use
cmdClipReturn(command, waittime := 2) {
    Clip.save().clear()
    try {
        RunWait(A_ComSpec " /C " command " | CLIP", , "Hide")
        ClipWait waittime
    }
    cmdInfo := A_Clipboard
    Sleep 500
    Clip.load()
    return cmdInfo
}