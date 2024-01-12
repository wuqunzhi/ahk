#HotIf 1
<!s::MButton

#HotIf 0 ; 复制粘贴
XButton1::^Insert ;上一曲
XButton2::+Insert ;下一曲

#HotIf 0 ; 游戏改建
; w::Up
; s::Down
; a::Left
; d::Right
k::space
j::e

#HotIf 0 ;鼠标控制播放器
XButton1::^!, ;上一曲
XButton2::^!. ;下一曲
RButton::^!l  ;添加到喜欢
WheelDown::Volume_Down
WheelUp::Volume_Up
#HotIf