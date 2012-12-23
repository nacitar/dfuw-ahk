; NOTE: Autohotkey has a bug to do with not releasing RSHIFT when told to do an up event

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REQUIRED STUFF 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; How long to wait before equipping a shield, to avoid paperdoll lock
SHIELD_DELAY_MS := 500

; Get the quick item slot for the weapon
get_weapon_slot(weap)
{
	global
	if (weap = WEAP_STAFF)
		return 1
	if (weap = WEAP_BOW)
		return 2
	if (weap = WEAP_2H)
		return 3
	if (weap = WEAP_1H)
		return 4
	if (weap = WEAP_SHIELD)
		return 5
	return 0
}

; If you use the setup where all slots of a certain type use the same modifier
; it may make sense to store it in a variable here.
RMOD_LEFT_RADIAL := MOD_RALT
RMOD_RIGHT_RADIAL := MOD_RCTRL
RMOD_QUICK_ITEM := MOD_RALT|MOD_RCTRL

; Which key for which radial slot?
; Default implementation uses the same modifier + numpad<slot>
get_radial_key(is_right,slot,ByRef rmods_out)
{
	global
	; provide rmods_out with the right modifiers to press with the key we provide
	rmods_out := ((is_right)?(RMOD_RIGHT_RADIAL):(RMOD_LEFT_RADIAL))
	; return the key to press
	return numpad_key(slot)
}
; Which key for the quick item slot?
; Default implementation uses the same modifier + numpad<slot>
get_quick_item_key(slot,ByRef rmods_out)
{
	global
	; provide the rmods_out with the right modifiers to press with the key we provide
	rmods_out := RMOD_QUICK_ITEM
	; return the key to press
	return numpad_key(slot)
}

