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

#Include %A_ScriptDir%/framework.ahk

; TODO: allow omitting weapon slots

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Darkfall Unholy Wars 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

class ItemType { ; enum
  static STAFF := 1
  static BOW := 2
  static TWO_HANDED := 3
  static ONE_HANDED := 4
  static MOUNT := 5
  static FOOD := 6
  static HEALTH_POT := 7
  static STAMINA_POT := 8
  static MANA_POT := 9
  static SKINNER := 10
}
class RadialType { ; enum
  static LEFT := 1
  static RIGHT := 2
}
; Stores game bindings
class Game
{
  static WindowTitle := "Darkfall Unholy Wars"
  static QuickItem := []
  static Radial := []
  static RadialActivate := []
  static RadialSkill := [ [], [] ] ; [RadialType][number]
  static ItemSlot := []

  static ResetSkill := Binding()
  static Parry := Binding()
  static AutoRun := Binding()

}
; Create dummy hotkeys for known functions we are writing scripts for; this
; means if a user fails to redefine these to real hotkeys, trying to use
; them will result in an error about emitting an empty KeySeq (good!) instead
; of giving no error at all and silently doing nothing (bad!)
Game.QuickItem[1] := Binding()
Game.QuickItem[2] := Binding()
Game.QuickItem[3] := Binding()
Game.QuickItem[4] := Binding()
Game.QuickItem[5] := Binding()
Game.QuickItem[6] := Binding()
Game.QuickItem[7] := Binding()
Game.QuickItem[8] := Binding()

Game.Radial[RadialType.LEFT] := Binding()
Game.Radial[RadialType.RIGHT] := Binding()
Game.RadialActivate[RadialType.LEFT] := Binding()
Game.RadialActivate[RadialType.RIGHT] := Binding()
Game.RadialSkill[RadialType.LEFT][1] := Binding()
Game.RadialSkill[RadialType.LEFT][2] := Binding()
Game.RadialSkill[RadialType.LEFT][3] := Binding()
Game.RadialSkill[RadialType.LEFT][4] := Binding()
Game.RadialSkill[RadialType.LEFT][5] := Binding()
Game.RadialSkill[RadialType.LEFT][6] := Binding()
Game.RadialSkill[RadialType.LEFT][7] := Binding()
Game.RadialSkill[RadialType.LEFT][8] := Binding()
Game.RadialSkill[RadialType.RIGHT][1] := Binding()
Game.RadialSkill[RadialType.RIGHT][2] := Binding()
Game.RadialSkill[RadialType.RIGHT][3] := Binding()
Game.RadialSkill[RadialType.RIGHT][4] := Binding()
Game.RadialSkill[RadialType.RIGHT][5] := Binding()
Game.RadialSkill[RadialType.RIGHT][6] := Binding()
Game.RadialSkill[RadialType.RIGHT][7] := Binding()
Game.RadialSkill[RadialType.RIGHT][8] := Binding()
; Dummy weapon slots, if using setQuickItem(), this index causes an error
Game.ItemSlot[ItemType.STAFF] := 0
Game.ItemSlot[ItemType.BOW] := 0
Game.ItemSlot[ItemType.TWO_HANDED] := 0
Game.ItemSlot[ItemType.ONE_HANDED] := 0
Game.ItemSlot[ItemType.MOUNT] := 0
Game.ItemSlot[ItemType.FOOD] := 0
Game.ItemSlot[ItemType.HEALTH_POT] := 0
Game.ItemSlot[ItemType.STAMINA_POT] := 0
Game.ItemSlot[ItemType.MANA_POT] := 0
Game.ItemSlot[ItemType.SKINNER] := 0

class RadialBindingObject {
  ; NOTE: caches hotkeys at this time
  __New(radial_type,number) {
    this.radial_binding := Game.RadialSkill[radial_type][number]
    this.radial_activate := Game.RadialActivate[radial_type]
  }

  down() {
    this.radial_binding.down()
  }
  up() {
    this.radial_binding.up()
  }
  press() {
    this.radial_binding.press()
  }

  ; also activates
  instant() {
    this.press()
    this.radial_activate.press()
  }
}
RadialBinding(radial_type,number) {
  return new RadialBindingObject(radial_type,number)
}

class Radial {
  ; Stores the currently selected radial 
  static CURRENT := 0
  ; Stores the radial of the most recently selected skill
  static LAST := 0
  ; Stores the last skill known to be selected on a given radial
  static LAST_SKILL := [ 0, 0 ]

  set(radial_type) {
    Radial.CURRENT := radial_type
    Game.Radial[radial_type].press()
  }

  skill(radial_type,number) {
    if (number > 0 && number <= 8) {
      Radial.LAST := radial_type
      Radial.LAST_SKILL[radial_type] := number
      Game.RadialSkill[radial_type][number].press()
    } else {
      raise_exception("Radial skill must be 1-8.  Forget to set ItemSlot?")
    }
  }

  activate(radial_type = -1) {
    if (radial_type = -1) {
      radial_type := Radial.LAST
    }
    Game.RadialActivate[radial_type].press()
  }

