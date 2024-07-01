class Brightness {
    ; https://github.com/tigerlily-dev/Monitor-Configuration-Class
    ; https://github.com/xianyukang/MyKeymap/blob/main/bin/MyKeymap.ahk
    static Get() {
        ; 使用wmi获取亮度
        brightness := ""
        For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightness")
            brightness := property.CurrentBrightness
        return brightness
    }
    static Set(brightness, timeout := 1) {
        ; 使用wmi设置亮度
        For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods")
            property.WmiSetBrightness(timeout, brightness)
    }
    static change(d) {
        curB := this.Get()
        newB := min(max(curB + d, 0), 100)
        this.Set(newB)
        tip.MM(newB, 1000)
    }
}