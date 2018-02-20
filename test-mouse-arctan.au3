#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 589, 413, 218, 148)
GUISetFont(14, 400, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel("[-]", 288, 144, 20, 28)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetCursor (-1, 0)
$Label2 = GUICtrlCreateLabel("Degree:", 88, 344, 72, 28)
$Label3 = GUICtrlCreateLabel("Label3", 168, 344, 348, 28)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#include <Misc.au3>
Local $PI = 3.141592653589793
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Label1
			$aControlPos = ControlGetPos($Form1, "", $Label1)
			$iControlX = $aControlPos[0] + $aControlPos[2]/2
			$iControlY = $aControlPos[1] + $aControlPos[3]/2

			While _IsPressed(01)
				$aMouseInfo = GUIGetCursorInfo()
				$iMouseX = $aMouseInfo[0]
				$iMouseY = $aMouseInfo[1]
				$Degree = CalcDegree($iControlX, $iControlY, $iMouseX, $iMouseY)
				;$c = Ceiling(Sqrt(($iControlX-$iMouseX)*($iControlX-$iMouseX) + ($iControlY-$iMouseY)*($iControlY-$iMouseY)))
				;$Degree = ASin(-($iControlX-$iMouseX)/$c) * 180 / $PI
				GUICtrlSetData($Label3, $Degree)
				Sleep(50)
			WEnd
	EndSwitch
WEnd

Func CalcDegree($iControlX, $iControlY, $iMouseX, $iMouseY)
	Local $Degree = ATan(-($iMouseX-$iControlX)/($iMouseY-$iControlY)) * 180 / 3.141592653589793; góc phần tư thứ I, II
	If $iMouseY >= $iControlY Then
		$Degree = 180 + $Degree
	ElseIf $iMouseX < $iControlX And $iMouseY < $iControlY Then
		$Degree = 360 + $Degree
	EndIf
	Return $Degree
EndFunc

Func WM_LBUTTONDOWN($hWnd, $iMsg, $wParam, $lParam)
    #forceref $hWnd, $iMsg, $wParam
    $g_iMouseX = BitAND($lParam, 0x0000FFFF)
    $g_iMouseY = BitShift($lParam, 16)
	ConsoleWrite("$hWnd = " & $hWnd & @CRLF)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_LBUTTONDOWN

Func WM_LBUTTONUP($hWnd, $iMsg, $wParam, $lParam)
    #forceref $hWnd, $iMsg, $wParam
    $g_iMouseX = BitAND($lParam, 0x0000FFFF)
    $g_iMouseY = BitShift($lParam, 16)
	ConsoleWrite("$hWnd = " & $hWnd & @CRLF)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_LBUTTONDOWNs
