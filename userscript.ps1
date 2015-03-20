# Script version 0.1 (20150319)
# Remember to first convert to DOS line endings! (CRLF)
# from http://stackoverflow.com/a/14155400 but avoid running in cygwin/git bash
#   perl -pi -e 's/\r\n|\n|\r/\r\n/g' file-to-convert  # Convert to DOS
#   perl -pi -e 's/\r\n|\n|\r/\n/g'   file-to-convert  # Convert back to UNIX

# Allow use of Write-Verbose
[CmdletBinding()]
Param()

# Only tested with Powershell V4
#requires -version 4.0
Set-StrictMode -Version Latest  # Helps to catch errors
Set-ExecutionPolicy -Force RemoteSigned  # Allow local scripts

# Directories
$DOWNLOADS = $HOME + "\Downloads"
$SSH_DIR = $HOME + "\.ssh"
$MOZILLABUILD_INSTALLDIR = "C:\mozilla-build"
$TREES = "$HOME\trees"
$MC_REPO = "$TREES\mozilla-central"

# Versions
$MOZILLABUILD_VERSION = "1.11.0"
$NOTEPADPP_MAJOR_VER = "6"
$NOTEPADPP_VERSION = $NOTEPADPP_MAJOR_VER + ".7.5"
$FXDEV_ARCH = "64"
$FXDEV_VERSION = "38.0a2"  # Change the URL in the $FXDEV_FTP variable as well.

# Programs
# For 32-bit, use "start-shell-msvc2013.bat". For 64-bit, use "start-shell-msvc2013-x64.bat"
$MOZILLABUILD_START_SCRIPT = "start-shell-msvc2013.bat"
$HG_BINARY = "$MOZILLABUILD_INSTALLDIR\hg\hg.exe"

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
    (C:\mozilla-build\7zip\7z.exe e -y -o"$dirName" $fileName) | out-null
    Write-Verbose "Finished extracting $fileName ."
}

# Microsoft Visual Studio 2013 Community Edition
$VS2013COMMUNITY_FTP = "http://go.microsoft.com/?linkid=9863608"
$VS2013COMMUNITY_SETUP = "$DOWNLOADS\vs_community.exe"
DownloadBinary $VS2013COMMUNITY_FTP $VS2013COMMUNITY_SETUP
New-Item "$DOWNLOADS\AdminDeployment.xml" -type file -value '<?xml version="1.0" encoding="utf-8"?>
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
& "$DOWNLOADS\vs_community.exe" /Passive /NoRestart /AdminFile "$DOWNLOADS\AdminDeployment.xml"
Write-Output "" | out-null  # Ensures the previous command is finished

# MozillaBuild
$MOZILLABUILD_FTP = "http://ftp.mozilla.org/pub/mozilla/libraries/win32/MozillaBuildSetup-$MOZILLABUILD_VERSION.exe"
$MOZILLABUILD_SETUP = "$DOWNLOADS\MozillaBuildSetup-$MOZILLABUILD_VERSION.exe"
DownloadBinary $MOZILLABUILD_FTP $MOZILLABUILD_SETUP
InstallBinary $MOZILLABUILD_SETUP

# Notepad++ editor
$NOTEPADPP_FTP = "http://dl.notepad-plus-plus.org/downloads/$NOTEPADPP_MAJOR_VER.x/$NOTEPADPP_VERSION/npp.$NOTEPADPP_VERSION.bin.7z"
$NOTEPADPP_FILE = "$DOWNLOADS\npp.$NOTEPADPP_VERSION.bin.7z"
DownloadBinary $NOTEPADPP_FTP $NOTEPADPP_FILE
ExtractArchive $NOTEPADPP_FILE "$DOWNLOADS\npp-$NOTEPADPP_VERSION"

# Firefox Developer Edition (Aurora)
$FXDEV_FTP = "https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/2015-03-18-00-40-12-mozilla-aurora/firefox-$FXDEV_VERSION.en-US.win$FXDEV_ARCH.installer.exe"
$FXDEV_FILE = $DOWNLOADS + "\firefox-$FXDEV_VERSION.en-US.win$FXDEV_ARCH.installer.exe"
DownloadBinary $FXDEV_FTP $FXDEV_FILE
Write-Verbose "Installing $FXDEV_FILE ..."
& $FXDEV_FILE -ms | out-null
Write-Verbose "Finished installing $FXDEV_FILE ."

# mozilla-central bundle
$MCBUNDLE_FTP = "http://ftp.mozilla.org/pub/mozilla.org/firefox/bundles/mozilla-central.hg"
$MCBUNDLE_FILE = $DOWNLOADS + "\mozilla-central.hg"
DownloadBinary $MCBUNDLE_FTP $MCBUNDLE_FILE
