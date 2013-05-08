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
;; User Script - Skill Placement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; these must be set _after_ the radials bound above
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

; TODO: hotkeys
;Skill.BattleBrand.Bandage.set ...
;Skill.BattleBrand.Foebringer.set ...
;Skill.BattleBrand.Spellbane.set ...
;Skill.BattleBrand.StingingRiposte.set ...
;Skill.BattleBrand.StoicDefense.set ...
;Skill.Baresark.Maelstrom.set ...
;Skill.Baresark.Pulverize.set ...
;Skill.Baresark.Roar.set ...
;Skill.Baresark.Stampede.set ...
;Skill.Baresark.Repel.set ...

Skill.Common.HealSelf.set(        RadialBinding(RadialType.RIGHT,2))
Skill.Common.HealMount.set(       RadialBinding(RadialType.LEFT ,8))
Skill.Common.ManaToStamina.set(   RadialBinding(RadialType.RIGHT,3))
Skill.Common.StaminaToHealth.set( RadialBinding(RadialType.RIGHT,4))
Skill.Common.HealthToMana.set(    RadialBinding(RadialType.RIGHT,5))
Skill.Common.DisablingBlow.set(   RadialBinding(RadialType.LEFT ,5))
Skill.Common.DisablingShot.set(   RadialBinding(RadialType.LEFT ,4))


; Default role
Role.set(RoleType.SKIRMISHER)

