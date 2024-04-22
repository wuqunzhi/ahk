; XButton1::^Insert ;复制
; XButton2::+Insert ;粘贴
#HotIf ingame and WinActive("Dungeon Munchies ahk_exe Dungeon Munchies.exe ahk_class UnityWndClass")
XButton2::4

#HotIf

#HotIf 0 ; 复制粘贴
XButton1::^Insert ;复制
XButton2::+Insert ;粘贴

#HotIf 0
RButton::2
XButton1::2

#HotIf 0 and ingame and WinActive("ahk_group games")
Space::LButton


#HotIf 0 ;音乐
XButton1::^!, ;上一曲
XButton2::^!. ;下一曲
RButton::^!l  ;添加到喜欢
WheelDown::Volume_Down
WheelUp::Volume_Up
NumpadDot::Volume_Down
NumpadEnter::Volume_Up
Left::Volume_Down
Down::Volume_Down
Right::Volume_Up
Up::Volume_Up

#HotIf