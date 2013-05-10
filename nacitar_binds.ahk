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
  RBUTTON_TYPE := 1

  updateCache(update_cache) {
    if (update_cache) {
      Keyboard.cacheMod()
    }
  }
  onLButtonDown(update_cache=true) {
    this.updateCache(update_cache)

    this.LBUTTON_TYPE := 0
    if (Keyboard.isDownMod([Keyboard.LCTRL,Keyboard.LALT])) {
      Skill.Common.HealthToMana.instant()
    } else if (Keyboard.isDownMod(Keyboard.LCTRL)) {
      Skill.Common.StaminaToHealth.instant()
    } else if (Keyboard.isDownMod(Keyboard.LALT)) {
      Skill.Common.ManaToStamina.instant()
    } else {
      ; No mods; plain...
      this.LBUTTON_TYPE := 1
      ; press activate, but don't release
      Game.RadialActivate[RadialType.LEFT].down()
    }
    return true
  }
  onLButtonUp(update_cache=true) {
    this.updateCache(update_cache)
    ; release the activate key if it was down
    if (this.LBUTTON_TYPE = 1) {
      Game.RadialActivate[RadialType.LEFT].up()
      this.LBUTTON_TYPE := 0
    }
    return true
  }
  onRButtonDown(update_cache=true) {
    this.updateCache(update_cache)
    this.RBUTTON_TYPE := 0
    if ( Weapon.isMelee() ) {
      if (Keyboard.isDownMod(Keyboard.LALT)) {
        Skill.Common.DisablingBlow.press()
      } else {
        this.RBUTTON_TYPE:=1
        Game.Parry.down()
      }
      return true
    } else if ( Weapon.isBow() ) {
      if (Keyboard.isDownMod(Keyboard.LALT)) {
        Skill.Common.DisablingShot.press()
        return true
      }
    }
    return false
  }
  onRButtonUp(update_cache=true) {
    this.updateCache(update_cache)
    if (this.RBUTTON_TYPE = 1) {
      Game.Parry.up()
      this.RBUTTON_TYPE := 0
    }
    return true
  }
  onMButton(update_cache=true) {
    this.updateCache(update_cache)
    Weapon.set(ItemType.BOW)
    return true
  }
  onWheelUp(update_cache=true) {
    this.updateCache(update_cache)
    ; if alt is down, just let the normal function happen (map zooming, etc)
    if (!Keyboard.isDownMod(Keyboard.LALT)) {
      Weapon.set(ItemType.TWO_HANDED)
      return true
    }
    return false
  }
  onWheelDown(update_cache=true) {
    this.updateCache(update_cache)
    ; if alt is down, just let the normal function happen (map zooming, etc)
    if (!Keyboard.isDownMod(Keyboard.LALT)) {
      Weapon.set(ItemType.ONE_HANDED)
      return true
    }
    return false
  }
  onXButton1(update_cache=true) {
    this.updateCache(update_cache)
    return false
  }
  onXButton2(update_cache=true) {
    this.updateCache(update_cache)
    return false
  }
  onGrave(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LALT)) {
      Item.use(ItemType.SKINNER)
    } else {
      Game.ResetSkill.press() 
    }
    return true
  }
  on1(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LALT)) {
      Item.use(ItemType.FOOD)
      return true
    }
    return false
  }
  on2(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LALT)) {
      Item.use(ItemType.HEALTH_POT)
      return true
    }
    return false
  }
  on3(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LALT)) {
      Item.use(ItemType.STAMINA_POT)
      return true
    }
    return false
  }
  on4(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LALT)) {
      Item.use(ItemType.MANA_POT)
      return true
    }
    return false
  }
  on5(update_cache=true) {
    this.updateCache(update_cache)
    return false
  }
  on6(update_cache=true) {
    this.updateCache(update_cache)
    return false
  }
  on7(update_cache=true) {
    this.updateCache(update_cache)
    return false
  }
  on8(update_cache=true) {
    this.updateCache(update_cache)
    return false
  }
  on9(update_cache=true) {
    this.updateCache(update_cache)
    return false
  }
  on0(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LALT)) {
      Item.use(ItemType.MOUNT)
      return true
    }
    return false
  }
}
; Bindings for skirmishers
class SkirmisherBindsObject extends CommonBinds {
  onRButtonDown(update_cache=true) {
    this.updateCache(update_cache)
    if (Weapon.isBow()) {
      if (Keyboard.isDownMod([Keyboard.LCTRL,Keyboard.LALT])) {
        Skill.Deadeye.ExplosiveArrow.press()
      } else if (Keyboard.isDownMod(Keyboard.LCTRL)) {
        Skill.Deadeye.Puncture.press()
      } else if (Keyboard.isDownMod(Keyboard.LWIN)) {
        Skill.Deadeye.Salvo.press()
      ; NOTE: LALT bind is covered in base
      } else if (!base.onRButtonDown()) {
        Skill.Deadeye.ExploitWeakness.press()
      }
      return true
    }
    return base.onRButtonDown()
  }
  onXButton1(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LCTRL)) {
      Skill.Common.HealMount.instant()
    } else {
      Skill.Common.HealSelf.instant()
    }
    return true
  }
  onXButton2(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LALT)) {
      Skill.Brawler.Evade.instant()
    } else {
      Skill.Brawler.Dash.instant()
    }
    return true
  }
  on1(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LWIN)) {
      Skill.Brawler.Efficiency.instant()
      return true
    }
    return base.on1(false)
  }
  on2(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LWIN)) {
      Skill.Brawler.Leap.instant()
      return true
    } 
    return base.on2(false)
  }
}
SkirmisherBinds() {
  return new SkirmisherBindsObject()
}

; Bindings for warriors
class WarriorBindsObject extends CommonBinds {
  onRButtonDown(update_cache=true) {
    this.updateCache(update_cache)
    if (!base.onRButtonDown())
    {
      if (Keyboard.isDownMod(Keyboard.LWIN)) {
        Skill.Baresark.Maelstrom.instant()
        return true
      }
    } else {
      return true
    }
    return false
  }
  onXButton1(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LCTRL)) {
      Skill.Common.HealMount.instant()
    } else if (Keyboard.isDownMod(Keyboard.LALT)) {
      Skill.BattleBrand.Bandage.instant()
    } else {
      Skill.Common.HealSelf.instant()
    }
    return true
  }
  onXButton2(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LWIN)) {
      Skill.BattleBrand.StoicDefense.instant()
    } else if (Keyboard.isDownMod([Keyboard.LCTRL,Keyboard.LALT])) {
      Skill.Baresark.Roar.instant()
    } else if (Keyboard.isDownMod(Keyboard.LCTRL)) {
      Skill.Baresark.Repel.instant()
    } else if (Keyboard.isDownMod(Keyboard.LALT)) {
      Skill.BattleBrand.Foebringer.instant()
    } else {
      Skill.Baresark.Stampede.instant()
    }
    return true
  }
  on1(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LWIN)) {
      Skill.BattleBrand.StingingRiposte.instant()
      return true
    }
    return base.on1(false)
  }
  on2(update_cache=true) {
    this.updateCache(update_cache)
    if (Keyboard.isDownMod(Keyboard.LWIN)) {
      Skill.BattleBrand.Spellbane.instant()
      return true
    }
    return base.on2(false)
  }
}
WarriorBinds() {
  return new WarriorBindsObject()
}

; Setting these bindings for the Role object so it can swap them out.
Role.BindObjects[RoleType.SKIRMISHER] := SkirmisherBinds()
Role.BindObjects[RoleType.WARRIOR] := WarriorBinds()

