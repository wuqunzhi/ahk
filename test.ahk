; #NoEnv ��v2Ĭ����Ϊ, ���Ը�ָ����Ѿ���ɾ��. �����Ч�����ñ���������, ��ʹ�� EnvGet ����.
; SendMode Ĭ��Ϊ����(Input) �������¼�(Event).
; ����ƥ��ģʽĬ��Ϊ 2 ������ 1.
; ɾ���� SetBatchLines, ������нű�����ȫ������(��ͬ�� v1 �е� SetBatchLines -1).
; SetWorkingDir ����Ŀ¼Ĭ��Ϊ A_ScriptDir. A_InitialWorkingDir ���������� AutoHotkey �Ľ������õĹ���Ŀ¼.
; CoordMode Ĭ��Ϊ Client(�� v1.1.05 ���м���), ������ Window.
; �ű��ļ�(�������� �� �ű���ȡ���ļ�) ��Ĭ�ϱ��������� UTF-8 ������ ANSI(CP0). ����ǰһ��, �����ͨ�� /CP �����п���������.
; #NoTrayIcon ;��������û��SingleInstance,���˳�

#SingleInstance Force
#Warn Unreachable, off
#Include "config.ahk"
#Include "Lib\fun_make.ahk"
SetTitleMatchMode("regex")
; CoordMode("ToolTip", "Screen")
SetMouseDelay(-1)

; SetMouseDelay 0                                           ; SendInput ���ܻή��Ϊ SendEvent, ��ʱ���� 10ms ��Ĭ�� delay
; SetWinDelay 0                                             ; Ĭ�ϻ��� activate, maximize, move �ȴ��ڲ�����˯�� 100ms
; ProcessSetPriority "High"

#SuspendExempt true
f7:: Suspend
#SuspendExempt false

6:: test()
test(){
    ; tip(A_ComSpec)
    run('code D:\vscodeDeemos\Note' )

}

#HotIf 0
Left::^!,
Right::^!.
down::Volume_Down
Up::Volume_Up
Space::^!Space
#HotIf

#HotIf 0
XButton1::^!,
XButton2::^!.
WheelDown::Volume_Down
WheelUp::Volume_Up
MButton::^!Space
LButton:: return
RButton:: return
#HotIf


; 7:: Send("{text}?! ")



; ==========o==========o==========o==========o==========o other
/*
ImageSearch PixelSearch
SoundPlay
A_TickCount ʱ���A_MSecҲ��
ListLines, ListVars
https: // wyagd001.github.io / v2 / docs / Scripts.htm#lib #include�Ϳ��ļ�
; ��Ctrl����סʱ,NumLock����Pause�İ�������,����ʹ��^Pause������^NumLock.
; ����:https://wyagd001.github.io/v2/docs/Scripts.htm#continuation
; ��껬������ ; https://meta.appinn.net/t/topic/32120
; ��������: powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,50)

*/
; ==========o==========o==========o==========o==========o�ļ�
/*
FileReadLine ��ȡ�ļ���
FileRead ��ȡ�ļ�
FileSelect:��ʾ���Ե�ѡ���ļ�/�ļ��еı�׼�Ի���.
iniread , iniwrite ,inidelete ��ȡini��ʽ�ļ�
FileCreateShortcut
FileExist
; ��ȡĿ¼,�ļ���,�ļ���,��չ����:
FullFileName := "C:\My Documents\Address List.txt"
SplitPath FullFileName, &name, &dir, &ext, &name_no_ext, &drive
*/
; ==========o==========o==========o==========o==========o Edit
;  �����еı༭�ؼ��е�����ɾ�����ʵĿ�ݼ�. ûʲô��
; #HotIf ActiveControlIsOfClass("Edit")
; ActiveControlIsOfClass(Cls) {
;     FocusedControl := 0
;     try FocusedControl := ControlGetFocus("A")
;     MsgBox(FocusedControl)
;     FocusedControlClass := ""
;     try FocusedControlClass := WinGetClass(FocusedControl)
;     MsgBox(FocusedControlClass)
;     return (FocusedControlClass = Cls)
; }
; ==========o==========o==========o==========o==========o inputHook
; #inputHook :����һ������, �ö���������ռ������ؼ�������.
; ʾ��1:�ȴ��û���������һ����.
/* MsgBox KeyWaitAny()
MsgBox KeyWaitAny("V")    ; ����һ��, ������ֹ����.
KeyWaitAny(Options := "") {
    ih := InputHook(Options)
    if !InStr(Options, "V")
        ih.VisibleNonText := false
    ih.KeyOpt("{All}", "E")    ; ����
    ih.Start()
    ih.Wait()
    return ih.EndKey    ; ���ذ�������
} */
; ==========o==========o==========o==========o==========o inputHook
/*
https://www.autohotkey.com/board/topic/57245-how-can-i-find-if-other-script-is-pausedsuspended-4-pausing/
OnMessage(0x9999, "CheckPauseSuspend")
Return
CheckPauseSuspend(wParam) {
    If wParam = 1
        Return A_IsSuspended
    else if wParam = 2
        Return A_IsPaused
}
*/

; ==========o==========o==========o==========o==========o gui
/*
MyGui.Add("Link", , 'Links may be used anywhere in the text like <a id="A">this</a> or <a id="B">that</a>')
EditPaste ;ָ�����ַ���ճ���� Edit �ؼ��������(�ı������) ��
EditGetLine ���� Edit �ؼ���ָ���е��ı�.
MyGui := Gui(, "Title of Window")
MyGui.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner")  ; +Owner ������ʾ��������ť.
MyGui.Add("Text",, "Some text to display.")
MyGui.Show("NoActivate")  ; NoActivate �õ�ǰ����ڼ������ֻ״̬.
; ���ļ����л�ȡ�ļ����б������Ƿ��� ListView:
Loop Files, A_MyDocuments "\*.*"
    LV.Add(, A_LoopFileName, A_LoopFileSizeKB)
*/
