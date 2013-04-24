/*
 * Copyright (C) 2013 Jacob McIntosh (nacitar sevaht) <nacitar at ubercpp.com> 
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

; NOTE: Autohotkey has a bug to do with not releasing RSHIFT when told
; to do an up event

#IfWinActive, Darkfall Unholy Wars
#SingleInstance force
#NoEnv

#Include %A_ScriptDir% ; Change the working dir for #include commands

#HotkeyInterval 1  ; This is  the default value (milliseconds)
#MaxHotkeysPerInterval 2000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Autohotkey supplements
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Variable friendly send/msgbox, so you can in one line use the VALUE of your
; computation/function calls to avoid having to assign to a var first.
var_send(value) {
  Send, %value%
}
var_msgbox(value) {
  MsgBox, %value%
}

; Sanely convert integers to strings so they can be appended to strings
to_string(num) {
  return %num%
}

; Opens an error message box then exits the script.
raise_exception(text) {
  msg := "Error: " . to_string(text)
  var_msgbox(msg)
  ExitApp, 1
}
; Determine if an object is of a particular class type
is_class(obj,type_name) {
  return (obj.__Class = type_name)
}
; somewhat hackish way to determine if a value is an array
is_array(obj) {
  return  (IsObject(obj) && is_class(obj,""))
}
; validates an array argument; makes it into an array if it isn't one
make_array(obj) {
  if (!is_array(obj)) {
    return [obj]
  }
  return obj
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keyboard Input Model
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Represents the position of a keypress
class KeyPosition {
  static DOWN := 1
  static UP := 0 
}

; Validates a position argument
validate_position_arg(location,position) {
  if (   (position is not integer)
      || (position != KeyPosition.DOWN && position != KeyPosition.UP)) {
    raise_exception(location . " requires a position from KeyPosition.<var>")
  }
  return position
}

; Key class, used to create key strings and check key positions
class KeyObject {
  ; Creates a Key object from a string key name as AHK expects it
  __New(name) {
    this.name := name
  }

  position() {
    if (GetKeyState(this.name, "P") = 1) {
      return KeyPosition.DOWN
    }
    return KeyPosition.UP
  }

  ; Returns 1 if the button is down, 0 otherwise
  isDown() {
    return (this.position() = KeyPosition.DOWN)
  }
  ; Equivalence
  equals(other) {
    return (this.name = other.name)
  }
}
; Wrapper for the object creation
Key(name) {
  if (name is not alnum) {
    raise_exception("Key() requires a string key name as its argument.")
  }
  return new KeyObject(name)
}
; Validates/creates a Key() argument
validate_key_arg(location,key) {
  if (key is alnum) {
    return Key(key)
  } else if (!is_class(key,"KeyObject")) {
    raise_exception(location . " requires a key name/Key() as its argument.")
  }
  return key
}


; Used to refer to a particular keystroke; a press or release or both
class KeyStateObject {
  __New(key,position) {
    this.key := key
    this.position := position
  }

  equals(other) {
    return (this.key.equals(other.key) && this.position = other.position)
  }
}


; Wrapper for object creation
KeyState(key,position) {
  key := validate_key_arg("KeyState()",key)
  position := validate_position_arg("KeyState()",position)

  return new KeyStateObject(key,position)
}

; A series of keystate changes
class KeySeqObject {
  __New(state_array) {
    this.cmd := ""
    Loop, % state_array.MaxIndex() {
      key_state := state_array[A_Index]

      key_name := key_state.key.name
      if (key_state.position = KeyPosition.DOWN) {
        this.cmd := this.cmd . "{" . key_name . " down}"
      } else {
        this.cmd := this.cmd . "{" . key_name . " up}"
      }
    }
  }
  emit() {
    var_send(this.cmd)
  }
}
; Wrapper for object creation
KeySeq(state_array) {
  state_array := make_array(state_array)

  Loop, % state_array.MaxIndex() {
    if (!is_class(state_array[A_Index],"KeyStateObject")) {
      raise_exception("KeySeq() requires array members of KeyState() type")
    }    
  }
  return new KeySeqObject(state_array)
}

; static class for higher level keyboard functions
class Keyboard {
  ; Intentionally omitting rshift due to autohotkey not releasing it when it
  ; should.  Also, DFUW won't let you set a hotkey with WIN keys, but we can
  ; check states regardless
  static RCTRL  := Key("RCtrl")
  static RALT   := Key("RAlt")
  static LSHIFT := Key("LShift")
  static LCTRL  := Key("LCtrl")
  static LALT   := Key("LAlt")
  static RWIN   := Key("LWin") 
  static LWIN   := Key("RWin")

  static ALL_MODS   :=  [ Keyboard.RCTRL
                        , Keyboard.RALT
                        , Keyboard.LSHIFT
                        , Keyboard.LCTRL
                        , Keyboard.LALT
                        , Keyboard.RWIN
                        , Keyboard.LWIN ]

  static RIGHT_MODS :=  [ Keyboard.RCTRL
                        , Keyboard.RALT
                        , Keyboard.RWIN ]

  static LEFT_MODS  :=  [ Keyboard.LSHIFT
                        , Keyboard.LCTRL
                        , Keyboard.LALT
                        , Keyboard.LWIN ]

  ; Returns the subset of the passed key array that corresponds to down keys.
  getDown(key_array) {
    key_array := make_array(key_array)
    down_array := []
    Loop, % key_array.MaxIndex() {
      key := key_array[A_Index]
      if (key.isDown()) {
        down_array.Insert(key)
      }
    }
    return down_array
  }

  ; Convenience to get down modifiers
  downMods() {
    return this.getDown(Keyboard.ALL_MODS)
  }

  ; Returns true if all keys in key_array are down.  If down_key_array is
  ; specified, it is used as the list of all down keys instead of physical
  ; state.  This lets you take snapshots of the state and compare against them.
  isDown(key_array,down_key_array=-1) {
    if (down_key_array = -1) {
      down_key_array := this.getDown(key_array)
    }
    key_array := make_array(key_array)

    down_key_array := make_array(down_key_array)
    ; loop through the keys to check

    Loop, % key_array.MaxIndex() {
      key := key_array[A_Index]
      key := validate_key_arg("Keyboard.isDown()",key)

      found := 0
      ; loop through the set keys
      Loop, % down_key_array.MaxIndex() {
        down_key := down_key_array[A_Index]
        down_key := validate_key_arg("Keyboard.isDown()",down_key)
        if (key.equals(down_key)) {
          found := 1
          break
        }
      }
      if (found != 1) {
        return false
      }
    }
    return true
  }
}

; A class for key bindings.
; Provides .emit(), .down.emit(), .up.emit()
class BindingObject {
  static PRESS_DURATION_MS := 5

  __New(key,mod_key_array) {
    down_state_array := []
    up_state_array := []

    up_state_array.Insert(KeyState(key,KeyPosition.UP))

    Loop, % mod_key_array.MaxIndex() {
      mod_key := mod_key_array[A_Index]
      down_state_array.Insert(KeyState(mod_key,KeyPosition.DOWN))
      ; 1 is first index, so this puts modifiers releases
      ; after the key up, but in reverse order.
      up_state_array.Insert(2,KeyState(mod_key,KeyPosition.UP))
    }

    down_state_array.Insert(KeyState(key,KeyPosition.DOWN))

    ; Now that we have the arrays, we can make sequences with them
    this.down := KeySeq(down_state_array)
    this.up := KeySeq(up_state_array)
  }

  ; TODO, allow multiple "emit types" for different things than sleeping
  emit() {
    this.down.emit()
    ; TODO: use a Sleep that has higher resolution
    Sleep, % BindingObject.PRESS_DURATION_MS
    this.up.emit()
  }
}
Binding(key,mod_key_array=-1) {
  if (mod_key_array = -1) {
    mod_key_array := []
  }

  key := validate_key_arg("Binding()",key)
  mod_key_array := make_array(mod_key_array)
  return new BindingObject(key,mod_key_array)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Script - Key Bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;hkey := Binding("a",[Keyboard.RCTRL,Keyboard.RALT])
;var_msgbox(hkey.down.cmd)
;var_msgbox(hkey.up.cmd)
;hkey.emit()

bind_LeftRadial := Binding("q")
bind_RightRadial := Binding("e")

bind_QuickItem := []
bind_QuickItem[1] := Binding("Numpad1")
bind_QuickItem[2] := Binding("Numpad2")
bind_QuickItem[3] := Binding("Numpad3")
bind_QuickItem[4] := Binding("Numpad4")
bind_QuickItem[5] := Binding("Numpad5")
bind_QuickItem[6] := Binding("Numpad6")
bind_QuickItem[7] := Binding("Numpad7")
bind_QuickItem[8] := Binding("Numpad8")

; Change left radial bindings to RALT + numpad keys
bind_LeftRadial := []
bind_LeftRadial[1] := Binding("Numpad1",Keyboard.RALT)
bind_LeftRadial[2] := Binding("Numpad2",Keyboard.RALT)
bind_LeftRadial[3] := Binding("Numpad3",Keyboard.RALT)
bind_LeftRadial[4] := Binding("Numpad4",Keyboard.RALT)
bind_LeftRadial[5] := Binding("Numpad5",Keyboard.RALT)
bind_LeftRadial[6] := Binding("Numpad6",Keyboard.RALT)
bind_LeftRadial[7] := Binding("Numpad7",Keyboard.RALT)
bind_LeftRadial[8] := Binding("Numpad8",Keyboard.RALT)

; Change right radial bindings to RCTRL + numpad keys
bind_RightRadial[1] := Binding("Numpad1",Keyboard.RCTRL)
bind_RightRadial[2] := Binding("Numpad2",Keyboard.RCTRL)
bind_RightRadial[3] := Binding("Numpad3",Keyboard.RCTRL)
bind_RightRadial[4] := Binding("Numpad4",Keyboard.RCTRL)
bind_RightRadial[5] := Binding("Numpad5",Keyboard.RCTRL)
bind_RightRadial[6] := Binding("Numpad6",Keyboard.RCTRL)
bind_RightRadial[7] := Binding("Numpad7",Keyboard.RCTRL)
bind_RightRadial[8] := Binding("Numpad8",Keyboard.RCTRL)

class Radial
{
  static LEFT := 0
  static RIGHT := 1
}


class Weapon
{
  static ONE_HANDED := 1
  static TWO_HANDED := 2
  static STAFF := 3
  static BOW := 4
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Script - Aliases
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bind_Weapon := []
bind_Weapon[Weapon.STAFF]      :=  bind_QuickItem[1]
bind_Weapon[Weapon.BOW]        :=  bind_QuickItem[2]
bind_Weapon[Weapon.TWO_HANDED] :=  bind_QuickItem[3]
bind_Weapon[Weapon.ONE_HANDED] :=  bind_QuickItem[4]

bind_Mount := bind_QuickItem[7]
bind_Skinner := bind_QuickItem[8]

bind_ExplosiveArrow := bind_LeftRadial[1]
bind_ExploitWeakness := bind_LeftRadial[2]
bind_Puncture := bind_LeftRadial[3]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Script - Logic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CURRENT_WEAPON := Weapon.TWO_HANDED

isMelee()
{
  global
  return (   CURRENT_WEAPON = Weapon.ONE_HANDED
          || CURRENT_WEAPON = Weapon.TWO_HANDED)
}
isArchery()
{
  global
  return (CURRENT_WEAPON = Weapon.BOW)
}
setWeapon(weap)
{
  global
  CURRENT_WEAPON := weap
  bind_Weapon[weap].emit()
}

*MButton::
  mods := Keyboard.downMods()
  if (Keyboard.isDown(Keyboard.LALT,mods)) {
    setWeapon(Weapon.BOW)
  } else {
    setWeapon(Weapon.STAFF)
  }
  return

*WheelUp::
  setWeapon(Weapon.TWO_HANDED)
  return

*WheelDown::
  setWeapon(Weapon.ONE_HANDED)
  return

