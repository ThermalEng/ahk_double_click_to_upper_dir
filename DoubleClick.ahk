#Requires AutoHotkey v2.0
#SingleInstance Force

; ================== DOUBLE CLICK TO GO BACK (改进版) ==================
~LButton::
{
    static lastTime := 0       ; 上次点击的时间戳
    static lastHwnd := 0       ; 上次点击时的窗口句柄

    ; 获取当前鼠标位置所在的窗口
    MouseGetPos(&x, &y, &currHwnd)

    currTime := A_TickCount
    ; 判断：两次点击间隔小于系统双击阈值、且两次都在同一窗口、且是在资源管理器空白处
    if (currTime - lastTime < DllCall("GetDoubleClickTime"))
        && (currHwnd = lastHwnd)
        && IsExplorerEmptySpace()
    {
        ;MsgBox(currTime . " " . lastTime . " " . currHwnd . " " . lastHwnd . " " . IsExplorerEmptySpace())
        Send("!{Up}")          ; 触发 Alt+Up
        ; 双击处理完，重置状态，避免三击也触发
        lastTime := 0
        lastHwnd := 0
    }
    else
    {
        ; 记录这次点击的上下文，用作下一次判断
        lastTime := currTime
        lastHwnd := currHwnd
    }
    return
}

; 检测当前鼠标下是否是资源管理器的空白列表区
IsExplorerEmptySpace() {
    static ROLE_SYSTEM_LIST := 0x21
    if acc := AccObjectFromPoint()
        try{
        return acc.accRole(0) = ROLE_SYSTEM_LIST
    } catch {
        return false
    }
    
}

; 通过 AccessibleObjectFromPoint 拿到当前鼠标下的 IAccessible 对象
AccObjectFromPoint() {
    static VT_DISPATCH := 9, F_OWNVALUE := 1, h := DllCall("LoadLibrary", "Str", "oleacc", "Ptr")
    DllCall("GetCursorPos", "int64*", &pt:=0)
    varChild := Buffer(8 + 2*A_PtrSize, 0)
    if DllCall("oleacc\AccessibleObjectFromPoint", "Int64", pt, "Ptr*", &pAcc:=0, "Ptr", varChild) = 0
            return ComValue(VT_DISPATCH, pAcc, F_OWNVALUE)
}

