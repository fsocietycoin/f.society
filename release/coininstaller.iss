; Coin Install Script
; Review the Code carefully when adopting to a new coin. 
; 
; written 2014 by fruor
; I'm not responsible for any setup/installer written with the help of this script
; 
; place this file together with a .conf file for the users wallets in the folder
; where your windows binaries reside (the ones users can download)
; open the .iss file with Inno Setup and compile, output will go to a subfolder called \SETUP

; Choose a name that will match Program Files Folder, the Start Menu Items and the Uninstall Info
#define ProgramName "fsociety"

; Enter the Version Number of your binaries
#define VersionNumber "0.7.2"

; Enter the Name of the Folder created in \Appdata\Roaming where your binaries will place the user files, including wallet, conf file, blockchain info etc.
#define RoamingName "fsociety"

; Enter the Name of the main QT-File
#define QTexe "fsociety-qt.exe"

; Subfolder with additional files such as an extra folder for daemon
; Do not include \ symbol it will be added later
; If no subfolder is needed use #define SubDir ""
#define SubDir ""

; Enter the Name of the config file you wish to include                 
#define configfile "fsociety.conf"


[Setup]
AppName={#ProgramName}
AppVersion={#VersionNumber}
DefaultDirName={pf32}\{#ProgramName}
DefaultGroupName={#ProgramName}
UninstallDisplayIcon={app}\{#QTexe}
Compression=lzma2
SolidCompression=yes
OutputDir=SETUP

[Files]
Source: "*"; DestDir: "{app}"; Components: main; Excludes: "*.iss"
Source: {#configfile}; DestDir: "{userappdata}\{#RoamingName}"; Components: config; Flags: uninsneveruninstall


[Icons]
Name: "{group}\{#ProgramName}"; Filename: "{app}\{#QTexe}"
Name: "{group}\Uninstall"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#ProgramName}"; Filename: "{app}\{#QTexe}"; WorkingDir: "{app}"; Tasks: desktopicon/common
Name: "{userdesktop}\{#ProgramName}"; Filename: "{app}\{#QTexe}"; WorkingDir: "{app}"; Tasks: desktopicon/user

[Tasks]
Name: desktopicon; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}" 
Name: desktopicon\common; Description: "For all users"; GroupDescription: "Additional icons:"; Flags: exclusive 
Name: desktopicon\user; Description: "For the current user only"; GroupDescription: "Additional icons:"; Flags: exclusive unchecked

[Components]
Name: main; Description: Main Program; Types: full compact custom; Flags: fixed
Name: daemon; Description: Daemon files; Types: full compact custom
Name: config; Description: A config file including nodes to synchronize with the network; Types: full custom

[Code]
var
  ImportWalletFileName: String;
  Targetfile: String;


function WalletImport: Boolean;
begin

  Targetfile := ExpandConstant('{userappdata}\{#RoamingName}\wallet.dat');
  if not FileExists(Targetfile) then 
  begin
    if MsgBox('No Wallet has been found. Would you like to import an existing wallet? If you skip this step a wallet will be created once {#ProgramName} is started.',mbConfirmation,MB_YESNO) = IDYES then
        begin
          ImportWalletFileName := '';
          if GetOpenFileName('', ImportWalletFileName, '', 'wallet files (*.dat)|*.dat|All Files|*.*', 'dat') then
           begin
            if not FileExists(Targetfile) then
              begin
                FileCopy (expandconstant(ImportWalletFileName), Targetfile, false);
              end
              else
              begin
                MsgBox('Wallet already exists, skipping import', mbInformation, MB_OK);
              end;
            end;
        end;
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin 
  Result := True;
  if CurPageID = wpFinished then
     Result := WalletImport;
end;

[Run]
Filename: "{app}\{#QTexe}"; Flags: postinstall skipifsilent nowait
