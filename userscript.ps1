#<powershell>
# Allow use of Write-Verbose
[CmdletBinding()]
Param()

# Only tested with Powershell V4
#requires -version 4.0
Set-StrictMode -Version Latest  # Helps to catch errors

# Directories
# $MY_HOME is needed because user-data starts up as SYSTEM user which is *not* Administrator.
$MY_HOME = "C:\Users\Administrator"
$DOWNLOADS = "$MY_HOME\Downloads"
$SSH_DIR = "$MY_HOME\.ssh"
$TREES = "$MY_HOME\trees"
$MC_REPO = "$TREES\mozilla-central"

# Versions
$MOZILLABUILD_VERSION = "2.0.0"
$NOTEPADPP_MAJOR_VER = "6"
$NOTEPADPP_VERSION = "$NOTEPADPP_MAJOR_VER.8.3"
$FXDEV_ARCH = "64"
$FXDEV_VERSION = "43.0a2"  # Change the URL in the $FXDEV_FTP variable as well.

# Programs
$FXDEV_FILENAME = "firefox-$FXDEV_VERSION.en-US.win$FXDEV_ARCH.installer.exe"
$MOZ_FTP = "https://ftp.mozilla.org/pub/mozilla.org"
$FXDEV_FTP = "$MOZ_FTP/firefox/nightly/2015/09/2015-09-23-00-40-24-mozilla-aurora/$FXDEV_FILENAME"
$FXDEV_FILE_WITH_DIR = "$DOWNLOADS\$FXDEV_FILENAME"
$GIT_ARCH = "32"
$GIT_VERSION = "2.5.3"
$GIT_FILENAME = "Git-$GIT_VERSION-$GIT_ARCH-bit.exe"
$GIT_FTP = "https://github.com/git-for-windows/git/releases/download/v$GIT_VERSION.windows.1/$GIT_FILENAME"
$GIT_FILE_WITH_DIR = "$DOWNLOADS\$GIT_FILENAME"
# Get list of names by running the following in PowerShell:
#   [Environment+SpecialFolder]::GetNames([Environment+SpecialFolder])
# From https://msdn.microsoft.com/en-us/library/system.environment.specialfolder.aspx
$GIT_BINARY = [Environment]::GetFolderPath("ProgramFilesX86") + "\Git\bin\git.exe"

# MozillaBuild
# For 32-bit, use "start-shell-msvc2013.bat". For 64-bit, use "start-shell-msvc2013-x64.bat"
$MOZILLABUILD_INSTALLDIR = "C:\mozilla-build"
$MOZILLABUILD_GENERIC_START = "start-shell.bat"
$MOZILLABUILD_GENERIC_START_FULL_PATH = "$MOZILLABUILD_INSTALLDIR\fz-$MOZILLABUILD_GENERIC_START"
$MOZILLABUILD_START_SCRIPT = "start-shell-msvc2013.bat"
#$MOZILLABUILD_START_SCRIPT = "start-shell-msvc2013-x64.bat"
$MOZILLABUILD_START_SCRIPT_FULL_PATH = "$MOZILLABUILD_INSTALLDIR\fz-$MOZILLABUILD_START_SCRIPT"
$HG_BINARY = "$MOZILLABUILD_INSTALLDIR\python\Scripts\hg.bat"

Function DownloadBinary ($binName, $location) {
    # .DESCRIPTION
    # Downloads binaries.
    $wc = New-Object net.webclient  # Download prerequisites by not using Invoke-WebRequest (slow)
    Write-Verbose "Downloading $binName ..."
    if (-not (Test-Path $location)) {
        $wc.Downloadfile($binName, $location)
        Write-Verbose "Finished downloading to $location ."
    } else {
        Write-Verbose "$location already exists!"
    }
}

Function InstallBinary ($binName) {
    # .DESCRIPTION
    # Installs NSIS programs using the /S switch.
    Write-Verbose "Installing $binName ..."
    & $binName /S | out-null
    Write-Verbose "Finished installing $binName ."
}

