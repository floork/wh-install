#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#IfWinActive  ; Conditional activation based on the active window

; Kill Focused Window
#q::WinClose, A

; Open File Explorer
#e::Run, explorer.exe

; Open Command Prompt (Kitty in your case)
#x::Run, wt

; Open Visual Studio Code
#c::Run, code

; Open Discord (You may need to adjust the path)
#d::Run, "C:\Users\mrosf\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk"

; Open Thunderbird
#z::Run, "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Thunderbird.lnk"

; Open Firefox
#b::Run, "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Brave.lnk"

; Open Obsidian
#n::Run, "C:\Users\mrosf\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Obsidian.lnk"

; Open Screen Ruler
;#r::Run, psr.exe

; Start Screen Recording (Peek in your case)
;#^r::Run, "C:\Program Files (x86)\Peek\peek.exe"

#IfWinActive  ; End conditional activation
