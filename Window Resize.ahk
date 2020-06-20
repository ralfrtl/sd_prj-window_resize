;	[! alt]    [^ ctrl]    [+ shift]    [$ raw]

#singleinstance force
menu, tray, icon, shell32.dll, 35

global mwl			;	monitor working area left
global mwt			;	monitor working area top
global mwr			;	monitor working area right
global mwb			;	monitor working area bottom
global mw			;	monitor width
global mh			;	monitor height
global b			;	border section size
global s			;	sizable section size
global m			;	margin
global rw := 14		;	ratio width
global rh := 9		;	ratio height

rcontrol & ralt::send, +{f10}			;	right click
#^down::winminimize, a					;	minimize

+scrolllock::send, #!{Numpad5}			;	obs mute mic
+pause::send, #!{Numpad8}#!{Numpad9}	;	obs show fg image
scrolllock::send, #!{NumpadDiv}			;	discord mute mic
pause::send, #!{NumpadMult}				;	discord show overlay

#rbutton::showmenu(true, true)
#^rbutton::showmenu(false, true)
#<!space::showmenu(true, false)
#<!^space::showmenu(false, false)

#>^space::run, "c:\program files\autohotkey\windowspy.ahk"
#>!space::suspend

s1() {
	winrestore, a
	winmove, a,, realx(mwl) + m
				  , mwt + m
				  , realw(mw * 0.6)
				  , realh(((mw * 0.6) / rw) * rh)
}
s2() {
	winrestore, a
	winmove, a,, realx(mwl) + m
				  , mwt + m
				  , realw(mw * 0.65)
				  , realh(((mw * 0.65) / rw) * rh)
}
s3() {
	winrestore, a
	winmove, a,, realx(mwl) + m
				  , mwt + m
				  , realw(mw * 0.7)
				  , realh(((mw * 0.7) / rw) * rh)
}
center() {
	winrestore, a
	wingetpos, x, y, w, h, a
	winmove, a,, mwl + ((mw - w) / 2)
			   , mwt + ((mh - h) / 2)
}

l25() {
	wingetactivetitle, at
	winrestore, %at%
	winmove, %at%,, realx(mwl) + m
				  , mwt + m
				  , realw(floor(mw * 0.25)) - m
				  , realh(mh) - m - m
}
l75() {
	wingetactivetitle, at
	winrestore, %at%
	winmove, %at%,, realx(mwl) + m
				  , mwt + m
				  , realw(mw - floor(mw * 0.25)) - m - m
				  , realh(mh) - m - m
}

r25() {
	wingetactivetitle, at
	winrestore, %at%
	winmove, %at%,, ;realx(mwr - floor(mw * 0.25))
				  , mwt + m
				  , realw(floor(mw * 0.25)) - m
				  , realh(mh) - m - m
	wingetpos,,, w,, %at%
	winmove, %at%,, mwr - w + s - b - m
}
r75() {
	wingetactivetitle, at
	winrestore, %at%
	winmove, %at%,, ;mwl + realx(floor(mw * 0.25)) + m
				  , mwt + m
				  , realw(mw - floor(mw * 0.25)) - m - m
				  , realh(mh) - m - m
	wingetpos,,, w,, %at%
	winmove, %at%,, mwr - w + s - b - m
}

t40() {
	wingetactivetitle, at
	winrestore, %at%
	winmove, %at%,, realx(mwl) + m
				  , mwt + m
				  , realw(mw) - m - m
				  , realh(floor(mh * 0.4)) - m
}
t60() {
	wingetactivetitle, at
	winrestore, %at%
	winmove, %at%,, realx(mwl) + m
				  , mwt + m
				  , realw(mw) - m - m
				  , realh(mh - floor(mh * 0.4)) - m - m
}

b40() {
	wingetactivetitle, at
	winrestore, %at%
	winmove, %at%,, realx(mwl) + m
				  , ;mwb - floor(mh * 0.4)
				  , realw(mw) - m - m
				  , realh(floor(mh * 0.4)) - m
	wingetpos,,,, h, %at%
	winmove, %at%,,, mwb - h + s - b - m
}
b60() {
	wingetactivetitle, at
	winrestore, %at%
	winmove, %at%,, realx(mwl) + m
				  , ;mwt + floor(mh * 0.4) + m
				  , realw(mw) - m - m
				  , realh(mh - floor(mh * 0.4)) - m - m
	wingetpos,,,, h,, %at%
	winmove, %at%,,, mwb - h + s - b - m
}

