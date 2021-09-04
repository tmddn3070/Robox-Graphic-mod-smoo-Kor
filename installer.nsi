Unicode true

!include MUI2.nsh
!include FileFunc.nsh
!include LogicLib.nsh

!insertmacro Locate
Var /GLOBAL switch_overwrite
!include MoveFileFolder.nsh

!define PRODUCT_NAME "SMOO Roblox Graphic mod"
!define PRODUCT_DESCRIPTION "Shader presets and Graphic mod based on extravi,sitiom"
!define COPYRIGHT "Copyright © 2021 SMOO"
!define VERSION "1.0.11"

VIProductVersion "${VERSION}.0"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIAddVersionKey "FileDescription" "${PRODUCT_DESCRIPTION}"
VIAddVersionKey "LegalCopyright" "${COPYRIGHT}"
VIAddVersionKey "FileVersion" "${VERSION}.0"


Name "${PRODUCT_NAME}"
Outfile "Setup - ${PRODUCT_NAME}.exe"
Caption "Setup - ${PRODUCT_NAME}"
BrandingText "${PRODUCT_NAME}"

RequestExecutionLevel admin
 
InstallDir "$LOCALAPPDATA\${PRODUCT_NAME}"
InstType "Full";1
!define MUI_ICON "setupicon.ico"
!define MUI_UNICON "setupicon.ico"
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP "smoo.bmp"
!define MUI_WELCOMEPAGE_TEXT "이 설치기는 당신의 컴퓨터에 ${PRODUCT_NAME}를 설치할것입니다 .$\r$\n\
$\r$\n\
이 설치를 계속하기 전에 로블록스를 종료하는것이 좋습니다.$\r$\n\
$\r$\n\
계속하려면 다음을 클릭하세요."


!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_FINISHPAGE_TEXT_LARGE
!define MUI_FINISHPAGE_TEXT "컴퓨터에 ${PRODUCT_NAME}가 성공적으로 설치가 완료되었습니다.$\r$\n\
$\r$\n\
마침을 클릭하여 이 설치기를 종료합니다."
!define MUI_FINISHPAE_RUN
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "smoo-preset\license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!define MUI_PAGE_CUSTOMFUNCTION_SHOW "StartTaskbarProgress"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "Korean"

Var robloxPath

Section "ReShade (required)"
  SectionIn 1 RO
  
  SetOutPath $INSTDIR

  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; Uninstall Regkeys
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\smoo-presets" "DisplayIcon" "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\smoo-presets" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\smoo-presets" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\smoo-presets" "QuietUninstallString" "$INSTDIR\uninstall.exe /S"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\smoo-presets" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\smoo-presets" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\smoo-presets" "Publisher" "smoo"

  NSCurl::http GET "https://file.sutp.xyz/Roblox%20Graphic%20MOD/archive/reshade-shaders-master.zip" "reshade-shaders-master.zip" /END
  nsisunz::Unzip "reshade-shaders-master.zip" "$INSTDIR"


  NSCurl::http GET "https://file.sutp.xyz/Roblox%20Graphic%20MOD/archive/prod80-ReShade-Repository-master.zip" "prod80-ReShade-Repository-master.zip" /END
  nsisunz::Unzip "prod80-ReShade-Repository-master.zip" "$INSTDIR"


  NSCurl::http GET "https://file.sutp.xyz/Roblox%20Graphic%20MOD/archive/qUINT-master.zip" "qUINT-master.zip" /END
  nsisunz::Unzip "qUINT-master.zip" "$INSTDIR"


  StrCpy $switch_overwrite 1

  !insertmacro MoveFolder "reshade-shaders-master\Shaders" "$robloxPath\reshade-shaders\Shaders" "*"
  !insertmacro MoveFolder "reshade-shaders-master\Textures" "$robloxPath\reshade-shaders\Textures" "*"
  RMDir /r "$INSTDIR\reshade-shaders-master"

  !insertmacro MoveFolder "prod80-ReShade-Repository-master\Shaders" "$robloxPath\reshade-shaders\Shaders" "*"
  !insertmacro MoveFolder "prod80-ReShade-Repository-master\Textures" "$robloxPath\reshade-shaders\Textures" "*"
  RMDir /r "$INSTDIR\prod80-ReShade-Repository-master"

  !insertmacro MoveFolder "qUINT-master\Shaders" "$robloxPath\reshade-shaders\Shaders" "*"
  RMDir /r "$INSTDIR\qUINT-master"
 SetOutPath $robloxPath
 
  File "smoo-preset\dxgi.dll"
  File "smoo-preset\dxgi.log"
  File "smoo-preset\ReShade.ini"
