; Author: nacitar sevaht
; License: Public Domain 

; NOTE: Autohotkey has a bug to do with not releasing RSHIFT when told to do an up event

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Autohotkey supplements
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Sanely convert integers to strings so they can be appended to strings
to_string(num)
{
	return %num%
}
; Variable friendly send/msgbox, so you can in one line use the VALUE of your computation/function calls, instead of
; having to assign to a var with := first. 
var_send(value)
{
	Send, %value%
}
var_msgbox(value)
{
	MsgBox, %value%
}
; returns flag if cond is not false; otherwise returns 0 
cond_flag(val,cond)
{
	if (cond)
		return flag
	return 0
}
; Returns the numpad key name for this number
numpad_key(num)
{
	return "Numpad" . to_string(num)
}
; How many ms to hold presses; DF:UW requires this.
PRESS_DURATION_MS := 5
; Press/release
send_press(down_str,up_str)
{
	global
	var_send(down_str)
	Sleep, %PRESS_DURATION_MS%
	var_send(up_str)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flags/Constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Bit flags for right modifier keys; used with send_mod
; Intentionally omitting rshift due to autohotkey not releasing it when it should
MOD_RCTRL  := (1 << 1)
MOD_RALT   := (1 << 2)
MOD_LSHIFT := (1 << 3)
MOD_LCTRL  := (1 << 4)
MOD_LALT   := (1 << 5)
; game won't let you set a hotkey with WIN keys, but we can check states regardless
MOD_RWIN   := (1 << 6) 
MOD_LWIN   := (1 << 7)

; All inclusive masks
MOD_LEFT   := MOD_LSHIFT|MOD_LCTRL|MOD_LALT|MOD_LWIN 
MOD_RIGHT  := MOD_RCTRL|MOD_RALT|MOD_RWIN 
MOD_ALL    := MOD_LEFT|MOD_RIGHT

; Identifiers for weapons that are selected
; TODO: will we need two 2h weapons to be viable in this too?  if so, enhancement will be needed
WEAP_STAFF := 0
WEAP_BOW := 1
WEAP_2H := 2
WEAP_1H := 3
WEAP_SHIELD := 4

; Converts individual mod flags to their key names
mod_to_key(flag)
{
	global
	if (flag = MOD_RSHIFT)
		return "RShift"
	else if (flag = MOD_RCTRL)
		return "RCtrl"
	else if (flag = MOD_RALT)
		return "RAlt"
	if (flag = MOD_LSHIFT)
		return "LShift"
	else if (flag = MOD_LCTRL)
		return "LCtrl"
	else if (flag = MOD_LALT)
		return "LAlt"
	else if (flag = MOD_RWIN)
		return "RWin"
	else if (flag = MOD_LWIN)
		return "LWin"
	return ""
}
; Returns the flag if the key is pressed, else 0
mod_state(flag)
{
	return cond_flag(flag,GetKeyState(mod_to_key(flag),"P"))
}
; The state of the left modifier keys
lmod_state()
{
	global
	return mod_state(MOD_LCTRL) | mod_state(MOD_LALT) | mod_state(MOD_LWIN)
}
; The state of the right modifier keys
rmod_state()
{
	global
	return mod_state(MOD_RCTRL) | mod_state(MOD_RALT) | mod_state(MOD_RWIN)
}
; The state of both the left and the right modifier keys
all_mod_state()
{
	return lmod_state() | rmod_state()
}
; Turns true into down, false into up.
keypress_state(pressed)
{
	return ((pressed)?("down"):("up"))
}
; Turns this key name into a key
key_string(key)
{
	return "{" . key . "}"
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOMIZATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Include the user's settings; expected to provide get_radial_key() and get_quick_item_key()
#include settings.ahk


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Slot selection logic 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Wrappers
get_left_radial_key(slot,ByRef rmods_out)
{
	return get_radial_key(0,slot,rmods_out)
}
get_right_radial_key(slot,ByRef rmods_out)
{
	return get_radial_key(1,slot,rmods_out)
}

; Turns a key and a boolean into a string representing a press or release of that key
keypress_string(key,pressed)
{
	return key_string(key . " " . keypress_state(pressed))
}
; The string to press the mod if set in mask, or release if not in mask
mod_press_str(flag,mask)
{
	return keypress_string(mod_to_key(flag),mask&flag)
}
; Unholy Wars only lets you use two modifiers for a hotkey
; Fills passed down/up str vars with the down and up send string for this press.
get_rmod_press_str(key,rmods,ByRef down_str_out,ByRef up_str_out)
{
	global
	; Providing an empty string "" as the mode presses the button without changing any modifiers
	if (rmods = "")
	{
		down_str_out := ""
		up_str_out := ""
	}
	else
	{
		down_str_out := mod_press_str(MOD_RCTRL,rmods) . mod_press_str(MOD_RALT,rmods)
		; release reversed
		up_str_out := mod_press_str(MOD_RALT,0) . mod_press_str(MOD_RCTRL,0)
	}

	down_str_out := down_str_out . keypress_string(key,1)
	up_str_out := keypress_string(key,0) . up_str_out
}
	
; Sends the keypress after calling get_rmod_press_str
send_rmod_press(key,rmods)
{
	global
	down_str := ""
	up_str := ""
	get_rmod_press_str(key,rmods,down_str,up_str)
	
	send_press(down_str,up_str)
}
; Returns the keypress string to specify the desired radial skill
get_radial_skill_press_str(is_right,slot,ByRef down_str_out,ByRef up_str_out)
{
	global
	; Initial rmods; may be changed by get_radial_key()
	rmods := 0
	key := get_radial_key(is_right,slot,rmods)
	get_rmod_press_str(key,rmods,down_str_out,up_str_out)
}
get_left_radial_skill_press_str(slot,ByRef down_str_out,ByRef up_str_out)
{
	get_radial_skill_press_str(0,slot,down_str_out,up_str_out)
}
get_right_radial_skill_press_str(slot,ByRef down_str_out,ByRef up_str_out)
{
	get_radial_skill_press_str(1,slot,down_str_out,up_str_out)
}
; Sends the keypress returned by get_radial_skill_press_str
radial_skill(is_right,slot)
{
	down_str := ""
	up_str := ""
	get_radial_skill_press_str(is_right,slot,down_str,up_str)
	send_press(down_str,up_str)
}
left_radial_skill(slot)
{
	radial_skill(0,slot)
}
right_radial_skill(slot)
{
	radial_skill(1,slot)
}
; Returns the keypress string to choose a quick item slot
get_quick_item_press_str(slot,ByRef down_str_out,ByRef up_str_out))
{
	global
	; Initial rmods; may be changed by get_quick_item_key()
	rmods := 0
	key := get_quick_item_key(slot,rmods)
	; Return the keypress string
	get_rmod_press_str(key,rmods,down_str_out,up_str_out)
}
; Sends the keypress returned by get_quick_item_press_str
quick_item(slot)
{
	down_str := ""
	up_str := ""
	get_quick_item_press_str(slot,down_str,up_str)
	send_press(down_str,up_str)
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game functions 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
equip_staff()
{
	global
	quick_item(get_weapon_slot(WEAP_STAFF))
}
equip_bow()
{
	global
	quick_item(get_weapon_slot(WEAP_BOW))
}
equip_2h()
{
	global
	quick_item(get_weapon_slot(WEAP_2H))
}
equip_1h()
{
	global
	quick_item(get_weapon_slot(WEAP_1H))
}
equip_shield()
{
	; Due to paperdoll locking, we need a timer for equipping a shield after a 1H
	; This label lets us jump into this function from the timer
	equipshield_callback:
	global
	SetTimer, equipshield_callback, Off
	quick_item(get_weapon_slot(WEAP_SHIELD))

	; Need an explicit return to make the timer callback happy
	return
}
equip_shield_delayed()
{
	global
	SetTimer, equipshield_callback, Off
	SetTimer, equipshield_callback, %SHIELD_DELAY_MS%
}
equip_1h_shield()
{
	equip_1h()
	equip_shield_delayed()
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keymapping functions 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; When you press key, forward the press, wait for release, then forward the release to newkey
remap(key,newkey)
{
	Send, {%newkey% Down}
	KeyWait %key%
	Send, {%newkey% Up}
}
; Just press the key and release it when you release it; useful if you're intercepting the keypress
; but also want the game to get that keypress in this instance
passthru(key)
{
	remap(key, key)
}
; Like remap_passthru, but also presses the original key.  Furthermore, if left shift is down, it presses right shift upon release
; NOTE: the right shift hack is only present as a workaround to allow splitting stacks in DF1; might be unneeded for DF:UW, but
; any click that requires shift held might need this.
remap_passthru(key,newkey)
{
	Send, {%newkey% Down}
	Send, {%key% Down}
	KeyWait %key%
	if ( GetKeyState("LShift", "P") = 1 )
	{
		Send, {RShift Down}
		Send, {%key% Up}
		Send, {%newkey% Up}
		Send, {RShift Up}
	}
	else
	{
		Send, {%key% Up}
		Send, {%newkey% Up}
	}
}
; G-Keys on my G15 are setup to run this ahk script; this lets me run them from an ahk script too! Dual purpose.
SendGKey(num)
{
	RunWait, autohotkey.exe gkeys.ahk %num%
}
