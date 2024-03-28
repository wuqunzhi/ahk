; XButton1::^Insert ;复制
; XButton2::+Insert ;粘贴

#HotIf 0 ; 复制粘贴
XButton1::^Insert ;复制
XButton2::+Insert ;粘贴

#HotIf 0
RButton::2
XButton1::2

#HotIf 0 and ingame and WinActive("ahk_group games")
Space::LButton
; XButton1::e ;上一曲
; XButton2::e ;上一曲
; MButton::e
; w::Up
; s::Down
; a::Left
; d::Right
; k::space
; j::e


#HotIf 0 ;音乐
XButton1::^!, ;上一曲
XButton2::^!. ;下一曲
RButton::^!l  ;添加到喜欢
WheelDown::Volume_Down
WheelUp::Volume_Up
#HotIf