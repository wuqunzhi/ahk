#HotIf

class SettingsGUI {
    /**
     * 呼出窗口进行简单的参数设置
     * 
     * @param {Map} vals 设置项
     * @param {Map} defaults 设置项默认值
     * @param {String} title 窗口标题
     * @param {Array} prompt 前缀和后缀
     * @param {string} size 窗口大小  
     */
    static run(valsMap, defaults := Map(), title := "setting", prompt := ["", ""], w := 400, h := 0) {

        prompt := "
        (
            用法：
                :set key1 val1 [key2 val2 ...]
                :set key "val with space"
                :reset [key]
            )" . "`n"
        pre := ""
        for settingName, settingVal in valsMap {
            if InStr(settingVal, ' ')
                settingVal := '"' . settingVal . '"'
            pre .= Format(':set {} {}`n', settingName, settingVal)
        }
        h := h == 0 ? 25 * countLines(pre . prompt) : h
        tip.p(h)
        sizestr := Format('w{} h{}', w, h)
        IB := InputBox(pre . prompt, title, sizestr)
        if (IB.result = "Cancel") {
            return
        }
        cmd := Trim(IB.Value)
        try dealcmd(cmd)
        catch Error as e {
            logM(e)
        }
        dealcmd(cmd) {
            if (cmd == "")
                return
            args := StrSplitFix(cmd, A_Space)
            if (args.Length <= 2) {
                switch args[1] {
                    case "reset":
                        keys := args.Length == 2 ? args[2] : unset
                        this.reset(valsMap, defaults, keys)
                }
                return
            }
            if (args.Length >= 3) {
                if (args[3][1] == '"') {
                    args := StrSplitFix(cmd, A_Space, , 3)
                }
                switch args[1] {
                    case "set":
                        res := ""
                        loop (args.Length - 1) // 2 {
                            key := args[2 * A_Index]
                            val := args[2 * A_Index]
                            valsMap.Has(key) ? valsMap[key] := val : 0
                            res .= Format('set {} {}`n', key, val)
                        }
                        tip.LB(res)
                }
            }
        }
    }

    /**
     * 
     * @param valsMap 
     * @param defaults 
     * @param keys Array or String or unset
     */
    static reset(valsMap, defaults, resetKeys := unset) {
        res := ""
        keys := []
        if (resetKeys is String)
            keys.Push(resetKeys)
        else if (resetKeys is Array)
            keys := resetKeys
        else if (!isSet(resetKeys))
            for key, _ in valsMap
                keys.push(key)

        for key in keys {
            if (valsMap.Has(key) and defaults.Has(key)) {
                valsMap[key] := defaults[key]
                res .= Format('reset {} {}`n', key, defaults[key])
            }
        }
        tip.LB(keys)
    }
}

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
        colorList := ["c00ffff", "cred"]
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
        if (res[1] = 'c') {
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