#SingleInstance Force
#HotIf WinActive("Slay the Spire")
#MaxThreadsPerHotkey 3
Numpad9:: fx_nxnj()
#MaxThreadsPerHotkey 1
NumpadDot:: sl()
#HotIf
fx_nxnj() {
    ; 发泄,内心宁静循环
    Static running := false
    running := !running
    if running
        Loop {
            ; 按下4点击确定
            send 2
            sleep 200
            Click "1404, 480"
            sleep 500
            ; 按下3点击确定;
            send 1
            sleep 200
            Click "1404, 480"
            ; 等待洗牌
            sleep 3000
            if not running
                break
        }
}
sl() {
    ;esc
    send "{esc}"
    sleep 500
    ;保存并退出
    click "1524, 951"
    sleep 500
    ;是
    click "863, 698"
    sleep 500
    ;等待主菜单
    sleep 3000
    ;点击继续
    Click "177, 669"    ;继续
}