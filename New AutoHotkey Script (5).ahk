#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; coord1 = 701,63 ;<- put your own values here
; coord2 = 80,85 ;<- put your own values here
; coord3 = 287,586 ;<- put your own values here
; idx = 0


; F9::
;   keywait, F9
;   idx++ ;<- next coord
;   if (idx > 3) ;<- wrap around
;     idx = 1
;   loc := coord%idx% ;<- get the coords
;   stringsplit xy,loc,`, ;<- turn it into x,y
;   click %xy1%,%xy2% ;<- click there
;   sleep 100
;   return

F9::createFolder()

createFolder(){
  click 701,63
  sleep, 250
  click 80,85
  sleep, 250
  click 287,586
  sleep, 250
  send, ^a
  send, ^v
  sleep, 250
  click 414,585
  sleep, 500
  click -375,380
  sleep, 250
  send, ^v

}

g:: send, ^v
return

c:: send, ^c ;copy
return

h:: Send, {Ctrl down}ac{Ctrl up} ;select all

v:: click 215,-263 ;vs code click

f16:: yui() ;browser click


yui(){
  click 563,151
  send, {END}
  sleep, 200
  send, z1
}



Joy5::crea()

crea(){
  send, {End}  
  sleep, 200
  send, {Right}
  sleep, 200
  send, {BackSpace}
  sleep, 200
  send, {End}


}
return

Joy7:: send ^z
return

Joy2:: send {End}
Joy3:: send {down}
Joy1:: send {up}