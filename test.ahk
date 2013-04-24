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

is_integer(obj)
{
	if (obj is integer)
	{
		return true
	}
	return false
}
; Check if data is a string
is_string(obj)
{
	if (obj is alnum)
	{
		return true
	}
	return false
}
; Determine if an object is of a particular class type
is_type(obj,type_name)
{
	if (obj.__Class = type_name)
	{
		return true
	}
;	else if ((obj is alnum) && type_name
	return false
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

; Represents the position of a keypress
class KeyPosition
{
	static DOWN := 1
	static UP := 0 
}

; Key class, used to create key strings and check key positions
class KeyObject
{
	; Creates a Key object from a string key name as AHK expects it
	__New(name)
	{
		this.name := name
	}
	
	position()
	{
		if (GetKeyState(this.name, "P") = 1)
		{
			return KeyPosition.DOWN
		}
		return KeyPosition.UP
	}

	; Returns 1 if the button is down, 0 otherwise
	isDown()
	{
		if (this.position() = KeyPosition.DOWN)
		{
			return 1
		}
		return 0
	}
	; Equivalence
	equals(other)
	{
		if (this.name = other.name)
		{
			return true
		}
		return false
	}
}
; Wrapper for the object creation
Key(name)
{
	return new KeyObject(name)
}


; This class is used to refer to a particular keystroke; a press or release or both
class KeyStateObject
{
	__New(key,position=-1)
	{
		this.key := key
		this.position := position
	}

	equals(other)
	{
		if ((this.key.equals(other.key)) && (this.position = other.position))
		{
			return true
		}
		return false
	}
}
		
; Wrapper for object creation
KeyState(key,position=-1)
{
	return new KeyStateObject(key,position)
}

; A series of keystate changes
class KeySeqObject
{
	__New(state_array)
	{
		this.cmd := ""
		Loop, % state_array.MaxIndex()
		{
			key_state := state_array[A_Index]
			key_name := key_state.key.name
			if (key_state.position = KeyPosition.DOWN)
			{
				this.cmd := this.cmd . "{" . key_name . " down}"
			}
			else
			{
				this.cmd := this.cmd . "{" . key_name . " up}"
			}
		}
	}
	emit()
	{
		var_send(this.cmd)
	}
}
; Wrapper for object creation
KeySeq(state_array)
{
	return new KeySeqObject(state_array)
}

; static class for higher level keyboard functions
class Keyboard
{
	; Intentionally omitting rshift due to autohotkey not releasing it when it should
	; game won't let you set a hotkey with WIN keys, but we can check states regardless
	static RCTRL  := Key("RCtrl")
	static RALT   := Key("RAlt")
	static LSHIFT := Key("LShift")
	static LCTRL  := Key("LCtrl")
	static LALT   := Key("LAlt")
	static RWIN   := Key("LWin") 
	static LWIN   := Key("RWin")

	static ALL_MODS   := [Keyboard.RCTRL, Keyboard.RALT, Keyboard.LSHIFT, Keyboard.LCTRL, Keyboard.LALT, Keyboard.RWIN, Keyboard.LWIN]
	static RIGHT_MODS := [Keyboard.RCTRL, Keyboard.RALT, Keyboard.RWIN]
	static LEFT_MODS  := [Keyboard.LSHIFT, Keyboard.LCTRL, Keyboard.LALT, Keyboard.LWIN]

	; Returns the subset of the passed key array that corresponds to down keys.
	getDown(key_array)
	{
		down_array := []
		Loop, % key_array.MaxIndex()
		{
			key := key_array[A_Index]
			if (key.isDown())
			{
				down_array.Insert(key)
			}
		}
		return down_array
	}

	; Convenience to get down modifiers
	downMods()
	{
		return this.getDown(Keyboard.ALL_MODS)
	}

	; Returns true if all keys in key_array are down.  If down_key_array is specified, it
	; is used as the list of all down keys instead of physical state.  This lets you
	; take snapshots of the state and compare against them
	isDown(key_array,down_key_array=-1)
	{
		if (down_key_array = -1)
		{
			down_key_array := this.getDown(key_array)
		}
		; loop through the keys to check
		Loop, % key_array.MaxIndex()
		{
			key := key_array[A_Index]
			found := 0
			; loop through the set keys
			Loop, % down_key_array.MaxIndex()
			{
				if (key.equals(down_key_array[A_Index]))
				{
					found := 1
					break
				}
			}
			if (found != 1)
			{
				return false
			}
		}
		return true
	}
}

class BindingObject
{
	__New(key,mod_key_array)
	{
		down_state_array := []
		up_state_array := []

		; TODO: reverse order of release?
		; we can only append (not even extend!), really AHK?
		up_state_array.Insert(KeyState(key,KeyPosition.UP))

		Loop, % mod_key_array.MaxIndex()
		{
			mod_key := mod_key_array[A_Index]
			down_state_array.Insert(KeyState(mod_key,KeyPosition.DOWN))
			up_state_array.Insert(KeyState(mod_key,KeyPosition.UP))
		}

		down_state_array.Insert(KeyState(key,KeyPosition.DOWN))

		; Now that we have the arrays, we can make sequences with them
		this.down := KeySeq(down_state_array)
		this.up := KeySeq(up_state_array)
	}

}
Binding(key,mod_key_array)
{
	return new BindingObject(key,mod_key_array)
}

hkey := Binding(Key("a"),[Keyboard.RCTRL,Keyboard.RALT])
var_msgbox(hkey.down.cmd)

