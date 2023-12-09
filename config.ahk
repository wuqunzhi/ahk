global ingame := 0
global win_steam := "Steam ahk_exe steamwebhelper.exe ahk_class SDL_app"               ; steam
global win_woz := "woz.ahk ahk_exe AutoHotkey64.exe ahk_class AutoHotkeyGUI"           ; woz
global win_chrome := "^.+.*$ ahk_exe chrome.exe ahk_class Chrome_WidgetWin_1"          ; chrome
global win_edge := "ahk_exe msedge.exe ahk_class Chrome_WidgetWin_1"                   ; edge
global win_vscode := "ahk_exe Code.exe ahk_class Chrome_WidgetWin_1"                   ; vscode
global win_vscodeNote := "^Note - .* - Visual Studio Code.*$ " win_vscode              ; vscodeNote
global win_wechat := "ahk_exe WeChat.exe ahk_class WeChatMainWndForPC"                 ; weChat
global win_obsidian := "ahk_exe Obsidian.exe ahk_class Chrome_WidgetWin_1"             ; obsidian
global win_youdao := "ahk_exe YoudaoDict.exe ahk_class YodaoMainWndClass"              ; youdao
global win_cmd := "ahk_exe cmd.exe ahk_class ConsoleWindowClass"                       ; cmd
global win_wt := "ahk_exe WindowsTerminal.exe ahk_class CASCADIA_HOSTING_WINDOW_CLASS" ; Windows Ternimal
global win_idea := "ahk_exe idea64.exe"                                                ; idea
global win_vim := "ahk_exe vim.exe"                                                    ; vim
global win_desktop := "ahk_exe explorer.exe ahk_class WorkerW"                         ; 桌面
global win_taskbar := "ahk_exe explorer.exe ahk_class Shell_TrayWnd"                   ; 任务栏
global win_explorer := "ahk_exe explorer.exe ahk_class CabinetWClass"                  ; 资源管理器
global win_taskManager := "ahk_exe Taskmgr.exe ahk_class TaskManagerWindow"            ; 任务管理器
global win_cloudmusic := "ahk_exe cloudmusic.exe ahk_class OrpheusBrowserHost"         ; 网易云
global win_cloudmusicLyric := "ahk_exe cloudmusic.exe ahk_class DesktopLyrics"
global win_qqmusic := "^(?!桌面歌词).*$ ahk_exe QQMusic.exe ahk_class TXGuiFoundation"  ; qq音乐
global win_qqmusicLyric := "桌面歌词 ahk_exe QQMusic.exe ahk_class TXGuiFoundation"
global win_clash := "Clash for Windows ahk_exe Clash for Windows.exe"                  ; clash for windows
global win_remote := "ahk_exe mstsc.exe ahk_class TscShellContainerClass"              ; 远程控制
global A_desktop2 := "E:\桌面2"
global A_userpath := SubStr(A_Desktop, 1, StrLen(A_Desktop) - 7)
global A_TaskbarHeight := 50
global A_CWD := 'D:\vscodeProjects\ahk'
global shortName := Map(
    "qm", "QQMusic.exe",
    "wyy", "cloudmusic.exe",
    "wx", "WeChat.exe",
    "clash", "Clash for Windows.exe",
    "yd", "YoudaoDict.exe",
)