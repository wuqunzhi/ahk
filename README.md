## autohotkey安装

## 运行
main.ahk
woz.ahk

## 全局设置
> global.ahk
- 锁定`CapsLock`状态,需要按住右`Alt`键+`Capslock`切换大小写状态
- 锁定`NumLock`状态,需要按住右`Alt`键+`NumLock`切换NumLock状态   

`CapsLock` + ...  
`win` + ...  
`ctrl` + `j`/`k`/`l`/`w` ...  
...  
...  


## 特定设置
> 见files/*.ahk

## 输入法相关
> 见ime.ahk
- 左`shift` 强制切换为英文输入法
- 500ms内双击左`shift` 强制切换为中文输入法
- 右`shift` 强制切换为中文输入法
- 右`shift` + 右`alt` 强制切换为美式键盘
- `CapsLock` + `NumLock` 全部窗口设置英文
- 中文时输入`jkjk`或按`CapsLock`切换为英文

## 鼠标滚轮
> 见wheel.ahk
- 鼠标在任务栏时滚轮调节音量
- 鼠标在任务栏最右边时滚轮调节亮度
- `win` + 滚轮 调节当前窗口透明度
- `shift` + `NumLock` + 滚轮 调节鼠标移动速度

## 剪贴板历史
> 见clipboard.ahk
- 自动记录最多99条剪贴板历史到数组
- `CapsLock` + `c` 将剪贴板历史数组写入文件并用vscode打开
- 热字串`ch2` `Ch3` ... `ch9` 选择输入第i个剪贴板历史
- 热字串`CH2` `CH3` ... `CH9` 将前i个剪贴板历史合并复制到剪贴板

## woz
> 见woz.ahk
仿wox的快捷启动器
- 快捷键 ctrl space
- 不需要回车确定,唯一匹配命令则执行
- 输入tab执行上一条历史命令
- 全匹配也会执行

## zvim
> 见zvim.ahk - 启发至[win-vind](https://github.com/pit-ray/win-vind)
- 用vim的键位习惯来操作windows鼠标、窗口等。



