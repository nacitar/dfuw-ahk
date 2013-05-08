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


#Include %A_ScriptDir%/nacitar_binds.ahk

; match exact titles only
SetTitleMatchMode, 3
#IfWinActive, Darkfall Unholy Wars
#SingleInstance force
#NoEnv

#HotkeyInterval 1 
#MaxHotkeysPerInterval 2000

; On first run, make the darkfall window not always on top.  If you restart
; your game, reloading this script will set this again.
WinSet, AlwaysOnTop, Off, Darkfall Unholy Wars

; Keep numlock on!
SetNumLockState, AlwaysOn

; Default role (TODO: make this save/restore from file?)
; TODO: allow on-the-fly changing
Role.set(RoleType.SKIRMISHER)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Hotkeys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; block the windows key!
$*LWin::
  return

$*NumLock::
  Game.AutoRun.press()
  return

$~*LButton::
  Role.Binds.onLButtonDown()
  return

$~*LButton up::
  Role.Binds.onLButtonUp()
  return

$~*RButton::
  Role.Binds.onRButtonDown()
  return

$~*RButton up::
  Role.Binds.onRButtonUp()
  return

$~*MButton::
  Role.Binds.onMButton()
  return

$~*WheelUp::
  Role.Binds.onWheelUp()
  return

$~*WheelDown::
  Role.Binds.onWheelDown()
  return

$~*XButton1::
  Role.Binds.onXButton1()
  return

$~*XButton2::
  Role.Binds.onXButton2()
  return

$~*`::
  Role.Binds.onGrave()
  return
  
$~*1::
  Role.Binds.on1()
  return

$~*2::
  Role.Binds.on2()
  return

$~*3::
  Role.Binds.on3()
  return

$~*4::
  Role.Binds.on4()
  return

$~*5::
  Role.Binds.on5()
  return

$~*6::
  Role.Binds.on6()
  return

$~*7::
  Role.Binds.on7()
  return

$~*8::
  Role.Binds.on8()
  return

$~*9::
  Role.Binds.on9()
  return

$~*0::
  Role.Binds.on0()
  return