Function ExtractArchive ($fileName, $dirName) {
    # .DESCRIPTION
    # Extracts archives using 7-Zip in mozilla-build directory.
    Write-Verbose "Extracting $fileName ..."
    (C:\mozilla-build\7zip\7z.exe x -y -o"$dirName" $fileName) | out-null
    Write-Verbose "Finished extracting $fileName ."
}

Function ConvertToUnicodeNoBOM ($fileName) {
    # .DESCRIPTION
    # Converts files to Unicode without BOM.
    # Adapted from http://stackoverflow.com/a/5596984
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
    [System.IO.File]::WriteAllLines($fileName,
                                    (Get-Content $fileName), $Utf8NoBomEncoding)
}

Write-Verbose "Setting up configurations..."
# Windows Registry settings
# Disable the Windows Error Dialog
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\Windows Error Reporting' -Name DontShowUI -Value 1 | out-null
# Turn on crash dumps
New-Item -Path 'HKLM:\Software\Microsoft\Windows\Windows Error Reporting' -Name LocalDumps | out-null
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\Windows Error Reporting\LocalDumps' -Name DumpCount -Value 500 | out-null
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\Windows Error Reporting\LocalDumps' -Name DumpType -Value 1 | out-null
# Get Group Policy Settings Reference from http://www.microsoft.com/en-us/download/details.aspx?id=25250
# Disable Application Compatibility Engine and Program Compatibility Assistant
New-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows' -Name AppCompat | out-null
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name DisableEngine -Value 1 | out-null
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name DisablePCA -Value 1 | out-null
& gpupdate /force | out-null

# Create a shortcut to ~ in Favorites. Adapted from http://stackoverflow.com/a/9701907
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$MY_HOME\Links\Administrator.lnk")
$Shortcut.TargetPath = "$MY_HOME"
$Shortcut.Save()

# Microsoft Visual Studio 2013 Community Edition
$VS2013COMMUNITY_FTP = "http://go.microsoft.com/?linkid=9863608"
$VS2013COMMUNITY_SETUP = "$DOWNLOADS\vs_community.exe"
$VS2013COMMUNITY_SETUP_DEPLOYMENT = "$DOWNLOADS\AdminDeployment.xml"
DownloadBinary $VS2013COMMUNITY_FTP $VS2013COMMUNITY_SETUP
New-Item $VS2013COMMUNITY_SETUP_DEPLOYMENT -type file -value '<?xml version="1.0" encoding="utf-8"?>
<AdminDeploymentCustomizations xmlns="http://schemas.microsoft.com/wix/2011/AdminDeployment">
    <BundleCustomizations TargetDir="default" NoWeb="default"/>

    <SelectableItemCustomizations>
        <SelectableItemCustomization Id="Blend" Hidden="no" Selected="no" />
        <SelectableItemCustomization Id="VC_MFC_Libraries" Hidden="no" Selected="no" />
        <SelectableItemCustomization Id="SQL" Hidden="no" Selected="no" />
        <SelectableItemCustomization Id="WebTools" Hidden="no" Selected="no" />
        <SelectableItemCustomization Id="SilverLight_Developer_Kit" Hidden="no" Selected="no" />
        <SelectableItemCustomization Id="Win8SDK" Hidden="no" Selected="no" />
        <SelectableItemCustomization Id="WindowsPhone80" Hidden="no" Selected="no" />
    </SelectableItemCustomizations>

</AdminDeploymentCustomizations>' | out-null
& $VS2013COMMUNITY_SETUP /Passive /NoRestart /AdminFile $VS2013COMMUNITY_SETUP_DEPLOYMENT | Write-Output

