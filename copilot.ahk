#Requires AutoHotkey v2.0
;#NoTrayIcon
#SingleInstance
; rebind copilot to rCtrl

global CopilotActive := false

*<+<#F23::
{
    CopilotActive := true
    Send("{Blind}{LWin Up}{LShift Up}{RControl Down}")
    KeyWait("F23")
    Send("{RControl Up}")
    CopilotActive := false
    Return
}

LShift Up::
{
    if CopilotActive
        Return
    ;else Send("{RShift Up}")
}
