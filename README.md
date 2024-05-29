## 安装
- [autohotkey](https://www.autohotkey.com/download/)

## 运行
- main.ahk
- woz.ahk

## 全局设置
> global.ahk
- 锁定`CapsLock`状态,需要按住右`Alt`键+`Capslock`切换大小写状态
- 锁定`NumLock`状态,双击`NumLock``切换状态`
- 将`CapsLock`映射为`esc` (松开时触发)
- 定义一系列快捷键
  - `CapsLock` + ...  
  - `win` + ...  
  - `ctrl` + `j`/`k`/`l`/`w` ...  
  - ...   
- ...


## 特定设置
> 见files/*.ahk
- 定义了在特定窗口生效的一系列快捷键

## 热字串
- 日期时间
  - `]d` :: 当前日期 `YYYY-MM-DD`
  - `]t` :: 当前时间 `hh:mm:ss`
  - `]T` :: 当前日期时间 `YYYY-MM-DD hh:mm:ss`
- 符号 (英文符号后面加`转中文符号)
  - ``` .` ``` :: `。`
  - ``` ,` ``` :: `，`
  - ``` `` ``` :: `、`
- `ch2` `Ch3` ... `ch9` : 选择输入第i个剪贴板历史(调用win+v)
- `CH2` `CH3` ... `CH9` : 将前i个剪贴板历史合并复制到剪贴板


## 输入法相关
> 见ime.ahk
- 左`shift` 强制切换为英文输入法
- 500ms内双击左`shift` 强制切换为中文输入法
- 右`shift` 正常切换中英文
- 中文时输入`jkjk`或按`CapsLock`切换为英文
- 右`shift` + 右`alt` 强制切换为美式键盘
<!-- - `CapsLock` + `NumLock` 全部窗口设置英文输入法 -->

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
> 见woz.ahk - 启发自[wox](http://www.wox.one)的快捷启动器
- 快捷键 `ctrl` + `space`
- 毫秒级响应速度
- 不需要回车确定,唯一匹配命令则执行
- 按 `tab` 执行上一条历史命令
- 全匹配也会执行
- 添加正则匹配支持
- 添加表达式计算支持以 `m ` 开头

## zvim
> 见zvim.ahk - 启发自[win-vind](https://github.com/pit-ray/win-vind)
- 用vim的键位习惯来操作windows鼠标、窗口等。
```c
+------------+       t        +------------+        
| GUI_Normal | <------------> | GUI_Window |        
+------------+                +------------+        
          ^ \                  /                    
     Cap-g \ \                /             
            \ \ i,Cap-i      / i,Cap-i                      
             \ v            v                       
              +-------------+                       
              | GUI_Insert  |(default)              
              +-------------+                       
                   |   ^         
                   |   |Cap-i          
              Cap-v|   |                            
                   v   |      
              +-------------+       
              | Edit_Normal |       
              +-------------+       
              ^ /         \ ^                       
     d,y,p,v / /           \ \ jk,<esc>             
            / / v   i,o,a,C \ \                     
           / v               v \                    
+-------------+      c      +-------------+         
| Edit_Visual | ----------> | Edit_Insert |         
+-------------+             +-------------+
```

- 任何模式下 `Cap-i` 回到 `Insert` 模式

- GUI_Insert mode:
  - 默认模式,不更改任何快捷键

- GUI_Normal mode:
  - `hjkl`, `a-hjkl`, `s-hjkl` 不同速率上下左右移动鼠标
  - `wasd`, `<s-wasd>`, 不同速率上下左右滚动滑轮
  - `n` `q` 鼠标左键, `m` `e` 鼠标右键, `v` 按住左键, `o` 回车
  - `gg`, `G`, `gh`, `gl`, `<sapce>-hjkl` 移动鼠标到最上下左右处
  - `gm`, `zz`，`<c-s-c>` 鼠标居中
  - `:` 命令行模式(设置移动速率等参数)
  - `yy` 复制鼠标位置(底部显示)
  - `-` `=` `<s-->` `<s-=>` `<a-->` `<a-=>` 调节 `对应的hjkl` 移动距离
  - `t` 进入 GUI_Window 模式

- GUI_Window mode:
  - `hjkl`, `<s-hjkl>` 调节当前窗口位置
  - `wasd`, `<s-wasd>` 调节当前窗口大小
  - `m`, `n`, `r`, `c` 最大化,最小化,恢复,居中当前窗口
  - `t` 进入 GUI_Normal 模式

- Edit_Normal mode: (模拟vim Normal模式)
  - (!!通过将按键映射为 `方向键` `home` `end` `ctrl-c,x,v,z,方向键,home,end` 等实现)
  - `hjkl` `wb` `HL` `0$` `gg` `G` `^u` `^d` 移动
  - `x` `D` `C` `u` `p` 操作
  - `y` `d` `c` 等待操作数(oppend模式)
  - `i` `a` `o` `O` `C` `A` `I` 进入insert模式
  - `v` 进入visual模式

- Edit_Insert mode: (模拟vim Insert模式)
  - `jk`, `esc` 进入normal模式

- Edit_Visual mode: (模拟vim Visual模式)
  - `hjkl` `wb` `HL` `0$` `gg` `G` 移动
  - `c` `d` `y` `p` `v` 进入oppend模式(等待操作数), 完成操作后切换到相应模式
  

- Edit_Oppend mode: (模拟vim OperatorPending模式)
  - 支持操作:
   - `yw` `yy` `yj` `yk` `yH` `yL`
   - `dw` `dd` `dj` `dk` `dH` `dL`
   - `cw` `cc` `cj` `ck` `cH` `cL`
  - `esc` 回到Edit_Normal模式