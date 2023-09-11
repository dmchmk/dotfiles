#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Ctrl-Space to emit Win-Space which is used to switch keyboard layout
^space::#space

LCtrl & Tab:: AltTab

; remapping Ctrl-<num> to emit Win-<num> to switch between pinned apps
; on task panel
^1::Send #{1}
^2::Send #{2}
^3::Send #{3}
^4::Send #{4}
^5::Send #{5}
