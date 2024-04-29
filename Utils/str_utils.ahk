swap(&a, &b) {
    tmp := a
    a := b
    b := tmp
}
; 让string支持[]索引,并支持倒着索引
DefProp := {}.GetMethod("DefineProp")
DefProp("".base, "__Item", {
    get: (var, index) =>
        (index := index < 0 ? StrLen(var) + index + 1 : index, SubStr(var, index, 1)),
})

; DelProp := {}.GetMethod("DeleteProp")
; %DelProp%("".base, "__Item")

; 自带的StrSplit会带空字符: StrSplit("a  b",' ') => ["a","","b"]
StrSplitFix(str, Delimiters, omitChars?, maxparts := -1) {
    tmpres := StrSplit(str, Delimiters, omitChars?, maxparts)
    res := []
    for str in tmpres {
        if str != ""
            res.Push(str)
    }
    return res
}
; 自带的StrSplit会带空字符: StrSplit("a  b",' ') => ["a","","b"]
StrSplitFix2(str, Delimiters) {
    res := []
    loop parse str, Delimiters {
        if (A_LoopField == "")
            continue
        res.Push(A_LoopField)
    }
    return res
}
; 统计行数
countLines(str) {
    return StrSplitFix(str, '`n').Length
}
strJoin(strs, sep := ", ") {
    res := ""
    for str in strs
        res .= (str . sep)
    return substr(res, 1, -strlen(sep))
}
reverseList(lst) {
    res := []
    len := lst.Length
    loop lst.Length {
        res.Push(lst[len - A_Index + 1])
    }
    return res
}
startwith(abcd, ab, caseSitive := false) {
    return InStr(abcd, ab, caseSitive) == 1
}
endwith(abcd, cd, caseSitive := false) {
    idx := InStr(abcd, cd, caseSitive)
    return idx && (idx == StrLen(abcd) - StrLen(cd) + 1)
}
endwiths(abcd, strlist, caseSitive := false) {
    for str in strlist
        if (endwith(abcd, str, caseSitive))
            return true
    return false
}
startwiths(abcd, strlist, caseSitive := false) {
    for str in strlist
        if (startwith(abcd, str, caseSitive))
            return true
    return false
}
rtrims(abcd, strlist, caseSitive := false) {
    for str in strlist
        if (endwith(abcd, str, caseSitive))
            if (StrLen(abcd) == StrLen(str))
                return ''
            else
                return SubStr(abcd, 1, StrLen(abcd) - StrLen(str))
    return abcd
}
ltrims(abcd, strlist, caseSitive := false) {
    for str in strlist
        if (startwith(abcd, str, caseSitive))
            if (StrLen(abcd) == StrLen(str))
                return ''
            else
                return SubStr(abcd, StrLen(str) + 1, StrLen(abcd) - StrLen(str))
    return abcd
}
; return str*=num
strdot(str, num) {
    res := ""
    loop (num)
        res .= str
    return res
}
; 取str的指定行
strlines(str, lines*) {
    strlines := StrSplit(str, "`n")
    res := ""
    for line in lines
        res .= strlines[line] . "`n"
    return SubStr(res, 1, -1)
}
; return mod(num, n) + 1
nextn(num, n) {
    ; 0 1 2 3 4 5 =>1 2 3 4 5 1
    return mod(num, n) + 1
}
lastn(num, n) {
    ;0 1 2 3 4 5 =>4 5 1 2 3 4
    res := mod(num, n) - 1
    return res <= 0 ? res + n : res
}
minutes2hhmm(mins) {
    return Format("{:02}:{:02}", mins // 60, mod(mins, 60))
}
seconds2hhmm(seconds) {
    return Format("{:02}:{:02}", seconds // 3600, mod(seconds, 3600) // 60)
}
seconds2hhmmss(seconds) {
    return Format("{:02}:{:02}:{:02}", seconds // 3600, mod(seconds, 3600) // 60, mod(seconds, 60))
}
seconds2mmss(seconds) {
    return Format("{:02}:{:02}", seconds // 60, mod(seconds, 60))
}