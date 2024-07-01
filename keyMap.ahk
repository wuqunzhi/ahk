; XButton1::^Insert ;复制
; XButton2::+Insert ;粘贴
#HotIf ingame and WinActive("SYSTEM PURGE ahk_exe SYSTEM_PURGE.exe ahk_class YYGameMakerYY")
k::space
#HotIf ingame and WinActive("TEN ahk_exe TEN.exe ahk_class YYGameMakerYY")
k::w
a::left
d::right
u::e
s::down
i::q
o::s

#HotIf ingame and WinActive("ANIMAL WELL ahk_exe Animal Well.exe ahk_class GameWindow")
k::space
j::x
q::1
e::3
f::z
u::1
o::3
l::3
`;::3
tab::v

#HotIf

#HotIf 0 ; 复制粘贴
XButton1::^Insert ;复制
XButton2::+Insert ;粘贴

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
Left::^!,
Right::^!.
Down::Volume_Down
Up::Volume_Up

#HotIf