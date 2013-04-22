#IfWinActive, Darkfall Unholy Wars
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
	equip_1h()
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

clear_skill()
{
	send_press("{`` down}","{`` up}")
}

attack_string(radial,state)
{
	key:=((radial)?("Numpad0"):("AppsKey"))
	return keypress_string(key,state)
}

current_radial_attack(state)
{
	global
	return attack_string(CURRENT_RADIAL,state)
}
*q::
	state := lmod_state()
	; TODO: what am i doing here?
	if ((state & MOD_LALT) != 0)
	{
		; Holding alt makes the wheel act normally
		send_rmod_hold(key,MOD_RALT,key)
	}
	else if ((state & MOD_LCTRL) != 0)
	{
		; open the radial menus?
		send_rmod_hold(key,MOD_RCTRL,key)
	}
	else
	{
		radial_menu(0)
	}
	return
*e::
	radial_menu(1)
	return

*0::
	state := lmod_state()
	if ((state & MOD_LALT) = MOD_LALT)
	{
		quick_item(7)
	}
	else
	{
		passthru(0)
	}
	return

$*XButton1::
	; heal self
	left_radial_skill(8)
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
	if ((state & MOD_LCTRL) = MOD_LCTRL)
	{
		; heal mount
		right_radial_skill(1)
	}
	else
	{
		clear_skill()
	}
	return


LBUTTON_WAS_PLAIN:=0
RBUTTON_WAS_PLAIN:=0

; rebout right actiont rigger to Numpad0
*RButton::
	RBUTTON_WAS_PLAIN:=0
	if ( CURRENT_WEAPON = WEAP_BOW )
	{
		right_radial_skill(5)
	}
	else if ( CURRENT_WEAPON = WEAP_1H )
	{
		Send, {v down}
	}
	else
	{
		Send, {Numpad0 down}
		Send, {RButton down}
		RBUTTON_WAS_PLAIN := 1
	}
	return

*RButton up::
	Send, {RButton up}
	Send, {Numpad0 up}
	Send, {v up}
	if (RBUTTON_WAS_PLAIN)
	{
		clear_skill()
	}
	return


		

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
		var_send(current_radial_attack(1))
		;Send, {AppsKey down}
		Send, {LButton down}
		LBUTTON_WAS_PLAIN := 1
	}
	return

*LButton up::
	Send, {LButton up}
	;Send, {AppsKey up}
	var_send(current_radial_attack(0))
	if (LBUTTON_WAS_PLAIN)
	{
		clear_skill()
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

