strJoin(strs, sep := ", ") {
    res := ""
    for str in strs
        res .= (str . sep)
    return substr(res, 1, -strlen(sep))
}
endwith(abcd, cd) {
    idx := InStr(abcd, cd, true)
    return idx && (idx == StrLen(abcd) - StrLen(cd) + 1)
}
startwith(abcd, ab) {
    return InStr(abcd, ab, true) == 1
}

A_userPath() {
    return SubStr(A_Desktop, 1, StrLen(A_Desktop) - 7)
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