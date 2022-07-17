; Using a Joystick as a Mouse
; https://www.autohotkey.com
; This script converts a joystick into a three-button mouse.  It allows each
; button to drag just like a mouse button and it uses virtually no CPU time.
; Also, it will move the cursor faster depending on how far you push the joystick
; from center. You can personalize various settings at the top of the script.

; Increase the following value to make the mouse cursor move faster:
JoyMultiplier = 0.20

; Decrease the following value to require less joystick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your joystick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered joystick could use a value of 1:
JoyThreshold = 3

; Change the following to true to invert the Y-axis, which causes the mouse to
; move vertically in the direction opposite the stick:
InvertYAxis := false

; Change these values to use joystick button numbers other than 1, 2, and 3 for
; the left, right, and middle mouse buttons.  Available numbers are 1 through 32.
; Use the Joystick Test Script to find out your joystick's numbers more easily.
ButtonLeft = 5


ButtonRight = 10
ButtonMiddle = 11


; If your joystick has a POV control, you can use it as a mouse wheel.  The
; following value is the number of milliseconds between turns of the wheel.
; Decrease it to have the wheel turn faster:
WheelDelay = 75

; If your system has more than one joystick, increase this value to use a joystick
; other than the first:
JoystickNumber = 1

; END OF CONFIG SECTION -- Don't change anything below this point unless you want
; to alter the basic nature of the script.

#SingleInstance force

JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%ButtonLeft%, ButtonLeft
Hotkey, %JoystickPrefix%%ButtonRight%, ButtonRight
Hotkey, %JoystickPrefix%%ButtonMiddle%, ButtonMiddle

; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
	YAxisMultiplier = -1
else
	YAxisMultiplier = 1

SetTimer, WatchJoystick, 10  ; Monitor the movement of the joystick.

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo
IfInString, JoyInfo, P  ; Joystick has POV control, so use it as a mouse wheel.
	SetTimer, MouseWheel, %WheelDelay%

return  ; End of auto-execute section.


; The subroutines below do not use KeyWait because that would sometimes trap the
; WatchJoystick quasi-thread beneath the wait-for-button-up thread, which would
; effectively prevent mouse-dragging with the joystick.

ButtonLeft:
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
	SetTimer, WaitForLeftButtonUp, 10
	return

ButtonRight:
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseClick, right,,, 1, 0, D  ; Hold down the right mouse button.
	SetTimer, WaitForRightButtonUp, 10
	return

ButtonMiddle:
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseClick, middle,,, 1, 0, D  ; Hold down the right mouse button.
	SetTimer, WaitForMiddleButtonUp, 10
	return

WaitForLeftButtonUp:
	if GetKeyState(JoystickPrefix . ButtonLeft)
		return  ; The button is still, down, so keep waiting.
	; Otherwise, the button has been released.
	SetTimer, WaitForLeftButtonUp, Off
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseClick, left,,, 1, 0, U  ; Release the mouse button.
	return

WaitForRightButtonUp:
	if GetKeyState(JoystickPrefix . ButtonRight)
		return  ; The button is still, down, so keep waiting.
	; Otherwise, the button has been released.
	SetTimer, WaitForRightButtonUp, Off
	MouseClick, right,,, 1, 0, U  ; Release the mouse button.
	return

WaitForMiddleButtonUp:
	if GetKeyState(JoystickPrefix . ButtonMiddle)
		return  ; The button is still, down, so keep waiting.
	; Otherwise, the button has been released.
	SetTimer, WaitForMiddleButtonUp, Off
	MouseClick, middle,,, 1, 0, U  ; Release the mouse button.
	return

WatchJoystick:
	MouseNeedsToBeMoved := false  ; Set default.
	SetFormat, float, 03
	GetKeyState, JoyX, %JoystickNumber%JoyX
	GetKeyState, JoyY, %JoystickNumber%JoyY
	if JoyX > %JoyThresholdUpper%
	{
		MouseNeedsToBeMoved := true
		DeltaX := JoyX - JoyThresholdUpper
	}
	else if JoyX < %JoyThresholdLower%
	{
		MouseNeedsToBeMoved := true
		DeltaX := JoyX - JoyThresholdLower
	}
	else
		DeltaX = 0
	if JoyY > %JoyThresholdUpper%
	{
		MouseNeedsToBeMoved := true
		DeltaY := JoyY - JoyThresholdUpper
	}
	else if JoyY < %JoyThresholdLower%
	{
		MouseNeedsToBeMoved := true
		DeltaY := JoyY - JoyThresholdLower
	}
	else
		DeltaY = 0
	if MouseNeedsToBeMoved
	{
		SetMouseDelay, -1  ; Makes movement smoother.
		MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
	}
	return





