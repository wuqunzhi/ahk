#HotIf
OnClipboardChange ClipRecorder.ClipChanged.Bind(ClipRecorder)
class ClipRecorder {
    static history := []
    static maxCount := 99
    static timeStep := 5 * 60
    static hookEnable := 1
    static clear() => (ClipRecorder.history := [], this)
    static record() {
        if (A_Clipboard == "clipclr" || A_Clipboard == "cclr") { ;清楚记录
            this.clear()
            return
        }
        if (this.history.Length >= this.maxCount)
            this.history.RemoveAt(1)
        this.history.Push({ time: 123, content: A_Clipboard })
    }

    static show(filePath := A_userPath . "\ClipboardHistory.txt", append := '`n') {
        ; 自定义函数，用于将剪贴板内容添加到历史记录中
        f := FileOpen(filePath, "w", "utf-8")
        for index, value in ClipRecorder.history {
            content := value.content
            if StrLen(content) > 500
                content := strdot('+', 80) . '`n' . content . '`n' . strdot('-', 80) . '`n'
            f.Write(content . append)
        }
        f.Close()
        code(filePath)
    }

    static ClipChanged(clip_type) {
        ; 0 = 剪贴板为空.
        ; 1 = 剪贴板包含可以用文本表示的内容(包括从资源管理器窗口复制的文件).
        ; 2 = 剪贴板包含完全是非文本的内容, 如图片.
        if (ClipRecorder.hookEnable and clip_type = 1) {
            ; ClipSaved := A_Clipboard ;保存上一个剪贴板历史
            ClipRecorder.record()
        }
    }

    static getHistort(last, append := "`n") {
        res := ""
        len := ClipRecorder.history.Length
        last := Min(len, last)
        loop last {
            res .= ClipRecorder.history[len - (last - A_Index)].content . append
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

:?*xc:CH2:: ClipRecorder.getHistort(2)
:?*xc:CH3:: ClipRecorder.getHistort(3)
:?*xc:CH4:: ClipRecorder.getHistort(4)
:?*xc:CH5:: ClipRecorder.getHistort(5)
:?*xc:CH6:: ClipRecorder.getHistort(6)
:?*xc:CH7:: ClipRecorder.getHistort(7)
:?*xc:CH8:: ClipRecorder.getHistort(8)
:?*xc:CH9:: ClipRecorder.getHistort(9)
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