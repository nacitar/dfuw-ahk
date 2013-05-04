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

#Include %A_ScriptDir%/settings.ahk
; match exact titles only
SetTitleMatchMode, 3

#IfWinActive, Darkfall Unholy Wars
#SingleInstance force
#NoEnv
WinSet, AlwaysOnTop, Off, Darkfall Unholy Wars

#HotkeyInterval 1 
#MaxHotkeysPerInterval 2000

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
  Game.AutoRun.press()
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
    Skill.Common.HealthToMana.instant()
  } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
    Skill.Common.StaminaToHealth.instant()
  } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
    Skill.Common.ManaToStamina.instant()
  } else {
    ; No mods; plain...
    LBUTTON_TYPE:=1
    ; press activate, but don't release
    Game.RadialActivate[RadialType.LEFT].down()
  }
  return

$~*LButton up::
  ; release it now
  if (LBUTTON_TYPE = 1) {
    Game.RadialActivate[RadialType.LEFT].up()
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
        Game.Parry.down()
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
    Game.Parry.up()
  }
  return

; Don't let us activate ourselves
$*`::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; skinner
    Item.use(ItemType.SKINNER)
  } else {
    ; just default ` action
    Game.ResetSkill.press() 
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
    Item.use(ItemType.MOUNT)
  }
  return

~*1::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; eat food
    Item.use(ItemType.FOOD)
  }
  return

~*2::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; drink health pot
    Item.use(ItemType.HEALTH_POT)
  }
  return

~*3::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; drink stamina pot
    Item.use(ItemType.STAMINA_POT)
  }
  return

~*4::
  if (Keyboard.isDown(Keyboard.LALT)) {
    ; drink mana pot
    Item.use(ItemType.MANA_POT)
  }
  return

$*XButton1::
  if (Keyboard.isDown(Keyboard.LALT)) {
    Skill.Common.HealMount.instant()
  } else {
    Skill.Common.HealSelf.instant()
  }
  return

$*XButton2::
  mods := Keyboard.downMods()
  if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
    ; roar (warrior)
    Skill.Brawler.Efficiency.instant()
  } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
    ; repel (warrior)
    Skill.Brawler.Leap.instant()
  } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
    ; foebringer (warrior)
    Skill.Brawler.Evade.instant()
  } else {
    ; stampede (warrior)
    Skill.Brawler.Dash.instant()
  }
  return
