/* 多显示器相关 */
class MultiMonitor {
    ; 鼠标移动到下个屏幕中间
    static mouseFocusNext() => msx() > 2000 ? mouseMoveFix(960, 540) : mouseMoveFix(3600, 640)
    ; 鼠标移动到下个屏幕中间并点击(workaround)
    static clickFocusNext() => (this.mouseFocusNext(), send("{blink}{click}"))
    ; 当前窗口所在显示器序号
    static getCurrentIndex() => winx() > 2000
    ; 窗口所在显示器序号
    static belongIndex(winT) => winx(winT) > 2000
    ; 切换焦点到目标显示器
    static activate(idx) {
        curIdx := this.getCurrentIndex()
        curIdx ? tip.LM(0) : tip.LM2(1)

        if (curidx == idx) {
            curIdx ? tip.LM2(1) : tip.LM(0)
            return
        }
        idList := WinGetList()
        for id in idList {
            if (WinActive("ahk_id " id))
                continue
            If (WinGetTitle("ahk_id " id) == "")
                continue
            If (!IsWindow(id))
                continue
            if (isDesktop(id)) {
                continue
            }
            if (this.belongIndex(id) != idx)
                continue
            WinActivate("ahk_id " id)
            break
        }
    }
    ; 切换焦点到下个显示器的激活窗口 好好好
    static activateNext() => this.activate(!this.getCurrentIndex())


    ; "/Monitor.ahk"
    ; "/VisualDesktop.ahk"
    ; +#Left/Right 移动当前窗口到下一屏幕
}

class VimControl {
    static use := 1
    static vim(vim?) {
        if (!isset(vim))
            return this.use
        if (vim == -1)
            this.use := !this.use
        else
            this.use := vim
        return this.use
    }
}
#HotIf

; --------------------------------------- GUI
class colorGUI {
    showpage := 1
    g := creathookGui()
    info := this.g.AddText("c00ffff", strdot(strdot(" ", 100) . '`n', 20))  ;w:100 h:20
    timer := this.UpdateColor.Bind(this)
    toggleshow(str := "toggle") {
        switch str {
            case "toggle":
                if (WinExist("ahk_exe AutoHotkey64.exe ahk_id " this.g.Hwnd))
                    this.toggleshow('hide')
                else
                    this.toggleshow('show')
            case "hide":
                SetTimer this.timer, 0
                this.g.hide()
            case "show":
                this.g.Show("x0 y0 NoActivate")    ; NoActivate 让当前活动窗口继续保持活动状态.
                SetTimer this.timer, 250
                this.UpdateColor()    ; 立即进行第一次更新而不等待计时器.
        }
    }
    UpdateColor() {
        switch this.showpage {
            case 1: this.info.Value := debuginfo('m c') . '➤ Insert键复制'
            case 2: this.info.Value := debuginfo('all') . '➤ Insert键复制'
            case 3: this.info.Value := debuginfo('w1') . '➤ Insert键复制'
        }
    }
    nextColor() {
        static idx := 1
        colorList := "c00ffff", "cred"
        idx := nextn(idx, colorList.Length)
        this.info.opt(colorList[idx])
    }
    nextPage() {
        this.showpage := nextn(this.showpage, 3)
    }


}

class timerGUI {
    ; g := creathookgui(20, "c8000FF", "Bookman Old Style")
    color1 := "c00BFFF"
    color2 := "cred"
    g := creathookgui(20, this.color1, "Bookman Old Style")
    ispause := 0
    showway := 1
    t2 := this.g.AddText("x0 y0", "             ")
    ; deadline := DateAdd(A_Now, 60, "Minutes")
    ; https://wyagd001.github.io/v2/docs/commands/SetTimer.htm#ExampleClass
    deadline := 60 * 60
    timer := this.UpdateTime.Bind(this)

    UpdateTime() {
        this.deadline -= 1
        ; remainseconds := DateDiff(this.deadline, A_Now, "Seconds")
        life := this.deadline
        ; this.t2.Value := seconds2hhmmss(remainseconds)
        ; this.t2.Value := life < 3600 ? seconds2mmss(life) : seconds2hhmmss(life)
        this.t2.Value := seconds2hhmm(life)
        if (life <= 0) {
            ; SetTimer () => this.UpdateTime(), 0
            SetTimer(, 0)
            this.timeout()
            return
        }
    }
    ; __New() {
    ; }

    timeout() {
        ; loop 2 {
        SoundPlay("jntmwzb.mp3")
        MsgBox("timeout!")
        try {
            SoundPlay("noexise")
        }
        ; loop 2
        ; Sleep(2000)
        ; }
    }

    setdeadline(num?) {
        if (IsSet(num)) {
            this.deadline := num * 60
            SetTimer this.timer, 0
            SetTimer this.timer, 1000
            return
        }
        IB := InputBox(, "time", "h80")
        if (IB.result != "ok")
            return
        res := Trim(IB.Value)
        if (res = 'p') {
            this.pause()
            return
        }
        if (SubStr(res, 1, 1) = 'c') {
            this.color1 := res
            this.t2.opt(this.color1)
            return
        }
        ; this.deadline := DateAdd(A_Now, res, "Minutes")
        this.deadline := Integer(res) * 60
        SetTimer this.timer, 0
        SetTimer this.timer, 1000
        this.ispause := 0
        this.t2.opt(this.color1)
    }

    pause() {
        this.ispause := !this.ispause
        if (this.ispause)
            SetTimer(this.timer, 0), this.t2.opt(this.color2)
        else
            SetTimer(this.timer, 1000), this.t2.opt(this.color1)
    }

    toggleshow() {
        if this.isshow() {
            SetTimer this.timer, 0
            this.g.hide()
            return 0
        }
        ; SetTimer () => this.timer(), 1000
        this.g.Show("x10 y950 NoActivate")
        this.setdeadline(60)
        return 1
    }

    isshow() {
        return WinExist("ahk_exe AutoHotkey64.exe ahk_id " this.g.Hwnd)
    }
}