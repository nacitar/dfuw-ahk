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

; not generic!
radial_menu(is_right)
{
	global
	key := ((is_right)?("e"):("q"))
	state := lmod_state()
	; Holding alt makes the wheel act normally
	if ((state & MOD_LALT) != 0)
	{
		send_rmod_hold(key,MOD_RALT,key)
	}
	else if ((state & MOD_LCTRL) != 0)
	{
		send_rmod_hold(key,MOD_RCTRL,key)
	}
	else
	{
		passthru(key)
		return 0
	}
	return 1
}
*q::
	radial_menu(0)
	return
*e::
	radial_menu(1)
	return

$*XButton1::
	; nothing yet
	return

$*XButton2::
	state := lmod_state()
	; Holding alt makes the wheel act normally
	if ((state & MOD_LCTRL) != 0)
	{
		; efficiency
		left_radial_skill(7)
	}
	else if ((state & MOD_LALT) != 0)
	{
		; leap
		left_radial_skill(6)
	}
	else
	{
		; dash
		left_radial_skill(5)
	}
	return

$*`::
	state := lmod_state()
	if ((state & MOD_LALT) = MOD_LALT)
	{
		; skinning knife
		quick_item(8)
	}
	return


LBUTTON_WAS_PLAIN:=0
; rebound left action trigger to APPS
*LButton::
	LBUTTON_WAS_PLAIN:=0
	state := lmod_state()
	if ((state & (MOD_LCTRL|MOD_LALT)) = (MOD_LCTRL|MOD_LALT))
	{
		; health to mana
		left_radial_skill(4)
	}
	else if ((state & MOD_LCTRL) = MOD_LCTRL)
	{
		; stamina to health
		left_radial_skill(3)
	}
	else if ((state & MOD_LALT) = MOD_LALT)
	{
		; mana to stamina
		left_radial_skill(2)
	}
	else
	{
		Send, {AppsKey down}
		Send, {LButton down}
		LBUTTON_WAS_PLAIN := 1
	}
	return

*LButton up::
	Send, {LButton up}
	Send, {AppsKey up}
	if (LBUTTON_WAS_PLAIN)
	{
		; clear skill
		send_press("{`` down}","{`` up}")
	}
	return
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