MouseWheel:
	GetKeyState, JoyPOV, %JoystickNumber%JoyPOV
	if JoyPOV = -1  ; No angle.
		return
	if (JoyPOV =0)  ; pov up
		Send {WheelUp}
	else if JoyPOV = 18000 ; pov down
		Send {WheelDown}
		else if JoyPOV = 27000  ; pov left
		Send {F13} ;escape
		else if JoyPOV =9000  ; pov right
		Send {numpad1} ;copy
	return



	

Joy1::
	send, ^{tab}                         ;chrome_tab_forward. 
	return

Joy2:: MButton

Joy3:: LButton

Joy4::
	send, ^+{tab}                           ;chrome_tab_forward. 
	return


;Joy5:: is a left click button by defult 


Joy6:: ; keyboard arrow right
	Send {right down}
	KeyWait %A_ThisHotkey%, T0.5  ; Adjust 0.5 to be the seconds prior to repeat.
	if not ErrorLevel  ; The joystick button was released prior to the delay period.if not ErrorLevel  ; The joystick button was released prior to the delay period.if not ErrorLevel  ; The joystick button was released prior to the delay period.
	{
		Send {right up}  ; No auto-repeat.
		return
	}
	; Since above didn't return, KeyWait timed out, meaning user is holding down the button.
	Loop
	{
		Send {right down}  ; Auto-repeat consists of consecutive down-events (no up events).
		Sleep 30  ; Adjust 30 to be the milliseconds between repeats.
		if not GetKeyState(A_ThisHotkey)  ; Joystick button has been released.
		{
			Send {right up}
			return
		}
		; Otherwise, user is still holding down the button, so continue looping.
	}
	return

Joy7:: Send, ^v
	return


Joy8:: ;keyboard arrow left
	Send {left down}
	KeyWait %A_ThisHotkey%, T0.5  ; Adjust 0.5 to be the seconds prior to repeat.
	if not ErrorLevel  ; The joystick button was released prior to the delay period.
	{
		Send {left up}  ; No auto-repeat.
		return
	}
	; Since above didn't return, KeyWait timed out, meaning user is holding down the button.
	Loop
	{
		Send {left down}  ; Auto-repeat consists of consecutive down-events (no up events).
		Sleep 30  ; Adjust 30 to be the milliseconds between repeats.
		if not GetKeyState(A_ThisHotkey)  ; Joystick button has been released.
		{
			Send {left up}
			return
		}
		; Otherwise, user is still holding down the button, so continue looping.
	}
	return

Joy9::
	Reload
	return

; Joy10:: right button by deafult

; Joy11:: middle button by deafult


Joy12:: send, ^w ;for close tab
	return



























#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


Numpad0::Alt
return

numpad1::
	send ^c        
	return

!Numpad1::
	send ^x
	return

Numpad2::
	send, ^v
	return

!Numpad2::
	send, {Alt Down}{Tab}{Alt Up}          ;Toggle_two_windows_tabs.
	return


Numpad3::Volume_Up
	return

^Numpad3:: run C:\Program Files\Sublime Text 3\sublime_text.exe
	return

Numpad4::send,^+{tab}            ;chrome_tab_Backward.
	return

!Numpad4::
	send, ^1
	return

Numpad5::
	send, ^{tab}                         ;chrome_tab_forward. 
	return

!Numpad5:: run https://www.facebook.com/
	return

!Numpad6::
	run https://www.google.com/
	return

Numpad6::
	Send {WheelDown}
	Sleep, 50
	return

Numpad7:: send, ^s
	return

!Numpad7:: send ^r
	return

Numpad8::
	send, ^w                             ;close_chrome_tab.   
	return

!Numpad8:: 
	send,^+{t}                           ;open closed_chrome_tab.
	return

Numpad9::
	run https://www.fiverr.com/users/imtiazz4/requests/
	return

!Numpad9:: run https://www.youtube.com/
	return


NumpadDot::Volume_Down
	Return

Numpadadd::
	send, ^a
	return

NumpadSub::Backspace
	return

NumpadMult::ComObjCreate("Shell.Application").ToggleDesktop()           ;Minimize_all_window.

NumpadDiv::!F4
	return

Pause:: 
	Click
	return

F1::suspend ;suspend this script
	return

; F2:: is for rename

F3::Reload ;reload this script
	return

; F4:: is for close window


F5:: send ^+c ;inspect element in web browser
	return

; F6:: is available for use

; F7:: is available for use

F9::Media_Play_Pause
	return

F10::
	send,^+{Escape} ;Task_mannager.
	return

; F11:: is full screen web browser

F12::Volume_Mute
	return

F13::esce()  ;this key is for joy pov left esc button
	esce(){
		Send, {Esc}
		Sleep, 100
	}
	Return

!j::
	run G:\4.Windows Decoration\Hot key\Joystick.ahk
	return



; This is a loop technique for later use


	; Numpad1::
	; 	Loop, 11
	; 	{
	; 	Send f
	; 	Sleep 200
	; 	}
	; return



; This is a if statement with GetKeyState

	; #if GetKeyState("F3", "P")

	;     $a::Send {a down}

	; #If