SectionEnd

SectionGroup /e "Presets"
  Section "VeryLow"
    SectionIn 1
    File "smoo-preset\smoo-very-low.ini"
  SectionEnd
  Section "Low"
    SectionIn 1
    File "smoo-preset\smoo-low.ini"
  SectionEnd
   Section "Medium"
    SectionIn 1
    File "smoo-preset\smoo-medium.ini"
  SectionEnd
    Section "High"
    SectionIn 1
    File "smoo-preset\smoo-High.ini"
  SectionEnd
    Section "Ultra"
    SectionIn 1
    File "smoo-preset\smoo-Ultra.ini"
  SectionEnd
    Section "Very-Ultra"
     SectionIn 1
    File "smoo-preset\smoo-Very-Ultra.ini"
  SectionEnd
    Section "Hyper-Ultra"
     SectionIn 1
    File "smoo-preset\smoo-Hyper-Ultra.ini"
  SectionEnd
    Section "NEW SMOO(Alpha version)"
     SectionIn 1
    File "smoo-preset\new-smoo-preset(Alpha).ini"
  SectionEnd
SectionGroupEnd

Section "uninstall"
  ${Locate} "$LOCALAPPDATA\Roblox\Versions" "/L=F /M=RobloxPlayerBeta.exe" "un.SetRobloxPath"

  Delete "$INSTDIR\uninstall.exe"
  RMDir /r $INSTDIR

  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\smoo-preset"

  Delete "$robloxPath\smoo-very-low.ini"
  Delete "$robloxPath\smoo-low.ini"
  Delete "$robloxPath\smoo-medium.ini"
  Delete "$robloxPath\smoo-High.ini"
  Delete "$robloxPath\smoo-Ultra.ini"
  Delete "$robloxPath\smoo-Very-Ultra.ini"
  Delete "$robloxPath\smoo-Hyper-Ultra.ini"
  Delete "$robloxPath\ReShade.ini"
  RMDir /r "$robloxPath\reshade-shaders"
  Delete "$robloxPath\opengl32.dll"
  Delete "$robloxPath\opengl32.log"
SectionEnd

Function .onInit
  ${Locate} "$PROGRAMFILES\Roblox\Versions" "/L=F /M=RobloxPlayerBeta.exe" "Exit"

  StrCpy $robloxPath ""
  ${Locate} "$LOCALAPPDATA\Roblox\Versions" "/L=F /M=RobloxPlayerBeta.exe" "SetRobloxPath"  
  
  ${If} $robloxPath == ""
    MessageBox MB_ICONEXCLAMATION "Roblox를 찾지 못하였습니다. Roblox가 설치되어있는지 확인하고 다시 시도하세요."
    ExecShell open "https://www.roblox.com/download/client"
    Abort
  ${EndIf}
FunctionEnd

Function "Exit"
  MessageBox MB_ICONEXCLAMATION "로블록스 설치경로가 C:\Program Files (x86)에 있는경우 설치할 수 없습니다. 관리자가 아닌 계정으로 로블록스를 설치하시고 다시시도하세요."
  Abort
FunctionEnd

Function "SetRobloxPath"
  SetOutPath $R8
  StrCpy $robloxPath $R8
  StrCpy $0 StopLocate
  Push $0
FunctionEnd
Function "un.SetRobloxPath"
  SetOutPath $R8
  StrCpy $robloxPath $R8
  StrCpy $0 StopLocate
  Push $0
FunctionEnd

Function "StartTaskbarProgress"
  w7tbp::Start
FunctionEnd


