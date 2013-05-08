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

; NOTE: you can't declare variables _after_ even one hotkey is declared, it 
; will silently ignore it.

; You can't block mouse buttons, so unset mbutton skill selection or
; you'll end up accidentally changing items!

; Don't block clicks! Darkfall gets this still, but you can't click out!


#Include %A_ScriptDir%/settings.ahk

; match exact titles only
SetTitleMatchMode, 3
#IfWinActive, Darkfall Unholy Wars
#SingleInstance force
#NoEnv

; On first run, make the darkfall window not always on top.  If you restart
; your game, reloading this script will set this again.
WinSet, AlwaysOnTop, Off, Darkfall Unholy Wars

#HotkeyInterval 1 
#MaxHotkeysPerInterval 2000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Script - Logic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Keep numlock on!
SetNumLockState, AlwaysOn

class CommonBinds {
  ; Keep up with modifiers on the down so we do the correct up
  LBUTTON_TYPE := 1

  onLButtonDown() {
    this.LBUTTON_TYPE := 0
    mods := Keyboard.downMods()
    if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
      Skill.Common.HealthToMana.instant()
    } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
      Skill.Common.StaminaToHealth.instant()
    } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
      Skill.Common.ManaToStamina.instant()
    } else {
      ; No mods; plain...
      this.LBUTTON_TYPE := 1
      ; press activate, but don't release
      Game.RadialActivate[RadialType.LEFT].down()
    }
  }
  onLButtonUp() {
    ; release the activate key if it was down
    if (this.LBUTTON_TYPE = 1) {
      Game.RadialActivate[RadialType.LEFT].up()
      this.LBUTTON_TYPE := 0
    }
  }
  onRButtonDown() {
  }
  onRButtonUp() {
  }
  onMButton() {
    mods := Keyboard.downMods()
    if (Keyboard.isDown(Keyboard.LALT,mods)) {
      Weapon.set(ItemType.STAFF)
    } else {
      Weapon.set(ItemType.BOW)
    }
  }
  onWheelUp() {
    ; if alt is down, just let the normal function happen (map zooming, etc)
    if (!Keyboard.isDown(Keyboard.LALT)) {
      Weapon.set(ItemType.TWO_HANDED)
    }
  }
  onWheelDown() {
    ; if alt is down, just let the normal function happen (map zooming, etc)
    if (!Keyboard.isDown(Keyboard.LALT)) {
      Weapon.set(ItemType.ONE_HANDED)
    }
  }
  onXButton1() {
    mods := Keyboard.downMods()
    if (Keyboard.isDown(Keyboard.LALT,mods)) {
      Skill.Common.HealMount.instant()
    } else {
      Skill.Common.HealSelf.instant()
    }
  }
  onXButton2() {
  }
}
class SkirmisherBindsObject extends CommonBinds {
  RBUTTON_TYPE := 1

  onRButtonDown() {
    this.RBUTTON_TYPE := 0
    if ( Weapon.isMelee() ) {
      mods := Keyboard.downMods()
      if (Keyboard.isDown(Keyboard.LALT,mods)) {
        Skill.Common.DisablingBlow.press()
      } else {
        this.RBUTTON_TYPE := 1
        Game.Parry.down()
      }
    } else if ( Weapon.isBow() ) {
      mods := Keyboard.downMods()
      if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
        Skill.Deadeye.ExplosiveArrow.press()
      } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
        Skill.Deadeye.Puncture.press()
      } else if (Keyboard.isDown(Keyboard.LWIN,mods)) {
        Skill.Deadeye.Salvo.press()
      } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
        Skill.Common.DisablingShot.press()
      } else {
        Skill.Deadeye.ExploitWeakness.press()
      }
    }
  }

  onRButtonUp() {
    if (this.RBUTTON_TYPE = 1) {
      Game.Parry.up()
      this.RBUTTON_TYPE := 0
    }
  }

  onXButton2() {
    mods := Keyboard.downMods()
    if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
      Skill.Brawler.Efficiency.instant()
    } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
      Skill.Brawler.Leap.instant()
    } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
      Skill.Brawler.Evade.instant()
    } else {
      Skill.Brawler.Dash.instant()
    }
  }
}
SkirmisherBinds() {
  return new SkirmisherBindsObject()
}

class WarriorBinds extends CommonBinds {
  RBUTTON_TYPE := 1

  onRButtonDown() {
    this.RBUTTON_TYPE := 0
    if ( Weapon.isMelee() ) {
      mods := Keyboard.downMods()
      if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
        Skill.BattleBrand.StingingRiposte.press()
      } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
        Skill.BattleBrand.Bandage.press()
      } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
        Skill.Common.DisablingBlow.press()
      } else {
        this.RBUTTON_TYPE:=1
        Game.Parry.down()
      }
    } else if ( Weapon.isBow() ) {
      mods := Keyboard.downMods()
      if (Keyboard.isDown(Keyboard.LALT,mods)) {
        Skill.Common.DisablingShot.press()
      }
    }
  }
  onRButtonUp() {
    if (this.RBUTTON_TYPE = 1) {
      Game.Parry.up()
      this.RBUTTON_TYPE := 0
    }
  }

  onXButton2() {
    mods := Keyboard.downMods()
    if (Keyboard.isDown([Keyboard.LCTRL,Keyboard.LALT],mods)) {
      Skill.Baresark.Roar.instant()
    } else if (Keyboard.isDown(Keyboard.LCTRL,mods)) {
      Skill.Baresark.Repel.instant()
    } else if (Keyboard.isDown(Keyboard.LALT,mods)) {
      Skill.BattleBrand.Foebringer.instant()
    } else {
      Skill.Baresark.Stampede.instant()
    }
  }
}


RoleBinds := SkirmisherBinds()

; block the windows key!
*LWin::
  return

; Forward numlock presses to numpad -
*NumLock::
  Game.AutoRun.press()
  return

; Don't let us activate ourselves
$~*LButton::
  RoleBinds.onLButtonDown()
  return

$~*LButton up::
  RoleBinds.onLButtonUp()
  return

$~*RButton::
  RoleBinds.onRButtonDown()
  return

$~*RButton up::
  RoleBinds.onRButtonUp()
  return

$*XButton1::
  RoleBinds.onXButton1()
  return

*MButton::
  RoleBinds.onMButton()
  return

~*WheelUp::
  RoleBinds.onWheelUp()
  return

~*WheelDown::
  RoleBinds.onWheelDown()
  return

$~*XButton2::
  RoleBinds.onXButton2()
  return

; Don't let us activate ourselves
$*`::
  if (Keyboard.isDown(Keyboard.LALT)) {
    Item.use(ItemType.SKINNER)
  } else {
    Game.ResetSkill.press() 
  }
  return
  
; let 0 through, we want to type
~*0::
  if (Keyboard.isDown(Keyboard.LALT)) {
    Item.use(ItemType.MOUNT)
  }
  return

~*1::
  if (Keyboard.isDown(Keyboard.LALT)) {
    Item.use(ItemType.FOOD)
  }
  return

~*2::
  if (Keyboard.isDown(Keyboard.LALT)) {
    Item.use(ItemType.HEALTH_POT)
  }
  return

~*3::
  if (Keyboard.isDown(Keyboard.LALT)) {
    Item.use(ItemType.STAMINA_POT)
  }
  return

~*4::
  if (Keyboard.isDown(Keyboard.LALT)) {
    Item.use(ItemType.MANA_POT)
  }
  return
