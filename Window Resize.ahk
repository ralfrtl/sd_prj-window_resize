;	[! alt]    [^ ctrl]    [+ shift]    [$ raw]

#singleinstance force
Menu, tray, icon, ddores.dll, 100
CoordMode, ToolTip, Window
CoordMode, Mouse, Screen

Global MWL			; Monitor working area left
Global MWT			; Monitor working area top
Global MWR			; Monitor working area right
Global MWB			; Monitor working area bottom
Global MWW			; Monitor working width
Global MWH			; Monitor working height
Global MDS := 30	; Margin default size
Global M := MDS		; Margin
Global RW := 14		; Ratio width
Global RH := 9		; Ratio height

^#!Delete::Run, *RunAs "C:\Program Files Portable\AHK\Window Resize.ahk"

#RButton::ShowMenu(True, True)
#^RButton::ShowMenu(False, True)
#<!Space::ShowMenu(True, False)
#<!^Space::ShowMenu(False, False)

;#>^Space::Run, "c:\program files\autohotkey\windowspy.ahk"
;#>^Escape::Suspend

; Immedietly maximize a minimized window
#^Up::
	if IsNotExplorer() {
		WinMaximize, a
	}
	Return

; Immedietly minimize a maximized window
#^Down::
	if IsNotExplorer() {
		WinMinimize, a
	}
	Return

;;;
#F1::
	If IsNotExplorer() {
		GetMonitorRectFromCursor(MWL, MWT, MWR, MWB, MWW, MWH) s1()
	}
    Return
#F2::
	If IsNotExplorer() {
		GetMonitorRectFromCursor(MWL, MWT, MWR, MWB, MWW, MWH) s2()
	}
    Return
#F3::
	If IsNotExplorer() {
		GetMonitorRectFromCursor(MWL, MWT, MWR, MWB, MWW, MWH) s3()
	}
    Return
#F4::
	If IsNotExplorer() {
		GetMonitorRectFromCursor(MWL, MWT, MWR, MWB, MWW, MWH) center()
	}
    Return
;;;

s1() {
	exact(M, M, Floor(1366 * 0.6), Floor((1366 * 0.6) / RW) * RH)
}
s2() {
	exact(M, M, Floor(1366 * 0.65), Floor((1366 * 0.65) / RW) * RH)
}
s3() {
	exact(M, M, Floor(1366 * 0.7), Floor((1366 * 0.7) / RW) * RH)
}
exact(X, Y, W, H) {
	WinRestore, a
	WinMove, a
		   ,
		   , RealX(MWL + X)
		   , MWT + Y
		   , RealW(W)
		   , RealH(H)
}
center() {
	WinRestore, a
	WinGetPos, x, y, w, h, a
	WinMove, a
		   ,
		   , RealX(MWL + Floor((MWW - w) / 2))
		   , MWT + Floor((MWH - h) / 2)
}

l25() {
	WinRestore, a
	WinMove, a
		   ,
		   , RealX(MWL + M)
		   , MWT + M
		   , RealW(Floor(MWW * 0.25) - M)
		   , RealH(MWH - (M * 2))
}
l75() {
	WinRestore, a
	WinMove, a
		   ,
		   , RealX(MWL + M)
		   , MWT + M
		   , RealW(Floor(MWW * 0.75) - (M * 2))
		   , RealH(MWH - (M * 2))
}

r25() {
	WinRestore, a
	WinMove, a
		   ,
		   ,
		   ,
		   , RealW(Floor(MWW * 0.25) - M)
		   , RealH(MWH - (M * 2))
	GetClientRect(x,y,w,h)
	WinMove, a
		   ,
		   , RealX(MWR - w - M)
		   , MWT + M
}
r75() {
	WinRestore, a
	WinMove, a
		   ,
		   ,
		   ,
		   , RealW(Floor(MWW * 0.75) - (M * 2))
		   , RealH(MWH - (M * 2))
	GetClientRect(x,y,w,h)
	WinMove, a
		   ,
		   , RealX(MWR - w - M)
		   , MWT + M
}

t40() {
	WinRestore, a
	WinMove, a
		   ,
		   , RealX(MWL + M)
		   , MWT + M
		   , RealW(MWW - (M * 2))
		   , RealH(Floor(MWH * 0.4) - M)
}
t60() {
	WinRestore, a
	WinMove, a
		   ,
		   , RealX(MWL + M)
		   , MWT + M
		   , RealW(MWW - (M * 2))
		   , RealH(Floor(MWH * 0.6) - (M * 2))
}

b40() {
	WinRestore, a
	WinMove, a
		   ,
		   ,
		   ,
		   , RealW(MWW - (M * 2))
		   , RealH(Floor(MWH * 0.4) - M)
	GetClientRect(x,y,w,h)
	WinMove, a
		   ,
		   , RealX(MWL + M)
		   , MWB - h - M
}
b60() {
	WinRestore, a
	WinMove, a
		   ,
		   ,
		   ,
		   , RealW(MWW - (M * 2))
		   , RealH(Floor(MWH * 0.6) - (M * 2))
	GetClientRect(x,y,w,h)
	WinMove, a
		   ,
		   , RealX(MWL + M)
		   , MWB - h - M
}

