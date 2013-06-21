
; match exact titles only
SetTitleMatchMode, 3
#IfWinActive, Darkfall Unholy Wars
#SingleInstance force
#NoEnv

; Disable windows key
$*LWin::
  return

; Disable alt-tab
!TAB::
  return
