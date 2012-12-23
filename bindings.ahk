;#IfWinActive, Darkfall Online
#SingleInstance force
#NoEnv

#Include %A_ScriptDir% ; Change the working dir for #include commands
#Include common.ahk

#HotkeyInterval 1  ; This is  the default value (milliseconds)
#MaxHotkeysPerInterval 2000

TESTING_OUTSIDE_GAME:=1

#If !TESTING_OUTSIDE_GAME
; We always want numlock on
SetNumLockState, AlwaysOn

; Maybe need this?
$*NumLock::
	Send, {AUTORUN KEY}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modifier preparation 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We don't want the left modifiers to _actually_ go down, we want to use them for
; our own hotkeys as our own internal "modifiers".  We don't block the right windows
; key though, so we can still use that to minimize the game if we want.
$*LWin::
	return
$*LAlt::
	return
$*LCtrl::
	return

; Alt+Escape can cause the game to minimize, but the game needs escape to be sent.
; So, we block escape's keypress in general but send an unmodified escape too
$*Escape::
	Send, {Escape}
	return

#If ; !TESTING_OUTSIDE_GAME

; Putting each binding that's complex at all in functions, so we can ask for global namespace
hk_wheel_down()
{
	global
	; sword and board
	equip_1h_shield()
}

; Select 2h
hk_wheel_up()
{
	global
	; greatsword
	equip_2h()
}

hk_wheel_press()
{
	global
	; staff
	equip_staff()
}



