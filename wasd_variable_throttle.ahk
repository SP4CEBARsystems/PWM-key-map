#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

throttle := 0.5  ; Initialize throttle variable
throttlePulsefrequency := 1 ;Hz
steeringPulsefrequency := 5 ;Hz
throttlePulsedelay := 1000 / throttlePulsefrequency ;ms
steeringPulsedelay := 1000 / steeringPulsefrequency ;ms
global throttle
global steeringPulsedelay
global Toggle

Toggle := False

#Persistent
SetBatchLines, -1  ; Ensure high performance execution

showIndicator()

WheelUp::
	throttle := Min(1, throttle + 0.05)  ; Increase throttle, max 1
	updateIndicator()
return

WheelDown::
	throttle := Max(0, throttle - 0.05)  ; Decrease throttle, min 0
	updateIndicator()
return

XButton1::
	while GetKeyState("XButton1", "P") {
		alternate("s", throttle, throttlePulsedelay)
	}
return

XButton2::
	while GetKeyState("XButton2", "P") {
		alternate("w", throttle, throttlePulsedelay)
	}
return

#MaxThreadsperHotkey 2
MButton::
	Toggle:=!Toggle
	updateIndicator()
	While, Toggle {
		steering()
	}
return
; while GetKeyState("MButton", "P") {
;
	
alternate(key, dutyCycle, cycleDelay) {
	Send {%key% down}
	Sleep, % (dutyCycle * cycleDelay)
	Send {%key% up}
	Sleep, % ((1 - dutyCycle) * cycleDelay)
}

steering() {
	global steeringPulsedelay
	steeringPower := getSteeringPower()
	steeringMagnitude := Abs(steeringPower)
	key := (steeringPower < 0) ? "a" : "d"
	alternate(key, steeringMagnitude, steeringPulsedelay)
	updateIndicator()
}

getSteeringPower() {
	MouseGetPos, mouseX, 
    Return (mouseX - (A_ScreenWidth / 2)) / (A_ScreenWidth / 2)
}

showIndicator(){
	; source: https://www.autohotkey.com/boards/viewtopic.php?style=1&t=96934#p430774
	global vMyEdit
	Gui, +LastFound +AlwaysOnTop
	Gui, % CLICKTHROUGH := "+E0x20"
	Gui, Color, F0F0F0
	Gui, Font, s0,
	Gui, Add, Edit, vMyEdit w200 h220 -E0x200
	Gui, Font, s15, Verdana
	updateIndicator()
	Gui, Show, x1600 y100 NoActivate
}

updateIndicator(){
    global throttle
    global Toggle
	global MyEdit
	steeringText := Toggle ? "`nSteering: " . FloorDecimal(getSteeringPower(), 2) : ""
	GuiControl,, MyEdit, % "Throttle: " . FloorDecimal(throttle, 2) . steeringText
}

floorDecimal(num, digits) {
	divideBy := 10 ** digits
	num := Floor(num * divideBy)
	SetFormat Float, 0.2
	return num / divideBy
}