getmonitorinfo() {
	wingetactivetitle, at
	winhandle := winexist(at)
	varsetcapacity(monitorinfo, 40), numput(40, monitorinfo)

	if (monitorhandle		:= dllcall("MonitorFromWindow", "Ptr", winHandle, "UInt", 0x2)) && DllCall("GetMonitorInfo", "Ptr", monitorHandle, "Ptr", &monitorInfo) {
		; monitor left		:= numget(monitorInfo,  4, "int")
		; monitor top		:= numget(monitorInfo,  8, "int")
		; monitor right		:= numget(monitorInfo, 12, "int")
		; monitor bottom	:= NumGet(monitorInfo, 16, "int")
		mwl					:= numget(monitorInfo, 20, "int")
		mwt					:= numget(monitorInfo, 24, "int")
		mwr					:= numget(monitorInfo, 28, "int")
		mwb					:= numget(monitorInfo, 32, "int")
		; is  monitor primary	:= numget(monitorInfo, 36, "int") & 1
	}
	
	mw := mwr - mwl
	mh := mwb - mwt

	sysget, b, 5
	sysget, s, 32
}

getclientrect(){
	wingetactivetitle, at
	winhandle := winexist(at)
	
	WinGetPos, Win_X, Win_Y, Win_W, Win_H, a

	VarSetCapacity(RECT, 16, 0)
	DllCall("user32\GetClientRect", Ptr, winHandle, Ptr,&RECT)
	DllCall("user32\ClientToScreen", Ptr, winHandle, Ptr,&RECT)
	Win_Client_X := NumGet(&RECT, 0, "Int")
	Win_Client_Y := NumGet(&RECT, 4, "Int")
	Win_Client_W := NumGet(&RECT, 8, "Int")
	Win_Client_H := NumGet(&RECT, 12, "Int")

	msgbox, % ""
	. Win_X " - " Win_y " - " Win_w " - " Win_h    "`r`n"
	. "`r`n"
	. Win_Client_X " - " Win_Client_y " - " Win_Client_w " - " Win_Client_h    "`r`n"
}

initializecomponents() {
	menu, menu, add
	menu, menu, deleteall

	menu, preset, add, size 1, menuhandler
	menu, preset, add, size 2, menuhandler
	menu, preset, add, size 3, menuhandler
	menu, preset, add, center, menuhandler
	menu, menu, add, preset, :preset

	menu, menu, add

	menu, left, add, 25`%, menuhandler
	menu, left, add, 75`%, menuhandler
	menu, menu, add, left, :left

	menu, right, add, 25`%, menuhandler
	menu, right, add, 75`%, menuhandler
	menu, menu, add, right, :right

	menu, top, add, 40`%, menuhandler
	menu, top, add, 60`%, menuhandler
	menu, menu, add, top, :top

	menu, bottom, add, 40`%, menuhandler
	menu, bottom, add, 60`%, menuhandler
	menu, menu, add, bottom, :bottom
}

showmenu(ismargin, oncursor) {
	if winactive("ahk_class Shell_TrayWnd") or winactive("ahk_exe SearchUI.exe") or winactive("ahk_class Windows.UI.Core.CoreWindow"){
	} else {
		getmonitorinfo()

		if (ismargin) {
			m := mw / 48
		} else {
			m := 0
		}

		initializecomponents()

		if (oncursor) {
			menu, menu, show
		} else {
			menu, menu, show, 0, 0
		}
	}
}

menuhandler() {
	if (a_thismenu == "preset") {
		if (a_thismenuitem == "size 1") {
			s1()
		} else if (a_thismenuitem == "size 2"){
			s2()
		} else if (a_thismenuitem == "size 3") {
			s3()
		} else if (a_thismenuitem == "center") {
			center()
		}
	} else if (a_thismenu == "left") {
		if (a_thismenuitem == "25%") {
			l25()
		} else if (a_thismenuitem == "75%") {
			l75()
		}
	} else if (a_thismenu == "right") {
		if (a_thismenuitem == "25%") {
			r25()
		} else if (a_thismenuitem == "75%") {
			r75()
		}
	} else if (a_thismenu == "top") {
		if (a_thismenuitem == "40%") {
			t40()
		} else if (a_thismenuitem == "60%") {
			t60()
		}
	} else if (a_thismenu == "bottom") {
		if (a_thismenuitem == "40%") {
			b40()
		} else if (a_thismenuitem == "60%") {
			b60()
		}
	}
}

realx(x) {
	getmonitorinfo()
	return x - s + b
}

realw(w) {
	getmonitorinfo()
	return w + s + s - b - b
}

realh(h) {
	getmonitorinfo()
	return h + s - b
}
