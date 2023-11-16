#HotIf
; clipboard history
global clipboardHistory := []
global maxHistoryCount := 99

; 自定义函数，用于将剪贴板内容添加到历史记录中
AddToClipboardHistory() {
    if (clipboardHistory.Length >= maxHistoryCount)
        clipboardHistory.RemoveAt(1)
    clipboardHistory.Push(A_Clipboard)
}

writeAndShowCBH(filePath := get_A_userPath() . "\ClipboardHistory.txt", append := '`n') {
    ; f := FileOpen(filePath, "w" )
    f := FileOpen(filePath, "w", "utf-8")
    for index, value in clipboardHistory
        f.Write(value . append)
    f.Close()
    run("code " filePath)
}

OnClipboardChange ClipChanged
global useClipbHook := 1
ClipChanged(clip_type) {
    ; 0 = 剪贴板为空.
    ; 1 = 剪贴板包含可以用文本表示的内容(包括从资源管理器窗口复制的文件).
    ; 2 = 剪贴板包含完全是非文本的内容, 如图片.
    if (useClipbHook and clip_type = 1) {
        ; ClipSaved := A_Clipboard ;保存上一个剪贴板历史
        AddToClipboardHistory()
    }
}

getClipboardHistory(last, append := "`n") {
    res := ""
    len := clipboardHistory.Length
    last := Min(len, last)
    loop last {
        res .= clipboardHistory[len - (last - A_Index)] . append
    }
    tipRM(res)
    A_Clipboard := res
    ; send("+{Insert}")
}
:?*xc:CH2:: getClipboardHistory(2)
:?*xc:CH3:: getClipboardHistory(3)
:?*xc:CH4:: getClipboardHistory(4)
:?*xc:CH5:: getClipboardHistory(5)
:?*xc:CH6:: getClipboardHistory(6)
:?*xc:CH7:: getClipboardHistory(7)
:?*xc:CH8:: getClipboardHistory(8)
:?*xc:CH9:: getClipboardHistory(9)


; clipboard historys
; :?*xc:ch1:: send("#v"), Sleep(200), send("{Down 0}"), Sleep(100), send("{enter}") ; ctrl v
:?*xc:ch2:: send("#v"), Sleep(200), send("{Down 1}"), Sleep(100), send("{enter}")
:?*xc:ch3:: send("#v"), Sleep(200), send("{Down 2}"), Sleep(100), send("{enter}")
:?*xc:ch4:: send("#v"), Sleep(200), send("{Down 3}"), Sleep(100), send("{enter}")
:?*xc:ch5:: send("#v"), Sleep(200), send("{Down 4}"), Sleep(100), send("{enter}")
:?*xc:ch6:: send("#v"), Sleep(200), send("{Down 5}"), Sleep(100), send("{enter}")
:?*xc:ch7:: send("#v"), Sleep(200), send("{Down 6}"), Sleep(100), send("{enter}")
:?*xc:ch8:: send("#v"), Sleep(200), send("{Down 7}"), Sleep(100), send("{enter}")
:?*xc:ch9:: send("#v"), Sleep(200), send("{Down 8}"), Sleep(100), send("{enter}")

; :?*xc:CH2:: chAll(2) ;ch2+ch1
; :?*xc:CH3:: chAll(3) ;ch3+ch2+ch1
; :?*xc:CH4:: chAll(4)
; :?*xc:CH5:: chAll(5)
; :?*xc:CH6:: chAll(6)
; :?*xc:CH7:: chAll(7)
; :?*xc:CH8:: chAll(8)
; :?*xc:CH9:: chAll(9)

; chAll(i) {
;     loop i {
;         send("#v"), Sleep(200), send("{Down " i - A_index "}"), Sleep(100), send("{enter}")
;         sleep(100)
;     }
; }

; #HotIf