# Standalone Debugging Tools for Windows as part of Windows 8.1 SDK
$DEBUGGINGTOOLS_FTP = "http://download.microsoft.com/download/A/6/A/A6AC035D-DA3F-4F0C-ADA4-37C8E5D34E3D/setup/WinSDKDebuggingTools_amd64/dbg_amd64.msi"
$DEBUGGINGTOOLS_SETUP = "$DOWNLOADS\Debugging_Tools_for_Windows_(x64).msi"
DownloadBinary $DEBUGGINGTOOLS_FTP $DEBUGGINGTOOLS_SETUP
Start-Process "msiexec" "/i $DEBUGGINGTOOLS_SETUP /Passive /NoRestart" -NoNewWindow -Wait

# MozillaBuild
$MOZILLABUILD_FTP = "http://ftp.mozilla.org/pub/mozilla/libraries/win32/MozillaBuildSetup-$MOZILLABUILD_VERSION.exe"
$MOZILLABUILD_SETUP = "$DOWNLOADS\MozillaBuildSetup-$MOZILLABUILD_VERSION.exe"
DownloadBinary $MOZILLABUILD_FTP $MOZILLABUILD_SETUP
InstallBinary $MOZILLABUILD_SETUP

# !exploitable 1.6.0 (needs 7-zip to extract, from MozillaBuild)
$B_EXPLOITABLE_FTP = "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=msecdbg&DownloadId=671417&FileTime=130119256185830000&Build=21031"
$B_EXPLOITABLE_SETUP_FILENAME = "MSECExtensions_1_6_0"
$B_EXPLOITABLE_FILE = "$DOWNLOADS\$B_EXPLOITABLE_SETUP_FILENAME.zip"
DownloadBinary $B_EXPLOITABLE_FTP $B_EXPLOITABLE_FILE
ExtractArchive $B_EXPLOITABLE_FILE "$DOWNLOADS\$B_EXPLOITABLE_SETUP_FILENAME"
Copy-Item "$DOWNLOADS\$B_EXPLOITABLE_SETUP_FILENAME\x64\Release\*" ([Environment]::GetFolderPath("ProgramFiles") + "\Debugging Tools for Windows (x64)\winext")

# Notepad++ editor
$NOTEPADPP_FTP = "http://notepad-plus-plus.org/repository/$NOTEPADPP_MAJOR_VER.x/$NOTEPADPP_VERSION/npp.$NOTEPADPP_VERSION.Installer.exe"
$NOTEPADPP_FILE = "$DOWNLOADS\npp.$NOTEPADPP_VERSION.Installer.exe"
DownloadBinary $NOTEPADPP_FTP $NOTEPADPP_FILE
& $NOTEPADPP_FILE /S

# Firefox Developer Edition (Aurora)
DownloadBinary $FXDEV_FTP $FXDEV_FILE_WITH_DIR
Write-Verbose "Installing $FXDEV_FILE_WITH_DIR ..."
& $FXDEV_FILE_WITH_DIR -ms | out-null
Write-Verbose "Finished installing $FXDEV_FILE_WITH_DIR ."

# Git
DownloadBinary $GIT_FTP $GIT_FILE_WITH_DIR
Write-Verbose "Installing $GIT_FILE_WITH_DIR ..."
& $GIT_FILE_WITH_DIR /SILENT | out-null
Write-Verbose "Finished installing $GIT_FILE_WITH_DIR ."

# mozilla-central bundle
$MCBUNDLE_FTP = "http://ftp.mozilla.org/pub/mozilla.org/firefox/bundles/mozilla-central.hg"
$MCBUNDLE_FILE = "$DOWNLOADS\mozilla-central.hg"
DownloadBinary $MCBUNDLE_FTP $MCBUNDLE_FILE

Write-Verbose "Setting up ssh configurations..."
New-Item $SSH_DIR -type directory | out-null
New-Item "$SSH_DIR\id_dsa.pub" -type file -value '<public key>' | out-null
New-Item "$SSH_DIR\id_dsa" -type file -value '<private key>' | out-null
New-Item "$SSH_DIR\config" -type file -value 'Host *
StrictHostKeyChecking no

