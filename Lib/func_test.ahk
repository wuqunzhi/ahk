/*
https://www.autoahk.com/archives/36778
;;下面是三个例子， 分别是普通的， 带文件夹参数的， 和带标准输入的。
sOutput := StdoutToVar_CreateProcess("ipconfig")
sOutput := StdoutToVar_CreateProcess("cmd.exe /c dir", "", "c:")  ;;指定运行目录
sOutput := StdoutToVar_CreateProcess("sort.exe", "", "", "abc`r`nefg`r`nhijk`r`n0123`r`nghjki`r`ndflgkhu`r`n")  ;;标准输入
StdoutToVar_CreateProcess(sCmd, bStream:="", sDir:="", sInput:="") {
   bStream:=   ; not implemented
   hStdInRd:=0
   hStdInWr:=0
   hStdOutWr:=0
   hStdOutRd:=0
   DllCall("CreatePipe","Ptr*",hStdInRd,"Ptr*",hStdInWr,"Uint",0,"Uint",0)
   DllCall("CreatePipe","Ptr*",hStdOutRd,"Ptr*",hStdOutWr,"Uint",0,"Uint",0)
   DllCall("SetHandleInformation","Ptr",hStdInRd,"Uint",1,"Uint",1)
   DllCall("SetHandleInformation","Ptr",hStdOutWr,"Uint",1,"Uint",1)
   if A_PtrSize=4
   {
      VarSetCapacity(pi, 16, 0)
      sisize:=VarSetCapacity(si,68,0)
      NumPut(sisize,    si,  0, "UInt")
      NumPut(0x100,     si, 44, "UInt")
      NumPut(hStdInRd , si, 56, "Ptr")
      NumPut(hStdOutWr, si, 60, "Ptr")
      NumPut(hStdOutWr, si, 64, "Ptr")
   }
   else if A_PtrSize=8
   {
      VarSetCapacity(pi, 24, 0)
      sisize:=VarSetCapacity(si,96,0)
      NumPut(sisize,    si,  0, "UInt")
      NumPut(0x100,     si, 60, "UInt")
      NumPut(hStdInRd , si, 80, "Ptr")
      NumPut(hStdOutWr, si, 88, "Ptr")
      NumPut(hStdOutWr, si, 96, "Ptr")
   }
   DllCall("CreateProcess", "Uint", 0, "Ptr", &sCmd, "Uint", 0, "Uint", 0, "Int", True, "Uint", 0x08000000, "Uint", 0, "Ptr", sDir ? &sDir : 0, "Ptr", &si, "Ptr", &pi)
   DllCall("CloseHandle","Ptr",NumGet(pi,0))
   DllCall("CloseHandle","Ptr",NumGet(pi,A_PtrSize))
   DllCall("CloseHandle","Ptr",hStdOutWr)
   DllCall("CloseHandle","Ptr",hStdInRd)
   If   sInput <>
      FileOpen(hStdInWr, "h", "UTF-8").Write(sInput)
   DllCall("CloseHandle","Ptr",hStdInWr)
   VarSetCapacity(sTemp,4095)
   nSize:=0
   loop
      {
      result:=DllCall("Kernel32.dllReadFile", "Uint", hStdOutRd,  "Ptr", &sTemp, "Uint", 4095,"UintP", nSize,"Uint", 0)
      if (result="0")
         break
      else
         sOutput:= sOutput . StrGet(&sTemp,nSize,"cp936")
      }
   DllCall("CloseHandle","Ptr",hStdOutRd)
   Return,sOutput
}
*/