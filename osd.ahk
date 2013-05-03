
; Standalone OSD test implementation.

class Stopwatch {
  now() {
    return A_TickCount
  }

  elapsed(current,previous) {
    return current - previous
  }
}

; Gui controls that you want to modify after the fact _must_ have a variable
; associated with them; should be unique (within each window, anyway)
; This variable must be global or static, so there's no real good way to
; encapsulate this into an object... however, multiple windows can use
; the same variables, so you could do it that way.

; Not the most polished interface ever, but it works...
class GuiWindow {
  static invisibleColor := "EEAA99"
  __New(windowName) {
    this.windowName := windowName
    this.guiCmd("New","", "+AlwaysOnTop -Caption +ToolWindow")
    this.setLast()
    clr := GuiWindow.invisibleColor
    this.guiCmd("Color","",clr)
    WinSet, TransColor, %clr% 255
    ;this.guiCmd("Font","","s32")  ; Set a large font size (32-point).
  }

  setClickThrough(enabled=True) {
    this.setLast()
    if (enabled) {
      WinSet, ExStyle, +0x20
    } else {
      WinSet, ExStyle, -0x20
    }
  }

  show(x=0,y=0,activate=true) {
    windowName := this.windowName
    ; NoActivate avoids deactivating the currently active window.
    activate_str := ((activate)?(""):("NoActivate"))
    this.guiCmd("Show", " x"x " y"y " "activate_str)
  }
  setLast() {
    windowName := this.windowName
    this.guiCmd("+LastFound")
  }

  addText(text, gVar="", color="Lime") {
    vPart := ((gVar != "")?(" v"gVar):(""))
    this.guiCmd("Add","Text", vPart " c"color, text)
  }
  setText(text, gVar) {
    windowName := this.windowName
    GuiControl, %windowName%:Text, %gVar%, %text%
  }
  setProgress(value,gVar) {
    windowName := this.windowName
    GuiControl, %windowName%:, %gVar%, %value%
  }
  setImage(filename, gVar) {
    windowName := this.windowName
    GuiControl, %windowName%:, %gVar%, %filename%
  }
  guiCmd(command, subtype="", args="", extra="")
  {
    windowName := this.windowName
    if (args = "") {
      ; special case for simple commands
      if (subtype != "") {
        Gui, %windowName%:%command%, %subtype%
      } else {
        Gui, %windowName%:%command%
      }
    } else if (subtype != "") {
      if (extra != "") {
        Gui, %windowName%:%command%, %subtype%, %args%, %extra%
      } else {
        Gui, %windowName%:%command%, %subtype%, %args%
      }
    } else {
      if (extra != "") {
        Gui, %windowName%:%command%, %args%, %extra%
      } else {
        Gui, %windowName%:%command%, %args%
      }
    }
  }

  addImage(path,x,y,w,h,gVar="") {
    vPart := ((gVar != "")?(" v"gVar):(""))
    ;Gui, Add, Picture, x0 y0 w30 h30 +BackgroundTrans, %BAR_ONE_IMG_PATH%
    this.guiCmd("Add","Picture",vPart " x"x " y"y " w"w " h"h " +BackgroundTrans",path)
  }

  addProgress(x,y,w,h,min,max,gVar="") {
    vPart := ((gVar != "")?(" v"gVar):(""))
    ;Gui, Add, Progress, xp+40 yp+10 Range0-200 w300 h10 cRed Background%CustomColor% vBar_one, 0
    this.guiCmd("Add","Progress",vPart " x"x " y"y " w"w " h"h " cRed Background"GuiWindow.invisibleColor,0)
  }
}

image_path(relative_name) {
  return A_Scriptdir "/dfuw-icons/" relative_name
}

