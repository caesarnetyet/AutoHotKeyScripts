DoubleClick_Min=138

Text_ClicksBlocked=Clicks Blocked
Text_Debug=Debug
Text_Debug_OnlyBlocked=Debug (only blocked)

Menu, Tray, Add, %Text_ClicksBlocked%, DoubleClick_MenuSelect_ClicksBlocked
	Text_ClicksBlocked_MenuCurrent:=Text_ClicksBlocked
	Menu, Tray, Default, %Text_ClicksBlocked%
Menu, Tray, Add, %Text_Debug%, DoubleClick_MenuSelect_Debug
Menu, Tray, Add, %Text_Debug_OnlyBlocked%, DoubleClick_MenuSelect_Debug_OnlyBlocked
	Menu, Tray, Disable, %Text_Debug_OnlyBlocked%
Menu, Tray, Add
Menu, Tray, NoStandard
Menu, Tray, Standard

;//DoubleClick_Debug=1
;//DoubleClick_Debug_OnlyBlocked=1
;//Gosub, DoubleClick_MenuSelect_Debug
Gosub, DoubleClick_MenuSelect_Debug_OnlyBlocked

LButton::
MButton::
RButton::
;//LButton up;//:;//:
;//MButton up;//:;//:
;//RButton up;//:;//:
Critical
di++
TimeSinceLastMouseDown:=A_TickCount-LastMouseDown_ts
;//if (InStr(A_ThisHotkey, A_PriorHotkey) && A_TimeSincePriorHotkey<=DoubleClick_Min) {
;//if (InStr(A_PriorHotkey, A_ThisHotkey) && A_TimeSincePriorHotkey<=DoubleClick_Min) {
;//if (A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey<=DoubleClick_Min) {
if (A_ThisHotkey=LastMouseDown && TimeSinceLastMouseDown<=DoubleClick_Min) {
;//if (A_TimeSincePriorHotkey<=DoubleClick_Min) {
	msg=`nblocked
	blockeddown=1
	BlockedCount_Down++
	A_ThisHotkeyVarSafe:=RegExReplace(A_ThisHotkey, "i)[^a-z0-9_]")
	BlockedCount_%A_ThisHotkeyVarSafe%++
	Gosub, DoubleClick_UpdateStatus_ClicksBlocked
} else {
	Send, {%A_ThisHotkey% DownTemp}
	msg=`nSent, {%A_ThisHotkey% DownTemp}`n`n
	(LTrim C
		;//if (%A_TimeSincePriorHotkey%<=%DoubleClick_Min%)
		;//if (InStr(%A_PriorHotkey%, %A_ThisHotkey%) && %A_TimeSincePriorHotkey%<=%DoubleClick_Min%)
		;//if (%A_ThisHotkey%=%A_PriorHotkey% && %A_TimeSincePriorHotkey%<=%DoubleClick_Min%)
		if (%A_ThisHotkey%=%LastMouseDown% && %TimeSinceLastMouseDown%<=%DoubleClick_Min%)
	)
}
;//if (DoubleClick_Debug) {
	DoubleClick_DebugMsg_down=%di%: %A_ThisHotkey%(%TimeSinceLastMouseDown%)%LastMouseDown%%msg%
	msg=
	Gosub, DoubleClick_Debug
;//}
LastMouseDown:=A_ThisHotkey
LastMouseDown_ts:=A_TickCount
return

LButton up::
MButton up::
RButton up::
Critical
ui++
TimeSinceLastMouseUp:=A_TickCount-LastMouseUp_ts
;//if (A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey<=DoubleClick_Min) {
;//if (A_ThisHotkey=LastMouseUp && A_TimeSincePriorHotkey<=DoubleClick_Min) {
if (blockeddown) {
	msg=`nblocked
	blockedup=1
	BlockedCount_Up++
	A_ThisHotkeyVarSafe:=RegExReplace(A_ThisHotkey, "i)[^a-z0-9_]")
	BlockedCount_%A_ThisHotkeyVarSafe%++
	Gosub, DoubleClick_UpdateStatus_ClicksBlocked
} else {
	Send, {%A_ThisHotkey%}
	msg=`nSent, {%A_ThisHotkey%}
}
;//if (DoubleClick_Debug) {
	DoubleClick_DebugMsg_up=%ui%: %A_ThisHotkey%(%TimeSinceLastMouseUp%)%LastMouseUp%%msg%
	msg=
	Gosub, DoubleClick_Debug
;//}
blockeddown=
blockedup=
LastMouseUp:=A_ThisHotkey
LastMouseUp_ts:=A_TickCount
return

DoubleClick_Debug_ShowLastMsg:
;//DoubleClick_Debug_ShowLastMsg=1
DoubleClick_Debug:
CoordMode, Tooltip
if (A_ThisLabel="DoubleClick_Debug_ShowLastMsg" || (DoubleClick_Debug && (!DoubleClick_Debug_OnlyBlocked || (DoubleClick_Debug_OnlyBlocked && (blockeddown||blockedup)))))
	Tooltip, %DoubleClick_DebugMsg_down%`n`n%DoubleClick_DebugMsg_up%, 819, 619
else Tooltip
return

DoubleClick_UpdateStatus_ClicksBlocked:
BlockedCount_Total:=BlockedCount_Down+BlockedCount_Up
Text_ClicksBlocked_MenuNew=%Text_ClicksBlocked%: %BlockedCount_Total%
Menu, Tray, Rename, %Text_ClicksBlocked_MenuCurrent%, %Text_ClicksBlocked_MenuNew%
Text_ClicksBlocked_MenuCurrent:=Text_ClicksBlocked_MenuNew
Menu, Tray, Tip, %Text_ClicksBlocked_MenuCurrent% - %A_ScriptName%
return

DoubleClick_MenuSelect_ClicksBlocked:
msgbox, 64, ,
(LTrim C
	%Text_ClicksBlocked_MenuCurrent%

	Down(%BlockedCount_Down%)
	Up(%BlockedCount_Up%)

	LButton(%BlockedCount_LButton%)
	MButton(%BlockedCount_MButton%)
	RButton(%BlockedCount_RButton%)

	LButton up(%BlockedCount_LButtonup%)
	MButton up(%BlockedCount_MButtonup%)
	RButton up(%BlockedCount_RButtonup%)
)
return

DoubleClick_MenuSelect_Debug:
DoubleClick_Debug:=!DoubleClick_Debug
Menu, Tray, ToggleCheck, %Text_Debug%
Menu, Tray, ToggleEnable, %Text_Debug_OnlyBlocked%
Tooltip
return

DoubleClick_MenuSelect_Debug_OnlyBlocked:
DoubleClick_Debug_OnlyBlocked:=!DoubleClick_Debug_OnlyBlocked
Menu, Tray, ToggleCheck, %Text_Debug_OnlyBlocked%
Tooltip
return

/*
Menu:
msgbox, A_ThisMenu(%A_ThisMenu%) A_ThisMenuItem(%A_ThisMenuItem%)
if (A_ThisMenu && A_ThisMenuItem) {
	Menu_%A_ThisMenuItem%:=!Menu_%A_ThisMenuItem%
	Menu, %A_ThisMenu%, ToggleCheck, %A_ThisMenuItem%
} else {
	Menu_Default:=!Menu_Default
	Menu, Tray, ToggleCheck, %Text_Default%
}
return
*/

^+#!F8::Gosub, DoubleClick_Debug_ShowLastMsg
^+#!F9::Suspend