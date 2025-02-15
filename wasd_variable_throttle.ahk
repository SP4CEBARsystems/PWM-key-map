#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

throttle := 0.5  ; Initialize throttle variable
global throttle

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

XButton1::alternate("s", "XButton1", throttle)
XButton2::alternate("w", "XButton2", throttle)

MButton::steering("MButton")

alternate(key, activationKey, dutyCycle) {
	cycleDelay := 100
    while GetKeyState(activationKey, "P") {
        Send {%key% down}
        Sleep, % (dutyCycle * cycleDelay)
        Send {%key% up}
        Sleep, % ((1 - dutyCycle) * cycleDelay)
    }
}

steering(activationKey) {
    steeringPower := getSteeringPower()
    steeringMagnitude := Abs(steeringPower)
    key := (steeringPower < 0) ? "a" : "d"
    alternate(key, activationKey, steeringMagnitude)
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
	global MyEdit
	GuiControl,, MyEdit, % "Throttle: " . FloorDecimal(throttle, 2) . "`nSteering: " . FloorDecimal(getSteeringPower(), 2)
}

floorDecimal(num, digits) {
	divideBy = 10 ** digits
	num:=Floor(num*divideBy)
	SetFormat Float, 0.2
	return num/divideBy
}
