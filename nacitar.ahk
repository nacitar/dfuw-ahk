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

#Include %A_ScriptDir%/dfuw.ahk

#IfWinActive, Darkfall Unholy Wars
#SingleInstance force
#NoEnv

#HotkeyInterval 1 
#MaxHotkeysPerInterval 2000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Script - Key Bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Game.Radial[RadialType.LEFT] := Binding("q")
Game.Radial[RadialType.RIGHT] := Binding("e")

Game.RadialActivate[RadialType.LEFT] := Binding("AppsKey")
Game.RadialActivate[RadialType.RIGHT] := Binding("Numpad0")

Game.QuickItem[1] := Binding("F1",Keyboard.RCTRL)
Game.QuickItem[2] := Binding("F2",Keyboard.RCTRL)
Game.QuickItem[3] := Binding("F3",Keyboard.RCTRL)
Game.QuickItem[4] := Binding("F4",Keyboard.RCTRL)
Game.QuickItem[5] := Binding("F5",Keyboard.RCTRL)
Game.QuickItem[6] := Binding("F6",Keyboard.RCTRL)
Game.QuickItem[7] := Binding("F7",Keyboard.RCTRL)
Game.QuickItem[8] := Binding("F8",Keyboard.RCTRL)

; Change left radial bindings to RALT + numpad keys
Game.RadialSkill[RadialType.LEFT][1] := Binding("Numpad1",Keyboard.RALT)
Game.RadialSkill[RadialType.LEFT][2] := Binding("Numpad2",Keyboard.RALT)
Game.RadialSkill[RadialType.LEFT][3] := Binding("Numpad3",Keyboard.RALT)
Game.RadialSkill[RadialType.LEFT][4] := Binding("Numpad4",Keyboard.RALT)
Game.RadialSkill[RadialType.LEFT][5] := Binding("Numpad5",Keyboard.RALT)
Game.RadialSkill[RadialType.LEFT][6] := Binding("Numpad6",Keyboard.RALT)
Game.RadialSkill[RadialType.LEFT][7] := Binding("Numpad7",Keyboard.RALT)
Game.RadialSkill[RadialType.LEFT][8] := Binding("Numpad8",Keyboard.RALT)

; Change right radial bindings to RCTRL + numpad keys
Game.RadialSkill[RadialType.RIGHT][1] := Binding("Numpad1",Keyboard.RCTRL)
Game.RadialSkill[RadialType.RIGHT][2] := Binding("Numpad2",Keyboard.RCTRL)
Game.RadialSkill[RadialType.RIGHT][3] := Binding("Numpad3",Keyboard.RCTRL)
Game.RadialSkill[RadialType.RIGHT][4] := Binding("Numpad4",Keyboard.RCTRL)
Game.RadialSkill[RadialType.RIGHT][5] := Binding("Numpad5",Keyboard.RCTRL)
Game.RadialSkill[RadialType.RIGHT][6] := Binding("Numpad6",Keyboard.RCTRL)
Game.RadialSkill[RadialType.RIGHT][7] := Binding("Numpad7",Keyboard.RCTRL)
Game.RadialSkill[RadialType.RIGHT][8] := Binding("Numpad8",Keyboard.RCTRL)

; Which quick item slots for which weapons?
Game.WeaponSlot[WeaponType.STAFF] := 1
Game.WeaponSlot[WeaponType.BOW] := 2
Game.WeaponSlot[WeaponType.TWO_HANDED] := 3
Game.WeaponSlot[WeaponType.ONE_HANDED] := 4

Game.ResetSkill := Binding("``") 
Game.Parry := Binding("v")
Game.AutoRun := Binding("NumpadSub")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Script - Logic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; block the windows key!
*LWin::
  return

; Keep numlock on!
SetNumLockState, AlwaysOn

; Forward numlock presses to numpad -
*NumLock::
  Game.AutoRun.emit()
  return

; You can't block mouse buttons, so unset mbutton skill selection or
; you'll end up accidentally changing items!

; Don't block clicks! Darkfall gets this still, but you can't click out!
; Don't let us activate ourselves either

; Keep up with modifiers on the down so we do the right up
LBUTTON_TYPE:=1
RBUTTON_TYPE:=1

; Don't let us activate ourselves
$~*LButton::
  LBUTTON_TYPE:=0
  mods := Keyboard.downMods()
  if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
    ; health to mana
    Radial.instant(RadialType.RIGHT,5)
  } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
    ; stamina to health
    Radial.instant(RadialType.RIGHT,4)
  } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
    ; mana to stamina
    Radial.instant(RadialType.RIGHT,3)
  } else {
    ; No mods; plain...
    LBUTTON_TYPE:=1
    ; press activate, but don't release
    Game.RadialActivate[RadialType.LEFT].down.emit()
  }
  return

$~*LButton up::
  ; release it now
  if (LBUTTON_TYPE = 1) {
    Game.RadialActivate[RadialType.LEFT].up.emit()
  }
  return

$~*RButton::
  RBUTTON_TYPE:=0
  if ( Weapon.isMelee() ) {
    mods := Keyboard.downMods()
    if (Keyboard.isDown(Keyboard.LALT,mods)) {
      Radial.skill(RadialType.LEFT,5)
    } else {
      RBUTTON_TYPE:=1
      Game.Parry.down.emit()
    }
  } else if ( Weapon.isBow() ) {
    mods := Keyboard.downMods()
    if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
      ; explosive arrow
      Radial.skill(RadialType.LEFT,3)
    } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
      ; puncture
      Radial.skill(RadialType.LEFT,2)
    } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
      ; disabling shot
      Radial.skill(RadialType.LEFT,4)
    } else {
      ; exploit weakness
      Radial.skill(RadialType.LEFT,1)
    }
  }
  return

$~*RButton up::
  if (RBUTTON_TYPE = 1) {
    Game.Parry.up.emit()
  }
  return

; Don't let us activate ourselves
$*`::
  if (Keyboard.isDown(Keyboard.LALT)) {
    Game.QuickItem[8].emit()
  } else {
    Game.ResetSkill.emit() 
  }
  return
  
*MButton::
  if (Keyboard.isDown(Keyboard.LALT)) {
    Weapon.set(WeaponType.BOW)
  } else {
    Weapon.set(WeaponType.STAFF)
  }
  return

~*WheelUp::
  ; if alt is down, just let the normal function happen (map zooming, etc)
  if (!Keyboard.isDown(Keyboard.LALT)) {
    Weapon.set(WeaponType.TWO_HANDED)
  }
  return

~*WheelDown::
  ; if alt is down, just let the normal function happen (map zooming, etc)
  if (!Keyboard.isDown(Keyboard.LALT)) {
    Weapon.set(WeaponType.ONE_HANDED)
  }
  return

; let 0 through, we want to type
~*0::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; spawn mount
    Game.QuickItem[7].emit()
  }
  return

$*XButton1::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; Heal mount
    Radial.instant(RadialType.LEFT,8)
  } else {
    ; heal self
    Radial.instant(RadialType.RIGHT,2)
  }
  return

$*XButton2::
  mods := Keyboard.downMods()
  if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
    ; efficiency
    Radial.instant(RadialType.RIGHT,1)
  } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
    ; leap
    Radial.instant(RadialType.RIGHT,8)
  } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
    ; evade
    Radial.instant(RadialType.RIGHT,7)
  } else {
    ; dash
    Radial.instant(RadialType.RIGHT,6)
  }
  return
