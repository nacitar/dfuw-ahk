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
; means if a user fails to redefine these to real hotkeys, trying to .emit()
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

class Radial
{
  ; Stores the currently selected radial 
  static CURRENT := 0
  ; Stores the radial of the most recently selected skill
  static LAST := 0
  ; Stores the last skill known to be selected on a given radial
  static LAST_SKILL := [ 0, 0 ]

  set(radial_type) {
    Radial.CURRENT := radial_type
    Game.Radial[radial_type].emit()
  }

  skill(radial_type,number) {
    if (number > 0 && number <= 8) {
      Radial.LAST := radial_type
      Radial.LAST_SKILL[radial_type] := number
      Game.RadialSkill[radial_type][number].emit()
    } else {
      raise_exception("Radial skill must be 1-8.  Forget to set ItemSlot?")
    }
  }

  activate(radial_type = -1) {
    if (radial_type = -1) {
      radial_type := Radial.LAST
    }
    Game.RadialActivate[radial_type].emit()
  }

  ; shortcut for skill + activate
  instant(radial_type,number) {
    Radial.skill(radial_type,number)
    Radial.activate(radial_type)
  }
}

class Item
{
  get(item_type) {
    return Game.QuickItem[Game.ItemSlot[item_type]]
  }
}

class Weapon
{
  ; Stores the currently equipped weapon
  static CURRENT := 1

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
    Item.get(weapon_type).emit()
  }
}