  ; shortcut for skill + activate
  instant(radial_type,number) {
    Radial.skill(radial_type,number)
    Radial.activate(radial_type)
  }
}

class Item {
  get(item_type) {
    return Game.QuickItem[Game.ItemSlot[item_type]]
  }
  use(item_type) {
    this.get(item_type).press()
  }
}

class RoleType { ; enum
  static SKIRMISHER := 1
  static WARRIOR := 2
  static ELEMENTALIST := 3
  static PRIMALIST := 4
}
class Role {
  static CURRENT := RoleType.SKIRMISHER 

  set(role_type) {
    Role.CURRENT := role_type
  }

  isSkirmisher() {
    return (Role.CURRENT = RoleType.SKIRMISHER)
  }

  isWarrior() {
    return (Role.CURRENT = RoleType.WARRIOR)
  }

  isElementalist() {
    return (Role.CURRENT = RoleType.ELEMENTALIST)
  }

  isPrimalist() {
    return (Role.CURRENT = RoleType.PRIMALIST)
  }
}

class Weapon {
  ; Stores the currently equipped weapon
  static CURRENT := ItemType.ONE_HANDED

  ; methods mostly for convenience
  isOneHanded() {
    return (Weapon.CURRENT = ItemType.ONE_HANDED)
  }
  isTwoHanded() {
    return (Weapon.CURRENT = ItemType.TWO_HANDED)
  }
  isBow() {
    return (Weapon.CURRENT = ItemType.BOW)
  }
  isStaff() {
    return (Weapon.CURRENT = ItemType.STAFF)
  }
  ; 1h or 2h
  isMelee() {
    return (Weapon.isOneHanded() || Weapon.isTwoHanded())
  }

  set(weapon_type) {
    Weapon.CURRENT := weapon_type
    Item.use(weapon_type)
  }
}


; TODO: track whether we're currently casting or not
class SkillInfoObject {
  __New(name,image_file,cast_ms,cooldown_ms,binding) {
    this.name := name
    this.cast_ms := cast_ms
    this.cooldown_ms := cooldown_ms
    this.image_file := image_file
    this.binding := binding

    ; TODO: figure out how to incorporate this
    this.overlays := []
  }
  set(binding,cast_ms=-1,cooldown_ms=-1) {
    this.binding := binding
    if (cast_ms != -1) {
      this.cast_ms := cast_ms
    }
    if (cooldown_ms != -1) {
      this.cooldown_ms := cooldown_ms
    }
  }
  startCooldown() {
    Loop, % this.overlays.MaxIndex() {
      this.overlays[A_Index].startCooldown(this)
    }
  }

  down() {
    this.binding.down()
  }
  up() {
    this.binding.up()
  }

  press() {
    this.binding.press()
  }

  instant() {
    this.binding.instant()
  }
}
SkillInfo(name,image_file="",cast_ms=0,cooldown_ms=0,binding=-1) {
  if (binding = -1) {
    binding := Binding()
  }
  return new SkillInfoObject(name,image_file,cast_ms,cooldown_ms,binding)
}

class IconDirWrapperObject {
  __New(basedir) {
    this.basedir := basedir
  }
  get(relative_path="") {
    return this.basedir "/" relative_path
  }
}
IconDirWrapper(basedir="") {
    if (basedir = "") {
      basedir := A_ScriptDir "/dfuw-icons"
    }
    return new IconDirWrapperObject(basedir)
}

class BrawlerSkillObject {
  static base_dir := IconDirWrapper(IconDirWrapper().get("skill/brawler"))
  Dash := SkillInfo("Dash",this.base_dir.get("dash.png"))
  Efficiency := SkillInfo("Efficiency",this.base_dir.get("efficiency.png"))
  Evade := SkillInfo("Evade",this.base_dir.get("evade.png"))
  Leap := SkillInfo("Leap",this.base_dir.get("leap.png"))
  HeightenedReflexes := SkillInfo("Heightened Reflexes"
                        ,this.base_dir.get("heightened_reflexes.png"))
}
BrawlerSkill() {
  return new BrawlerSkillObject()
}
class CommonSkillObject {
  static base_dir := IconDirWrapper(IconDirWrapper().get("skill/common"))
  HealSelf := SkillInfo("Heal Self",this.base_dir.get("heal_self.png"))
  HealMount := SkillInfo("Heal Mount",this.base_dir.get("heal_mount.png"))
  ManaToStamina := SkillInfo("Mana To Stamina"
                   ,this.base_dir.get("mana_to_stamina.png"))
  StaminaToHealth := SkillInfo("Stamina To Health"
                     ,this.base_dir.get("stamina_to_health.png"))
  HealthToMana := SkillInfo("Health To Mana"
                  ,this.base_dir.get("health_to_mana.png"))
}
CommonSkill() {
  return new CommonSkillObject()
}

class Skill {
  static Brawler := BrawlerSkill()
  static Common := CommonSkill()
}
