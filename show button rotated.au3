#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>

Global Const $AC_SRC_ALPHA = 1

Global Const $PNG = @ScriptDir & "\test-img.png"
$hGUI = GUICreate("The Main Gui pic", 500, 500, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED,$WS_EX_TOPMOST))
GUISetCursor(0)
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST") ; Register notification messages
GUISetState()

_GDIPlus_Startup()
$hImage = _GDIPlus_ImageLoadFromFile($PNG)
$iWidth = _GDIPlus_ImageGetWidth($hImage)
$iHeight = _GDIPlus_ImageGetHeight($hImage)


#cs
;fade in png background
For $i = 0 To 255 Step 20
	SetBitmap($GUI, $hImage, $i)
	Sleep(30)
Next
#ce

Global $iAngel = 0
While 1
	$Bitmap = _GDIPlus_BitmapCreateFromFile(@ScriptDir & "\transparent.png")
	$BitmapContext = _GDIPlus_ImageGetGraphicsContext($Bitmap)
	_GDIPlus_GraphicsSetSmoothingMode($BitmapContext, 2) ; Require Windows Vista or later
	$hMatrix = _GDIPlus_MatrixCreate()
	_GDIPlus_MatrixTranslate($hMatrix, $iWidth / 2, $iHeight / 2)
	_GDIPlus_MatrixRotate($hMatrix, $iAngel)
	_GDIPlus_GraphicsSetTransform($BitmapContext, $hMatrix)
	;_GDIPlus_GraphicsClear($BitmapContext, 0xF0F0F0F0)
	_GDIPlus_GraphicsDrawImage($BitmapContext, $hImage, -($iWidth / 2), - ($iHeight/2)) ;Draw rotate + Chinh goc toa do de quay
	;_GDIPlus_ImageResize($BitmapContext, $iWidth, $iHeight)

	SetBitmap($hGUI, $Bitmap, 255) ; Draw in gui
	_GDIPlus_MatrixDispose($hMatrix)
	_GDIPlus_GraphicsDispose($BitmapContext)
	_GDIPlus_BitmapDispose($Bitmap)
	$iAngel += 5
	Sleep(10)
WEnd

Func SetBitmap($hGUI, $hImage, $iOpacity)
    Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

    $hScrDC = _WinAPI_GetDC(0)
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSize = DllStructCreate($tagSIZE)
    $pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
    DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
    $tSource = DllStructCreate($tagPOINT)
    $pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    $pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $iOpacity)
    DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap

; ====================================================================================================
; Handle the WM_NCHITTEST for the layered window so it can be dragged by clicking anywhere on the image.
; ====================================================================================================
Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
    If ($hWnd = $hGUI) And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
EndFunc   ;==>WM_NCHITTEST