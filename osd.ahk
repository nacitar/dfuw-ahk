

; Gui controls that you want to modify after the fact _must_ have a variable
; associated with them; should be unique (within each window, anyway)
; This variable must be global or static, so there's no real good way to
; encapsulate this into an object... however, multiple windows can use
; the same variables, so you could do it that way.

; Not the most polished interface ever, but it works...
class Overlay {
  static invisibleColor := "EEAA99"
  __New(windowName) {
    this.windowName := windowName
    this.guiCmd("New","", "+AlwaysOnTop -Caption +ToolWindow")
    this.setLast()
    clr := Overlay.invisibleColor
    this.guiCmd("Color","",clr)
    WinSet, TransColor, %clr% 255
    ;this.guiCmd("Font","","s32")  ; Set a large font size (32-point).
  }

  setClickThrough(enabled=True)
  {
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
    this.guiCmd("Add","Progress",vPart " x"x " y"y " w"w " h"h " cRed Background"Overlay.invisibleColor,50)
  }
}


something := ""
somethingImage := ""
somethingElse := ""
mywindow := new Overlay("argh")
mywindow.setClickThrough()
;window := new Overlay("argh2")
;something := ""
dash_file := A_Scriptdir "/image/dash.png"
mywindow.addText("I LIKE TURTLES","something")
mywindow.setText("WHAT","something")
mywindow.addImage(A_Scriptdir "/image/air.png",0,0,32,32,"somethingImage")
mywindow.addImage(dash_file,"p+32","p+32",32,32)
mywindow.addProgress("p+32","p+15",200,10,0,200,"somethingElse")
mywindow.setProgress(25,"somethingElse")
mywindow.setImage(dash_file,"somethingImage")
mywindow.show(0,0,false)