; define globals so they can be used as control identifiers
; autohotkey forces this terrible design upon us, it cannot be avoided.
SKILL_OVERLAY_IMAGE_1 := 0
SKILL_OVERLAY_PROGRESS_1 := 0
SKILL_OVERLAY_IMAGE_2 := 0
SKILL_OVERLAY_PROGRESS_2 := 0
SKILL_OVERLAY_IMAGE_3 := 0
SKILL_OVERLAY_PROGRESS_3 := 0
SKILL_OVERLAY_IMAGE_4 := 0
SKILL_OVERLAY_PROGRESS_4 := 0
SKILL_OVERLAY_IMAGE_5 := 0
SKILL_OVERLAY_PROGRESS_5 := 0
SKILL_OVERLAY_IMAGE_6 := 0
SKILL_OVERLAY_PROGRESS_6 := 0
SKILL_OVERLAY_IMAGE_7 := 0
SKILL_OVERLAY_PROGRESS_7 := 0
SKILL_OVERLAY_IMAGE_8 := 0
SKILL_OVERLAY_PROGRESS_8 := 0
SKILL_OVERLAY_IMAGE_9 := 0
SKILL_OVERLAY_PROGRESS_9 := 0
SKILL_OVERLAY_IMAGE_10 := 0
SKILL_OVERLAY_PROGRESS_10 := 0
SKILL_OVERLAY_IMAGE_11 := 0
SKILL_OVERLAY_PROGRESS_11 := 0
SKILL_OVERLAY_IMAGE_12 := 0
SKILL_OVERLAY_PROGRESS_12 := 0
SKILL_OVERLAY_IMAGE_13 := 0
SKILL_OVERLAY_PROGRESS_13 := 0
SKILL_OVERLAY_IMAGE_14 := 0
SKILL_OVERLAY_PROGRESS_14 := 0
SKILL_OVERLAY_IMAGE_15 := 0
SKILL_OVERLAY_PROGRESS_15 := 0
SKILL_OVERLAY_IMAGE_16 := 0
SKILL_OVERLAY_PROGRESS_16 := 0

; make a min-heap of skills on cooldown, sorted by their cooldown
; when a skill is added, adjust timer to min cooldown_ms / progress_samples
; when removed, adjust again, so we aren't working too hard.
; when all skills are off cooldown, stop the timer.

; Contains information about a skill
class Skill {
  __New(image_file,cooldown_ms,start_ms) {
    this.image_file := image_file
    this.cooldown_ms := cooldown_ms

    this.available := false
    this.start_ms := start_ms
  }
}
; Extra information about a skill for the overlay
class SkillOverlayMeta {
  __New(skill) {
    this.skill := skill
    this.available := true
    this.start_ms := 0
  }
}

class SkillOverlaySettings {
  icon_width := 32
  icon_height := 32
  row_spacing := 5
  transparency := 255
  progress_height := 10
  progress_width := 100
  progress_spacing := 5
  progress_samples := 200
}
; TODO: add other overlay options
class SkillOverlay {
  static ACTIVE_OVERLAYS := []

  skill_list := []
  timer_ms := 0
  __New(name,settings=-1) {
    if (settings = -1) {
      settings := new SkillOverlaySettings()
    }
    this.name := name
    this.settings := settings

    this.window := new GuiWindow(this.name) 
    this.window.setClickThrough()
   
    Loop, 16 {
      this.addControl(A_Index)
    }
    this.window.show()
    ; TODO
    ;SkillOverlay.ACTIVE_OVERLAYS.Insert(this)
  }

  clear() {
    this.skill_list := []
  }
  addSkill(skill) {
    this.skill_list.Insert(new SkillMeta(skill))
    ; get every tick
    ;timer_ms := skill.cooldown_ms / this.settings.progress_samples
  }

  skillImage(skill_num) {
    return "SKILL_OVERLAY_IMAGE_" skill_num
  }
  skillProgress(skill_num) {
    return "SKILL_OVERLAY_PROGRESS_" skill_num
  }

  addControl(skill_num) {
    y_offset := (this.settings.icon_height + this.settings.row_spacing) * (skill_num-1)
    bar_y_offset := (y_offset + (this.settings.icon_height - this.settings.progress_height))
    bar_x_offset := (this.settings.icon_width + this.settings.progress_spacing)
    this.window.addImage(image_path("skill/brawler/dash.png"),0,y_offset,this.settings.icon_width,this.settings.icon_height,this.skillImage(skill_num))
    this.window.addProgress(bar_x_offset,bar_y_offset,this.settings.progress_width,this.settings.progress_height,0,this.settings.progress_samples,this.skillProgress(skill_num))
    ;this.setProgress(50+skill_num,skill_num)
  }

  setProgress(value,skill_num) {
    this.window.setProgress(value,this.skillProgress(skill_num))
  }
}

the_overlay:=new SkillOverlay("testoverlay")
