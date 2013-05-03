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
;Game.ItemSlot[ItemType.STAFF] := 0
Game.ItemSlot[ItemType.BOW] := 1
Game.ItemSlot[ItemType.TWO_HANDED] := 2
Game.ItemSlot[ItemType.ONE_HANDED] := 3
Game.ItemSlot[ItemType.MOUNT] := 4
Game.ItemSlot[ItemType.FOOD] := 5
Game.ItemSlot[ItemType.HEALTH_POT] := 6
Game.ItemSlot[ItemType.STAMINA_POT] := 7
Game.ItemSlot[ItemType.MANA_POT] := 8 ; same
Game.ItemSlot[ItemType.SKINNER] := 8 ; same

Game.ResetSkill := Binding("``") 
Game.Parry := Binding("v")
Game.AutoRun := Binding("NumpadSub")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Script - Logic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; CHANGE YOUR ROLE HERE
Role.set(RoleType.SKIRMISHER)

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

    done := false
    if ( Role.isWarrior() ) {
      ; assume done so we can handle it in the else
      done := true
      if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
        ; stinging riposte (warrior)
        Radial.skill(RadialType.LEFT,3)
      } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
        ; bandage (warrior)
        Radial.skill(RadialType.LEFT,2)
      } else {
        ; found nothing
        done := false
      }
    }
    ; if we didn't get a role-skill earlier, choose universal
    if (!done) {
      if (Keyboard.isDown(Keyboard.LALT,mods)) {
        ; disabling blow
        Radial.skill(RadialType.LEFT,5)
      } else {
        ; block
        RBUTTON_TYPE:=1
        Game.Parry.down.emit()
      }
    }
  } else if ( Weapon.isBow() ) {
    mods := Keyboard.downMods()
    done := false
    if ( Role.isSkirmisher() ) {
      done := true
      if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
        ; explosive arrow (skirmisher)
        Radial.skill(RadialType.LEFT,3)
      } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
        ; puncture (skirmisher)
        Radial.skill(RadialType.LEFT,2)
      } else {
        done := false
      }
    }
    ; need to check for disabling shot before doing the default
    if (!done) {
      if (Keyboard.isDown(Keyboard.LALT,mods)) {
        ; disabling shot
        Radial.skill(RadialType.LEFT,4)
        done := true
      }
    }
    if (!done) {
      if ( Role.isSkirmisher() ) {
        ; exploit weakness (skirmisher)
        Radial.skill(RadialType.LEFT,1)
      }
    }
  }
  return

$~*RButton up::
  if (RBUTTON_TYPE = 1) {
    ; parry
    Game.Parry.up.emit()
  }
  return

; Don't let us activate ourselves
$*`::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; skinner
    Item.get(ItemType.SKINNER).emit()
  } else {
    ; just default ` action
    Game.ResetSkill.emit() 
  }
  return
  
*MButton::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; not currently slotted
    Weapon.set(ItemType.STAFF)
  } else {
    Weapon.set(ItemType.BOW)
  }
  return

~*WheelUp::
  ; if alt is down, just let the normal function happen (map zooming, etc)
  if (!Keyboard.isDown(Keyboard.LALT)) {
    Weapon.set(ItemType.TWO_HANDED)
  }
  return

~*WheelDown::
  ; if alt is down, just let the normal function happen (map zooming, etc)
  if (!Keyboard.isDown(Keyboard.LALT)) {
    Weapon.set(ItemType.ONE_HANDED)
  }
  return

; let 0 through, we want to type
~*0::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; spawn mount
    Item.get(ItemType.MOUNT).emit()
  }
  return

~*1::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; eat food
    Item.get(ItemType.FOOD).emit()
  }
  return

~*2::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; drink health pot
    Item.get(ItemType.HEALTH_POT).emit()
  }
  return

~*3::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; drink stamina pot
    Item.get(ItemType.STAMINA_POT).emit()
  }
  return

~*4::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; drink mana pot
    Item.get(ItemType.MANA_POT).emit()
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
    ; efficiency (skirmisher)
    ; roar (warrior)
    Radial.instant(RadialType.RIGHT,1)
  } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
    ; leap (skirmisher)
    ; repel (warrior)
    Radial.instant(RadialType.RIGHT,8)
  } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
    ; evade (skirmisher)
    ; foebringer (warrior)
    Radial.instant(RadialType.RIGHT,7)
  } else {
    ; dash (skirmisher)
    ; stampede (warrior)
    Radial.instant(RadialType.RIGHT,6)
  }
  return
