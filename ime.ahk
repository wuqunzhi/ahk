; ==========o==========o==========o==========o==========o==========o 输入法
; ; 左shift 强制切换为英文输入法
; ; 500ms内双击左shift 强制切换为中文输入法
; ; 右shift 强制切换为中文输入法
; ; 右shift + 右alt 强制切换为美式键盘
; ; CapsLock + NumLock 全部窗口设置英文
; ; 中文时输入jkjk或按CapsLock切换为英文

RShift Up:: IME.isCHzhong() ? IME.setCHying() : IME.setCHzhong()
>!Rshift:: IME.setEn(), tip.p("美式键盘")
CapsLock & NumLock:: IME.setCHyingAll(), tip.p("全部窗口设置英文", 3000)
; >+.:: setCHzhong1025Force()

global ingame
#HotIf not ingame
#HotIf !GetKeyState('LAlt') ;!!!
Lshift Up:: {
    ; 左shift 强制切换为英文输入法
    ; no 右shift 强制切换为中文输入法
    ; 500ms内双击左shift 强制切换为中文输入法
    ; ! 注: 需要把微软自带的shift切换输入法中英文的快捷键取消
    ; ! 缺点: 切换中英文键盘 Alt shift如果alt先松开会触发"英",Ctrl,Win同理
    ; ! 可以按住alt 500ms以上再按shift, 或者shift先松开来解决
    stupid := A_TimeSincePriorHotkey = "" ? 501 : A_TimeSincePriorHotkey    ;V2的bug
    ; if (A_PriorKey = "Rshift" or A_PriorKey = "Lshift" and stupid < 500)
    if (A_PriorKey = "Lshift" and stupid < 500)
        IME.setCHzhong() ;tip.p("中")    ; , setCusor(1)
    else if (A_PriorKey = "Lshift")
        IME.setCHying() ;, tip("英")    ; , setCusor(0)
}
#HotIf

; #HotIf ingame in woz
; RShift:: IME.isCHzhong() ? IME.setCHying() : IME.setCHzhong()
; #HotIf


; 中文时输入jkjk或按CapsLock切换为英文
#HotIf IME.isCHzhong() and not ingame
CapsLock:: IME.setCHying(), tip.p("英")
:*b0?x:jkjk:: IME.setCHying(), tip.p("英")
:*b0?x:jjjj:: IME.setCHying(), tip.p("英")
^l:: send("{blink}{enter}")    ; , setCHyingForce(), tip("英")
#HotIf

/* 窗口切换时如果是中文输入法提醒一下
global preA := 0
watchIfAchange() {
    global curA := WinExist("A")
    if (preA != curA)
        if isCHzhong()
            ti.p("中", , A_ScreenWidth // 2, A_ScreenHeight // 2)    ;setCusor(1)
    ; Else
    ;     setCusor(0)
    preA := curA
}
*/
