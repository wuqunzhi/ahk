class VirtualDesktop {
    ; https://www.autoahk.com/archives/44162
    static Current => ((ComCall(6, this.IVirtualDesktopManagerInternal, "ptr*", &currentDesktop := 0)), this(currentDesktop))
    static Count => (ComCall(3, this.IVirtualDesktopManagerInternal, "int*", &count := 0), count)
    static GetAt(index) {
        ComCall(7, this.IVirtualDesktopManagerInternal, "ptr*", desktops := ComValue(13, 0))
        ComCall(4, desktops, "uint", index, "ptr", this.IID_IVirtualDesktop, "ptr*", &desktop := 0)
        return VirtualDesktop(desktop)
    }
    static showCycleRight() {
        ; by wqz
        count := VirtualDesktop.Count
        index := VirtualDesktop.Current.Index
        rightNext := mod(index + 1, count)
        VirtualDesktop.GetAt(rightNext).Show()
        tipLM(rightNext . "")
    }
    static showCycleLeft() {
        ; by wqz
        count := VirtualDesktop.Count
        index := VirtualDesktop.Current.Index
        leftNext := mod(index + count - 1, count)
        VirtualDesktop.GetAt(leftNext).Show()
        tipLM(leftNext . "")
    }
    static Create() => (ComCall(10, this.IVirtualDesktopManagerInternal, "ptr*", &newDesktop := 0), VirtualDesktop(newDesktop))
    Id => (ComCall(4, this, "ptr", id := Buffer(16)), id.ToString := (_) => (DllCall('ole32\StringFromGUID2', "ptr", _, "ptr", buf := Buffer(78), "int", 39), StrGet(buf)), id)
    Left => (ComCall(8, VirtualDesktop.IVirtualDesktopManagerInternal, "ptr", this, "uint", 3, "ptr*", &leftDesktop := 0), VirtualDesktop(leftDesktop))
    Right => (ComCall(8, VirtualDesktop.IVirtualDesktopManagerInternal, "ptr", this, "uint", 4, "ptr*", &rightDesktop := 0), VirtualDesktop(rightDesktop))
    Visible => VirtualDesktop.Current.Equals(this)
    Index {
        get {
            thisId := this.Id, thisIdH := NumGet(thisId, "int64"), thisIdL := NumGet(thisId, 8, "int64")
            loop VirtualDesktop.Count {
                id := VirtualDesktop.GetAt(A_Index - 1).Id
                if NumGet(id, "int64") == thisIdH && NumGet(id, 8, "int64") == thisIdL
                    return A_Index - 1
            }
        }
    }
    Show() => ComCall(9, VirtualDesktop.IVirtualDesktopManagerInternal, "ptr", this)
    Remove(fallbackDesktop?) => ComCall(11, VirtualDesktop.IVirtualDesktopManagerInternal, "ptr", this, "ptr", fallbackDesktop ?? VirtualDesktop.GetAt(0))
    HasWindow(hwnd) {
        ComCall(4, VirtualDesktop.IVirtualDesktopManager, "ptr", hwnd, "ptr", id1 := Buffer(16))
        return NumGet(id1, "int64") == NumGet(id2 := this.Id, "int64") && NumGet(id1, 8, "int64") == NumGet(id2, 8, "int64")
    }
    ObtainWindow(hwnd) => ComCall(5, VirtualDesktop.IVirtualDesktopManager, "ptr", hwnd, "ptr", this.Id)
    Equals(desktop) => NumGet(id1 := this.Id, "int64") == NumGet(id2 := desktop.Id, "int64") && NumGet(id1, 8, "int64") == NumGet(id2, 8, "int64")
    static __New() {
        iServiceProvider := ComObject("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{6D5140C1-7436-11CE-8034-00AA006009FA}")
        this.IVirtualDesktopManagerInternal := ComObjQuery(iServiceProvider, "{C5E0CDCA-7B6E-41B2-9FC4-D93975CC467B}", "{F31574D6-B682-4CDC-BD56-1827860ABEC6}")
        this.IVirtualDesktopManager := ComObject("{AA509086-5CA9-4C25-8F95-589D3C07B48A}", "{A5CD92FF-29BE-454C-8D04-D82879FB3F1B}")
        NumPut("int64", 0x43fcbe7eff72ffdd, "int64", 0xe4881e6881ad039c, iid := Buffer(16))
        this.IID_IVirtualDesktop := iid
    }
    __New(ptr) {
        if !this.Ptr := ptr
            throw Error("Invalid pointer")
    }
    __Delete() => ObjRelease(this.Ptr)
}

; ---------------------------------------hook

class colorhook {
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
            case 1: this.info.Value := debuginfo('m c') . '(Insert键复制)'
            case 2: this.info.Value := debuginfo('all') . '(Insert键复制)'
            case 3: this.info.Value := debuginfo('w1') . '(Insert键复制)'
        }
    }
    nextColor(){
        static idx:=1
        colorList:=["c00ffff","cred"]
        idx:=nextn(idx,colorList.Length)
        this.info.opt(colorList[idx])
    }
    nextPage() {
         this.showpage := nextn(this.showpage, 3)
    }


}

class timerhook {
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
        ; tip("123", 5000, , , , 'r')
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