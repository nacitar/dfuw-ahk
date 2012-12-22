; Author: nacitar sevaht
; License: Public Domain 


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flag constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Bit flags for right modifier keys; used with send_mod
MOD_RSHIFT := (1 << 0)
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
MOD_RIGHT  := MOD_RSHIFT|MOD_RCTRL|MOD_RALT|MOD_RWIN 
MOD_ALL    := MOD_LEFT|MOD_RIGHT




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOMIZATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; MUST BE RIGHT MODIFIERS (can be or'd together)
RMOD_LEFT_RADIAL := MOD_RALT
RMOD_RIGHT_RADIAL := MOD_RCTRL
RMOD_QUICK_ITEM := MOD_RSHIFT

; Which key for which radial slot?  I suggest numpad for all of these, but you can differ if you wish..
get_radial_key(is_right,slot)
{
	return numpad_key(slot)
}
; Which key for the quick item slot?
get_quick_item_key(slot)
{
	return numpad_key(slot)
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The meat of it 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Wrappers
get_left_radial_key(slot)
{
	return get_radial_key(0,slot)
}
get_right_radial_key(slot)
{
	return get_radial_key(1,slot)
}

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
; Returns the keypress command with the specified right-modifiers down with your keypress, releasing when done
get_rmod_press_str(key,rmods)
{
	global
	; Providing an empty string "" as the mode presses the button without changing any modifiers
	if (rmods = "")
	{
		rmods_down := ""
		rmods_up := ""
	}
	else
	{
		rmods_down := mod_press_str(MOD_RSHIFT,rmods) . mod_press_str(MOD_RCTRL,rmods) . mod_press_str(MOD_RALT,rmods)
		; release reversed
		rmods_up := mod_press_str(MOD_RALT,0) . mod_press_str(MOD_RCTRL,0) . mod_press_str(MOD_RCTRL,0)
	}
	
	; assemble the keypress and return it
	keypress := rmods_down . key . rmods_up
	return keypress
}
; Sends the keypress after calling get_rmod_press_str
send_rmod_press(key,rmods)
{
	var_send(get_rmod_press_str(key,rmods))
}
; Returns the keypress string to specify the desired radial skill
get_radial_skill_press_str(is_right,slot)
{
	global
	; We're using the number pad for these keys
	rmods := ((is_right)?(RMOD_RIGHT_RADIAL):(RMOD_LEFT_RADIAL))
	; Return the keypress string
	return get_rmod_press_str(get_radial_key(is_right,slot),rmods)
}
get_left_radial_skill_press_str(slot)
{
	return get_radial_skill_press_str(0,slot)
}
get_right_radial_skill_press_str(slot)
{
	return get_radial_skill_press_str(1,slot)
}
; Sends the keypress returned by get_radial_skill_press_str
radial_skill(is_right,slot)
{
	var_send(get_radial_skill_press_str(is_right,slot))
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
get_quick_item_press_str(slot)
{
	global
	return get_rmod_press_str(get_quick_item_key(slot),RMOD_QUICK_ITEM)
}
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
