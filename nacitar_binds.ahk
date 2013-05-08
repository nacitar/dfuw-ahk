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

#Include %A_ScriptDir%/gamebinds.ahk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Script - Role Bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Bindings for all roles (can be overridden)
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
; Bindings for skirmishers
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

; Bindings for warriors
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

; Setting these bindings for the Role object so it can swap them out.
Role.BindObjects[Role.SKIRMISHER] := SkirmisherBinds()
Role.BindObjects[Role.WARRIOR] := WarriorBinds()

