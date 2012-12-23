#IfWinActive, Darkfall Online
#SingleInstance force
#NoEnv

#Include %A_ScriptDir% ; Change the working dir for #include commands
#Include common.ahk

#HotkeyInterval 1  ; This is  the default value (milliseconds)
#MaxHotkeysPerInterval 2000

TESTING_OUTSIDE_GAME:=0

; We always want numlock on
SetNumLockState, AlwaysOn

; Maybe need this?
;$*NumLock::
;	Send, {AUTORUN KEY}


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

hk_mbutton()
{
	global
	state := lmod_state()
	; Holding alt makes the wheel act normally
	if ((state & MOD_LALT) != 0)
	{
		equip_bow()
	}
	else
	{
		equip_staff()
	}
}


; No $; game doesn't get this 
*WheelDown::
	state := lmod_state()
	; Holding alt makes the wheel act normally
	if ((state & MOD_LALT) != 0)
	{
		var_send(key_string("WheelDown"))
	}
	else
	{
		hk_wheel_down()
	}
	return
; No $; game doesn't get this 
*WheelUp::
	state := lmod_state()
	; Holding alt makes the wheel act normally
	if ((state & MOD_LALT) != 0)
	{
		var_send(key_string("WheelUp"))
	}
	else
	{
		hk_wheel_up()
	}
	return
; No $; game doesn't get this 
*MButton::
	hk_mbutton()	
	return

