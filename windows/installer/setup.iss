[Setup]
AppId={{8A9B7F2C-3D4E-5F6A-7B8C-9D0E1F2A3B4C}
AppName=Trackich
AppVersion=1.0.0
AppPublisher=Trackich Team
AppPublisherURL=https://github.com/iivgll/Trackich
AppSupportURL=https://github.com/iivgll/Trackich/issues
AppUpdatesURL=https://github.com/iivgll/Trackich/releases
DefaultDirName={autopf}\Trackich
DisableProgramGroupPage=yes
LicenseFile=..\..\LICENSE
OutputDir=..\..\dist\windows
OutputBaseFilename=trackich-windows-installer
SetupIconFile=..\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\Trackich"; Filename: "{app}\Trackich.exe"
Name: "{autodesktop}\Trackich"; Filename: "{app}\Trackich.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\Trackich.exe"; Description: "{cm:LaunchProgram,Trackich}"; Flags: nowait postinstall skipifsilent