GetMonitorRect(ByRef ML, ByRef MT, ByRef MR, ByRef MB, ByRef MW, ByRef MH) {
	WinGetActiveTitle, at
	WinHandle := WinExist(at)
	VarSetCapacity(MonitorInfo, 40), NumPut(40, MonitorInfo)

	IF (MonitorHandle		:= DllCall("MonitorFromWindow", "Ptr", WinHandle, "UInt", 0x2)) && DllCall("GetMonitorInfo", "Ptr", MonitorHandle, "Ptr", &MonitorInfo) {
		ML := NumGet(MonitorInfo, 20, "Int")
		MT := NumGet(MonitorInfo, 24, "Int")
		MR := NumGet(MonitorInfo, 28, "Int")
		MB := NumGet(MonitorInfo, 32, "Int")
	}
	
	MW := MR - ML
	MH := MB - MT

	;MsgBox, % ML " " MT " " MR " " MB " "
}

GetMonitorRectFromCursor(ByRef ML, ByRef MT, ByRef MR, ByRef MB, ByRef MW, ByRef MH) {
	SysGet, mc, MonitorCount

	Loop, %mc% {
		SysGet, mn, Monitor, %A_Index%
		MouseGetPos, mx, my
		IF (mnLeft < mx AND mnRight > mx AND mnTop < my AND mnBottom > my) {
			SysGet, mi, MonitorWorkArea, %A_Index%
			ML := miLeft
			MT := miTop
			MR := miRight
			MB := miBottom
			MW := MR - ML
			MH := MB - MT
			Break
		}
	}
}

GetClientRect(ByRef CX, ByRef CY, ByRef CW, ByRef CH) {
	WinGetActiveTitle, at
	WinHandle := WinExist(at)
	VarSetCapacity(RECT, 16, 0)
	DllCall("user32\GetClientRect", Ptr, WinHandle, Ptr, &RECT)
	DllCall("user32\ClientToScreen", Ptr, WinHandle, Ptr, &RECT)
	CX := NumGet(&RECT, 0, "Int")
	CY := NumGet(&RECT, 4, "Int")
	CW := NumGet(&RECT, 8, "Int")
	CH := NumGet(&RECT, 12, "Int")
}

InitializeComponents() {
	Menu, Menu, Add
	Menu, Menu, DeleteAll

	Menu, preset, Add, size 1, MenuHandler
	Menu, preset, Add, size 2, MenuHandler
	Menu, preset, Add, size 3, MenuHandler
	Menu, preset, Add, center, MenuHandler
	Menu, Menu, Add, preset, :preset

	Menu, Menu, Add

	Menu, left, Add, 25`%, MenuHandler
	Menu, left, Add, 75`%, MenuHandler
	Menu, Menu, Add, left, :left

	Menu, right, Add, 25`%, MenuHandler
	Menu, right, Add, 75`%, MenuHandler
	Menu, Menu, Add, right, :right

	Menu, top, Add, 40`%, MenuHandler
	Menu, top, Add, 60`%, MenuHandler
	Menu, Menu, Add, top, :top

	Menu, bottom, Add, 40`%, MenuHandler
	Menu, bottom, Add, 60`%, MenuHandler
	Menu, Menu, Add, bottom, :bottom
}

ShowMenu(isMargin, onCursor) {
	IF IsNotExplorer() {
		InitializeComponents()

		IF (isMargin) {
			M := MDS
		} ELSE {
			M := 0
		}

		IF (onCursor) {
			GetMonitorRectFromCursor(MWL, MWT, MWR, MWB, MWW, MWH)
			Menu, Menu, show
		} ELSE {
			GetMonitorRect(MWL, MWT, MWR, MWB, MWW, MWH)
			Menu, Menu, show, 0, 0
		}
	}

	M := MDS
}

MenuHandler() {
	IF (a_thismenu == "preset") {
		IF (a_thismenuitem == "size 1") {
			s1()
		} ELSE IF (a_thismenuitem == "size 2"){
			s2()
		} ELSE IF (a_thismenuitem == "size 3") {
			s3()
		} ELSE IF (a_thismenuitem == "center") {
			center()
		}
	} ELSE IF (a_thismenu == "left") {
		IF (a_thismenuitem == "25%") {
			l25()
		} ELSE IF (a_thismenuitem == "75%") {
			l75()
		}
	} ELSE IF (a_thismenu == "right") {
		IF (a_thismenuitem == "25%") {
			r25()
		} ELSE IF (a_thismenuitem == "75%") {
			r75()
		}
	} ELSE IF (a_thismenu == "top") {
		IF (a_thismenuitem == "40%") {
			t40()
		} ELSE IF (a_thismenuitem == "60%") {
			t60()
		}
	} ELSE IF (a_thismenu == "bottom") {
		IF (a_thismenuitem == "40%") {
			b40()
		} ELSE IF (a_thismenuitem == "60%") {
			b60()
		}
	}
}

IsNotExplorer() {
	IF WinActive("ahk_class Shell_TrayWnd") OR WinActive("ahk_class WorkerW") OR WinActive("ahk_class NotifyIconOverflowWindow") OR WinActive("ahk_exe SearchUI.exe") OR WinActive("ahk_class Windows.UI.Core.CoreWindow") {
		Return False
	}
	ELSE {
		Return True
	}
}

RealX(x) {
	WinGetPos, wx, wy, ww, wh, a
	GetClientRect(cx, cy, cw, ch)
	Return x + ((cw - ww) / 2)
}

RealY(y) {
	Return y
}

RealW(w) {
	WinGetPos, wx, wy, ww, wh, a
	GetClientRect(cx, cy, cw, ch)
	Return w - (cw - ww)
}

RealH(h) {
	WinGetPos, wx, wy, ww, wh, a
	GetClientRect(cx, cy, cw, ch)
	Return h - (ch - wh)
}
