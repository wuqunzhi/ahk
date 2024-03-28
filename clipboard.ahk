#HotIf
OnClipboardChange CBH.ClipChanged.Bind(CBH)
class CBH {
    static clipboardHistory := []
    static maxHistoryCount := 99
    static AddToClipboardHistory() {
        if (this.clipboardHistory.Length >= this.maxHistoryCount)
            CBH.clipboardHistory.RemoveAt(1)
        CBH.clipboardHistory.Push(A_Clipboard)
    }

    static writeAndShowCBH(filePath := A_userPath . "\ClipboardHistory.txt", append := '`n') {
        ; 自定义函数，用于将剪贴板内容添加到历史记录中
        f := FileOpen(filePath, "w", "utf-8")
        for index, value in CBH.clipboardHistory {
            if StrLen(value) > 500
                value := strdot('+', 80) . '`n' . value . '`n' . strdot('-', 80) . '`n'
            f.Write(value . append)
        }
        f.Close()
        run("code " filePath)
    }

    static useClipbHook := 1
    static ClipChanged(clip_type) {
        ; 0 = 剪贴板为空.
        ; 1 = 剪贴板包含可以用文本表示的内容(包括从资源管理器窗口复制的文件).
        ; 2 = 剪贴板包含完全是非文本的内容, 如图片.
        if (CBH.useClipbHook and clip_type = 1) {
            ; ClipSaved := A_Clipboard ;保存上一个剪贴板历史
            CBH.AddToClipboardHistory()
        }
    }

    static getClipboardHistory(last, append := "`n") {
        res := ""
        len := CBH.clipboardHistory.Length
        last := Min(len, last)
        loop last {
            res .= CBH.clipboardHistory[len - (last - A_Index)] . append
        }
        tip.RM(res)
        A_Clipboard := res
    }
    chAll(i) {
        loop i {
            send("#v"), Sleep(200), send("{Down " i - A_index "}"), Sleep(100), send("{enter}")
            sleep(100)
        }
    }
}

:?*xc:CH2:: CBH.getClipboardHistory(2)
:?*xc:CH3:: CBH.getClipboardHistory(3)
:?*xc:CH4:: CBH.getClipboardHistory(4)
:?*xc:CH5:: CBH.getClipboardHistory(5)
:?*xc:CH6:: CBH.getClipboardHistory(6)
:?*xc:CH7:: CBH.getClipboardHistory(7)
:?*xc:CH8:: CBH.getClipboardHistory(8)
:?*xc:CH9:: CBH.getClipboardHistory(9)
; :?*xc:ch1:: send("#v"), Sleep(200), send("{Down 0}"), Sleep(100), send("{enter}") ; ctrl v
:?*xc:ch2:: send("#v"), Sleep(200), send("{Down 1}"), Sleep(100), send("{enter}")
:?*xc:ch3:: send("#v"), Sleep(200), send("{Down 2}"), Sleep(100), send("{enter}")
:?*xc:ch4:: send("#v"), Sleep(200), send("{Down 3}"), Sleep(100), send("{enter}")
:?*xc:ch5:: send("#v"), Sleep(200), send("{Down 4}"), Sleep(100), send("{enter}")
:?*xc:ch6:: send("#v"), Sleep(200), send("{Down 5}"), Sleep(100), send("{enter}")
:?*xc:ch7:: send("#v"), Sleep(200), send("{Down 6}"), Sleep(100), send("{enter}")
:?*xc:ch8:: send("#v"), Sleep(200), send("{Down 7}"), Sleep(100), send("{enter}")
:?*xc:ch9:: send("#v"), Sleep(200), send("{Down 8}"), Sleep(100), send("{enter}")

#HotIf