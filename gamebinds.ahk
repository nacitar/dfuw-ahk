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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game Settings - Key Bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Game.Radial[RadialType.LEFT] := Binding("q")
Game.Radial[RadialType.RIGHT] := Binding("e")

Game.RadialActivate[RadialType.LEFT] := Binding("AppsKey")
Game.RadialActivate[RadialType.RIGHT] := Binding("Numpad0")

Game.QuickItem[1] := Binding([Keyboard.RCTRL,"F1"])
Game.QuickItem[2] := Binding([Keyboard.RCTRL,"F2"])
Game.QuickItem[3] := Binding([Keyboard.RCTRL,"F3"])
Game.QuickItem[4] := Binding([Keyboard.RCTRL,"F4"])
Game.QuickItem[5] := Binding([Keyboard.RCTRL,"F5"])
Game.QuickItem[6] := Binding([Keyboard.RCTRL,"F6"])
Game.QuickItem[7] := Binding([Keyboard.RCTRL,"F7"])
Game.QuickItem[8] := Binding([Keyboard.RCTRL,"F8"])

; Change left radial bindings to RALT + numpad keys
Game.RadialSkill[RadialType.LEFT][1] := Binding([Keyboard.RALT,"Numpad1"])
Game.RadialSkill[RadialType.LEFT][2] := Binding([Keyboard.RALT,"Numpad2"])
Game.RadialSkill[RadialType.LEFT][3] := Binding([Keyboard.RALT,"Numpad3"])
Game.RadialSkill[RadialType.LEFT][4] := Binding([Keyboard.RALT,"Numpad4"])
Game.RadialSkill[RadialType.LEFT][5] := Binding([Keyboard.RALT,"Numpad5"])
Game.RadialSkill[RadialType.LEFT][6] := Binding([Keyboard.RALT,"Numpad6"])
Game.RadialSkill[RadialType.LEFT][7] := Binding([Keyboard.RALT,"Numpad7"])
Game.RadialSkill[RadialType.LEFT][8] := Binding([Keyboard.RALT,"Numpad8"])

; Change right radial bindings to RCTRL + numpad keys
Game.RadialSkill[RadialType.RIGHT][1] := Binding([Keyboard.RCTRL,"Numpad1"])
Game.RadialSkill[RadialType.RIGHT][2] := Binding([Keyboard.RCTRL,"Numpad2"])
Game.RadialSkill[RadialType.RIGHT][3] := Binding([Keyboard.RCTRL,"Numpad3"])
Game.RadialSkill[RadialType.RIGHT][4] := Binding([Keyboard.RCTRL,"Numpad4"])
Game.RadialSkill[RadialType.RIGHT][5] := Binding([Keyboard.RCTRL,"Numpad5"])
Game.RadialSkill[RadialType.RIGHT][6] := Binding([Keyboard.RCTRL,"Numpad6"])
Game.RadialSkill[RadialType.RIGHT][7] := Binding([Keyboard.RCTRL,"Numpad7"])
Game.RadialSkill[RadialType.RIGHT][8] := Binding([Keyboard.RCTRL,"Numpad8"])

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
;; User Script - Skill Placement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; these must be set _after_ the radials bound above

; Skirmisher Skills
; (left 7 is free)
Skill.Brawler.Dash.set(               RadialBinding(RadialType.RIGHT,6))
Skill.Brawler.Efficiency.set(         RadialBinding(RadialType.RIGHT,1))
Skill.Brawler.Evade.set(              RadialBinding(RadialType.RIGHT,7))
Skill.Brawler.Leap.set(               RadialBinding(RadialType.RIGHT,8))
;Skill.Brawler.HeightenedReflexes.set ...
Skill.Deadeye.ExploitWeakness.set(RadialBinding(RadialType.LEFT,1))
Skill.Deadeye.ExplosiveArrow.set( RadialBinding(RadialType.LEFT,3))
Skill.Deadeye.Puncture.set(       RadialBinding(RadialType.LEFT,2))
Skill.Deadeye.Salvo.set(          RadialBinding(RadialType.LEFT,6))
;Skill.Deadeye.Trueshot.set ...

; Warrior Skills
; (none free)
Skill.BattleBrand.Bandage.set(        RadialBinding(RadialType.RIGHT,1))
Skill.BattleBrand.Foebringer.set(     RadialBinding(RadialType.LEFT ,6))
Skill.BattleBrand.Spellbane.set(      RadialBinding(RadialType.RIGHT,8))
Skill.BattleBrand.StingingRiposte.set(RadialBinding(RadialType.RIGHT,7))
Skill.BattleBrand.StoicDefense.set(   RadialBinding(RadialType.RIGHT,6))

Skill.Baresark.Maelstrom.set( RadialBinding(RadialType.LEFT,2))
Skill.Baresark.Roar.set(      RadialBinding(RadialType.LEFT,1)) 
Skill.Baresark.Stampede.set(  RadialBinding(RadialType.LEFT,7))
Skill.Baresark.Repel.set(     RadialBinding(RadialType.LEFT,3))
;Skill.Baresark.Pulverize.set ...

; Primalist Skills
; TODO

; Common Skills
Skill.Common.HealSelf.set(        RadialBinding(RadialType.RIGHT,2))
Skill.Common.HealMount.set(       RadialBinding(RadialType.LEFT ,8))
Skill.Common.ManaToStamina.set(   RadialBinding(RadialType.RIGHT,3))
Skill.Common.StaminaToHealth.set( RadialBinding(RadialType.RIGHT,4))
Skill.Common.HealthToMana.set(    RadialBinding(RadialType.RIGHT,5))
Skill.Common.DisablingBlow.set(   RadialBinding(RadialType.LEFT ,5))
Skill.Common.DisablingShot.set(   RadialBinding(RadialType.LEFT ,4))


