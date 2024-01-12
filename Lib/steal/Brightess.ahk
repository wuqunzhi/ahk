class Brightness {
    ; https://github.com/tigerlily-dev/Monitor-Configuration-Class
    ; https://github.com/xianyukang/MyKeymap/blob/main/bin/MyKeymap.ahk
    static GetBrightness() {
        ; 使用wmi获取亮度
        brightness := ""
        For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightness")
            brightness := property.CurrentBrightness
        return brightness
    }
    static SetBrightness(brightness, timeout := 1) {
        ; 使用wmi设置亮度
        For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods")
            property.WmiSetBrightness(timeout, brightness)
    }
    static changeBrightness(d) {
        curB := this.GetBrightness()
        newB := min(max(curB + d, 0), 100)
        this.SetBrightness(newB)
        tip.MM(newB, 1000)
    }
}