Host hg.mozilla.org
User fuzzbots' | out-null
Write-Verbose "Finished setting up ssh configurations."
# Create a shortcut to C:\mozilla-build in Favorites. Adapted from http://stackoverflow.com/a/9701907
$WshShell2 = New-Object -comObject WScript.Shell
$Shortcut2 = $WshShell2.CreateShortcut("$MY_HOME\Links\mozilla-build.lnk")
$Shortcut2.TargetPath = "C:\mozilla-build"
$Shortcut2.Save()
# Mercurial settings
New-Item "$MY_HOME\.hgrc" -type file -value "[ui]
merge = internal:merge
ssh = $MOZILLABUILD_INSTALLDIR\msys\bin\ssh.exe -C -v

[extensions]
progress =
purge =
rebase =

[hostfingerprints]
hg.mozilla.org = af:27:b9:34:47:4e:e5:98:01:f6:83:2b:51:c9:aa:d8:df:fb:1a:27" | out-null
# Modifying custom mozilla-build script for running fuzzing.
# Step 1: -encoding utf8 is needed for out-file for the batch file to be run properly.
# See https://technet.microsoft.com/en-us/library/hh849882.aspx
cat "$MOZILLABUILD_INSTALLDIR\$MOZILLABUILD_START_SCRIPT" |
    % { $_ -replace 'CALL start-shell.bat', 'CALL fz-start-shell.bat' } |
    out-file $MOZILLABUILD_START_SCRIPT_FULL_PATH -encoding utf8 |
    out-null
cat "$MOZILLABUILD_INSTALLDIR\$MOZILLABUILD_GENERIC_START" |
    % { $_ -replace ' --login -i', ' --login -c "python -u ~/funfuzz/loopBot.py -b \"--random\" -t \"js\" --target-time 28800 | tee ~/log-loopBotPy.txt"' } |
    out-file $MOZILLABUILD_GENERIC_START_FULL_PATH -encoding utf8 |
    out-null
Write-Verbose "Finished setting up configurations."
# Step 2: Now convert the file generated in step 1 from Unicode with BOM to Unicode without BOM:
ConvertToUnicodeNoBOM $MOZILLABUILD_START_SCRIPT_FULL_PATH
ConvertToUnicodeNoBOM $MOZILLABUILD_GENERIC_START_FULL_PATH

Write-Verbose "Cloning fuzzing repository..."
Measure-Command { & $HG_BINARY --cwd $MY_HOME clone -e "$MOZILLABUILD_INSTALLDIR\msys\bin\ssh.exe -i $SSH_DIR\id_dsa -o stricthostkeychecking=no -C -v" `
    <repository location> fuzzing |
    Out-Host }
Write-Verbose "Finished cloning fuzzing repository."

Write-Verbose "Unbundling mozilla-central..."
New-Item $TREES -type directory | out-null
& $HG_BINARY --cwd $TREES init mozilla-central | out-null
New-Item "$MC_REPO\.hg\hgrc" -type file -value '[paths]

default = https://hg.mozilla.org/mozilla-central
' | out-null
& $HG_BINARY -R $MC_REPO unbundle "$DOWNLOADS\mozilla-central.hg" | Write-Output
Write-Verbose "Finished unbundling mozilla-central."

Write-Verbose "Updating mozilla-central..."
& $HG_BINARY -R $MC_REPO update -C default | Write-Output
& $HG_BINARY -R $MC_REPO pull | Write-Output
& $HG_BINARY -R $MC_REPO update -C default | Write-Output
Write-Verbose "Finished updating mozilla-central."

Write-Verbose "Commencing fuzzing."
# Only for certain machines: & schtasks.exe /create /ru Administrators /sc onlogon /delay 0000:01 /tr $MOZILLABUILD_START_SCRIPT_FULL_PATH /tn jsFuzzing
& $MOZILLABUILD_START_SCRIPT_FULL_PATH | Write-Output

#</powershell>
