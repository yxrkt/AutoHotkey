;
; Initialization
;

paneWidth := 400

;
; Paste
;

^NumPad1::
PasteText("aserio@blizzard.com")
return

^NumPad2::
PasteText("sc2smurf001@gmail.com")
return

^NumPad3::
PasteText("h4tf4k@gmail.com")
return

^NumPad4::
PasteText("alexserio")
return

^NumPad5::
PasteText("4100390516689235")
return

;
; Window Snap
;

#,::
window := DllCall("GetForegroundWindow")
GetFrameWindowRect(window, frameX, frameY, frameWidth, frameHeight)
WinGetPos, windowX, windowY, windowWidth, windowHeight, A

monitor := DllCall("MonitorFromWindow", "Ptr", window, "UInt", 0)
GetMonitorWorkRect(monitor, workX, workY, workWidth, workHeight)

newX := workX + windowX - frameX
newY := workY + windowY - frameY
newWidth := paneWidth + (windowWidth - frameWidth)
newHeight := workHeight + (windowHeight - frameHeight)

WinRestore, A
WinMove, A, , newX, newY, newWidth, newHeight
return

#.::
window := DllCall("GetForegroundWindow")
GetFrameWindowRect(window, frameX, frameY, frameWidth, frameHeight)
WinGetPos, windowX, windowY, windowWidth, windowHeight, A

monitor := DllCall("MonitorFromWindow", "Ptr", window, "UInt", 0)
GetMonitorWorkRect(monitor, workX, workY, workWidth, workHeight)

newX := workX + paneWidth + (windowX - frameX)
newY := workY + windowY - frameY
newWidth := workWidth - paneWidth + (windowWidth - frameWidth)
newHeight := workHeight + (windowHeight - frameHeight)

WinRestore, A
WinMove, A, , newX, newY, newWidth, newHeight
return

#z::
;  VarSetCapacity(point, 8)
;  NumPut(4000, point, 0, "Int")
;  NumPut(100, point, 4, "Int")
;  monitor := DllCall("MonitorFromPoint", "Ptr", point, "UInt", 0)

window := DllCall("GetForegroundWindow")
monitor := DllCall("MonitorFromWindow", "Ptr", window, "UInt", 0)

MsgBox % monitor
return

;
; Functions
;

PasteText(text)
{
	originalClipboard := ClipBoardAll
	ClipBoard := text
	SendInput ^v
	Sleep 1
	ClipBoard := originalClipboard
	VarSetCapacity(originalClipboard, 0)
}

GetMonitorWorkRect(monitor, ByRef x, ByRef y, ByRef width, ByRef height)
{
	VarSetCapacity(monitorInfo, 40)
	NumPut(40, monitorInfo, 0, "UInt")

	DllCall("GetMonitorInfo", "Ptr", monitor, "Ptr", &monitorInfo)

	left := NumGet(monitorInfo, 20, "Int")
	top := NumGet(monitorInfo, 24, "Int")
	right := NumGet(monitorInfo, 28, "Int")
	bottom := NumGet(monitorInfo, 32, "Int")

	x := left
	y := top
	width := right - left
	height := bottom - top
}

GetFrameWindowRect(window, ByRef x, ByRef y, ByRef width, ByRef height)
{
	VarSetCapacity(rect, 16)
	DllCall("dwmapi\DwmGetWindowAttribute", "Ptr", window, "UInt", 9, "Ptr", &rect, "UInt", 16)
	
	left := NumGet(rect, 0, "Int")
	top := NumGet(rect, 4, "Int")
	right := NumGet(rect, 8, "Int")
	bottom := NumGet(rect, 12, "Int")

	x := left
	y := top
	width := right - left
	height := bottom - top
}