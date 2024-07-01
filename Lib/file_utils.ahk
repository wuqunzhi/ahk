; 获取dir下所有文件 目前需要加通配符例如
; C:\Users\79481\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\\*
getfiles(dir, mode := "") {
    ; dir := A_Desktop . "\桌面2\*"
    ; https://wyagd001.github.io/v2/docs/lib/LoopFiles.htm
    res := []
    loop files dir, mode {
        res.Push(A_LoopFileName)
    }
    return res
}

code(path) {
    run('Code.exe ' path), tip.LB("run Code " path)
}
createNotepad() {
    filepath := (Format("{}/tmp_{}{}{}{}{}{}.txt", A_Desktop, A_YYYY, A_MM, A_DD, A_Hour, A_Min, A_Sec))
    f := FileOpen(filepath, "w", "utf-8")
    f.Close()
    Run("notepad " filepath)
}
createWord() {
    filepath := (Format("{}/tmp_{}{}{}{}{}{}.docx", A_Desktop, A_YYYY, A_MM, A_DD, A_Hour, A_Min, A_Sec))
    f := FileOpen(filepath, "w", "utf-8")
    f.Close()
    Run("word " filepath)
}

; 整理桌面
fclear() {
    ; https://wyagd001.github.io/v2/docs/lib/FileMove.htm
    ; tmptxts := getfiles(A_Desktop '/tmp_2024??????????.txt')
    FileMove(A_Desktop '/tmp_2024??????????.txt', A_Desktop '/tmps ')
    FileMove(A_Desktop '/tmp_2024??????????.docx', A_Desktop '/tmps ')
    ; if (MsgBox("是否清空回收站?", "", 1) = "ok")
    ; FileRecycleEmpty(), tip.LB("FileRecycleEmpty")
}