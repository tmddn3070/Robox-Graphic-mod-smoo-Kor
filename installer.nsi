Unicode true

####################################################################
# Includes

!include MUI2.nsh
!include FileFunc.nsh
!include LogicLib.nsh

!insertmacro Locate
Var /GLOBAL switch_overwrite
!include MoveFileFolder.nsh

####################################################################
# File Info
!define PRODUCT_NAME "SMOO Roblox Graphic mod"
!define PRODUCT_DESCRIPTION "Shader presets and Graphic mod based on extravi,sitiom"
!define COPYRIGHT "Copyright © 2021 smoo"
!define VERSION "1.0.5"

VIProductVersion "${VERSION}.0"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIAddVersionKey "FileDescription" "${PRODUCT_DESCRIPTION}"
VIAddVersionKey "LegalCopyright" "${COPYRIGHT}"
VIAddVersionKey "FileVersion" "${VERSION}.0"

####################################################################
# Installer Attributes

Name "${PRODUCT_NAME}"
Outfile "Setup - ${PRODUCT_NAME}.exe"
Caption "Setup - ${PRODUCT_NAME}"
BrandingText "${PRODUCT_NAME}"

RequestExecutionLevel user
 
InstallDir "$LOCALAPPDATA\${PRODUCT_NAME}"

####################################################################
# Interface Settings

InstType "Full";1

####################################################################
# Pages
!define MUI_ICON "sit8.ico"
!define MUI_UNICON "sit8.ico"
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP "smoo.bmp"
!define MUI_WELCOMEPAGE_TEXT "This will install ${PRODUCT_NAME} on your computer.$\r$\n\
$\r$\n\
It is recommended that you close Roblox before continuing.$\r$\n\
$\r$\n\
Click Next to continue."
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_FINISHPAGE_TEXT_LARGE
!define MUI_FINISHPAGE_TEXT "Setup has finished installing ${PRODUCT_NAME} on your computer. The effects will be applied the next time you launch Roblox.$\r$\n\
$\r$\n\
Click Finish to exit Setup."
!define MUI_FINISHPAGE_SHOWREADME "https://www.youtube.com/channel/UCEuAqd2wL5QPBlc1dPiiBMg/featured"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Subscribe to smoo on Youtube"
!define MUI_FINISHPAGE_RUN
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "smoo-preset\license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!define MUI_PAGE_CUSTOMFUNCTION_SHOW "StartTaskbarProgress"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

####################################################################
# Language

!insertmacro MUI_LANGUAGE "English"


####################################################################
# Sections
RequestExecutionLevel admin
Var robloxPath

Section "ReShade (required)"
  SectionIn 1 RO
  
  SetOutPath $INSTDIR

  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; Uninstall Regkeys
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "DisplayIcon" "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "QuietUninstallString" "$INSTDIR\uninstall.exe /S"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "Publisher" "smoo"

  NSCurl::http GET "https://github.com/crosire/reshade-shaders/archive/refs/heads/master.zip" "reshade-shaders-master.zip" /END
  nsisunz::Unzip "reshade-shaders-master.zip" "$INSTDIR"


  NSCurl::http GET "https://github.com/prod80/prod80-ReShade-Repository/archive/refs/heads/master.zip" "prod80-ReShade-Repository-master.zip" /END
  nsisunz::Unzip "prod80-ReShade-Repository-master.zip" "$INSTDIR"

  
  NSCurl::http GET "https://github.com/martymcmodding/qUINT/archive/refs/heads/master.zip" "qUINT-master.zip" /END
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
 
  File "smoo-preset\opengl32.dll"
  File "smoo-preset\opengl32.log"
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
  Delete "$robloxPath\ReShade.ini"
  RMDir /r "$robloxPath\reshade-shaders"
  Delete "$robloxPath\opengl32.dll"
  Delete "$robloxPath\opengl32.log"
SectionEnd



####################################################################
# Functions

Function .onInit
  ${Locate} "$PROGRAMFILES\Roblox\Versions" "/L=F /M=RobloxPlayerBeta.exe" "Exit"

  StrCpy $robloxPath ""
  ${Locate} "$LOCALAPPDATA\Roblox\Versions" "/L=F /M=RobloxPlayerBeta.exe" "SetRobloxPath"  
  
  ${If} $robloxPath == ""
    MessageBox MB_ICONEXCLAMATION "Roblox installation not found. Install Roblox on https://www.roblox.com/download/client and try again."
    ExecShell open "https://www.roblox.com/download/client"
    Abort
  ${EndIf}
FunctionEnd

Function "Exit"
  MessageBox MB_ICONEXCLAMATION "Cannot install when Roblox is located in C:\Program Files (x86). Please reinstall Roblox as non-admin and try again."
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


