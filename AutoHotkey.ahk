; yukisamaomg

;-------------------------------------------------------------------------------
; Alt-Drag
;-------------------------------------------------------------------------------
#LButton::
XButton1::
XButton2::

CoordMode, Mouse ; Switch to screen/absolute coordinates.
MouseGetPos, VAR_MouseStartX, VAR_MouseStartY, VAR_MouseWin

WinGetPos, VAR_OriginalPosX, VAR_OriginalPosY,,, ahk_id %VAR_MouseWin%
WinGet, VAR_WinState, MinMax, ahk_id %VAR_MouseWin%
if VAR_WinState = 0 ; Only if the window isn't maximized
{
	WinGet VAR_WindowStyle, Style, ahk_id %VAR_MouseWin%
	if !(VAR_WindowStyle & 0xCF0000)
		return
	WinGetTitle, VAR_WindowName, ahk_id %VAR_MouseWin%
	if VAR_WindowName =
		return
	if VAR_WindowName = World of Warcraft
		return
		
	WinActivate, ahk_id %VAR_MouseWin%
	SetTimer, VAR_WatchMouse, 0 ; Track the mouse as the user drags it.
}
return

VAR_WatchMouse:
GetKeyState, VAR_LButtonState, LButton, P
GetKeyState, VAR_XButton1State, XButton1, P
GetKeyState, VAR_XButton2State, XButton2, P
if VAR_LButtonState = U
{
	if VAR_XButton1State = U
	{
		if VAR_XButton2State = U
		{
			SetTimer, VAR_WatchMouse, off
			return
		}
	}
}
GetKeyState, VAR_EscapeState, Escape, P
if VAR_EscapeState = D ; Escape has been pressed, so drag is cancelled.
{
	SetTimer, VAR_WatchMouse, off
	WinMove, ahk_id %VAR_MouseWin%,, %VAR_OriginalPosX%, %VAR_OriginalPosY%
	return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, VAR_MouseX, VAR_MouseY
WinGetPos, VAR_WinX, VAR_WinY,,, ahk_id %VAR_MouseWin%
SetWinDelay, -1 ; Makes the below move faster/smoother.
WinMove, ahk_id %VAR_MouseWin%,, VAR_WinX + VAR_MouseX - VAR_MouseStartX, VAR_WinY + VAR_MouseY - VAR_MouseStartY
VAR_MouseStartX := VAR_MouseX ; Update for the next timer-call to this subroutine.
VAR_MouseStartY := VAR_MouseY
return

;-------------------------------------------------------------------------------
; WinKey+Shift+Down		Minimize
; WinKey+Shift+Up		Restore/Maximize
;-------------------------------------------------------------------------------
#+Down::
WinGet, VAR_WindowID, , A
WinMinimize, ahk_id %VAR_WindowID%
return

#+Up::
WinGet, VAR_WindowState, MinMax, ahk_id %VAR_WindowID%
if VAR_WindowState != 0
{
	WinRestore, ahk_id %VAR_WindowID%
	WinActivate, ahk_id %VAR_WindowID%
}
else
{
	WinMaximize, ahk_id %VAR_WindowID%
}
return

;-------------------------------------------------------------------------------
; Starcraft II
;-------------------------------------------------------------------------------
WinGetTitle, VAR_WindowName, A
if VAR_WindowName = StarCraft II
{
	; Alt+Q, Alt+Q
	;!Q::SendInput, qns{F10}
	GetKeyState, VAR_AltState, Alt, P
	GetKeyState, VAR_QState, Q, P
	if VAR_AltState = D
	{
		if VAR_QState = D
		{
			SendInput, qns{F10}
		}
	}
	return
}

;-------------------------------------------------------------------------------
; Window Manipulation
;-------------------------------------------------------------------------------
#W::
WinClose, A
return

#C::
WinGetPos, VAR_X, VAR_Y, VAR_Width, VAR_Height, A
SysGet, VAR_ScreenRect, MonitorWorkArea, 0
if (VAR_X - VAR_ScreenRectRight) + (VAR_Width / 2) <= 0
{
	WinMove, A,, (VAR_ScreenRectRight - VAR_Width) / 2, (VAR_ScreenRectBottom - VAR_Height) / 2
}
else
{
	SysGet, VAR_ScreenRect, MonitorWorkArea, 1
	VAR_X := VAR_ScreenRectLeft + ((VAR_ScreenRectRight - VAR_ScreenRectLeft) - VAR_Width) / 2
	VAR_Y := VAR_ScreenRectTop + ((VAR_ScreenRectBottom - VAR_ScreenRectTop) - VAR_Height) / 2
	MsgBox % "{Left: " . VAR_ScreenRectLeft . ", Top: " . VAR_ScreenRectTop . ", Right: " . VAR_ScreenRectRight . ", Bottom: " . VAR_ScreenRectBottom . "}"
	;WinMove, A,, VAR_X, VAR_Y
}
return

#A::
WinGetPos, VAR_X, VAR_Y, VAR_Width, , A
SysGet, VAR_ScreenRect, MonitorWorkArea, 0
if (VAR_X - VAR_ScreenRectRight) + (VAR_Width / 2) <= 0
	VAR_Monitor := 0
else
	VAR_Monitor := 1
MsgBox % "Monitor: " . VAR_Monitor
;MsgBox % "{X: " . VAR_X . ", Y: " . VAR_Y . "}"
return

;-------------------------------------------------------------------------------
; Launchers
;-------------------------------------------------------------------------------
^!F::Run "C:\Games\Warcraft III\Frozen Throne.exe"
^!R::Run "C:\Games\Warcraft III\Frozen Throne.exe" -windowed
^!S::Run "C:\Games\StarCraft II\StarCraft II.exe"
^!W::Run "C:\Games\World of Warcraft\Launcher.exe"

;-------------------------------------------------------------------------------
; Misc
;-------------------------------------------------------------------------------
#V::
DllCall("ShowCursor", UINT, 0)
return
#H::
return

;#Z::
;WinGetTitle, VAR_CurWindowName, A
;MsgBox % VAR_CurWindowName
;return

;-------------------------------------------------------------------------------
; Login
;-------------------------------------------------------------------------------
^NumPad1::
SendInput, aserio@blizzard.com
return

^NumPad2::
SendInput, sc2smurf001@gmail.com
return

^NumPad4::
SendInput, alexserio
return

^NumPad5::
SendInput, 4387550003897088
return

#z::
;VarSetCapacity(VAR_Directory, 260)
;DllCall("GetModuleFileName", UInt, 0, Str, VAR_Directory, UInt, 260)
;MsgBox, %VAR_Directory%

VAR_CommandLine := DllCall("GetCommandLine", "Str")
RegExMatch(VAR_CommandLine, "i)(\w:\\[^\""]*\\)[^.""]*.ahk", VAR_ScriptDir)
DllCall(VAR_ScriptDir1 . "PinAssist\MonitorProcesses")
;MsgBox % VAR_ScriptDir1 . "PinAssist\MonitorProcesses"
return















