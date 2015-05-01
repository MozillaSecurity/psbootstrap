# Directories
# $MY_HOME is needed because user-data starts up as SYSTEM user which is *not* Administrator.
$MY_HOME = "C:\Users\Administrator"
$DOWNLOADS = "$MY_HOME\Downloads"
$SSH_DIR = "$MY_HOME\.ssh"
$TREES = "$MY_HOME\trees"
$MC_REPO = "$TREES\mozilla-central"

# Versions
$MOZILLABUILD_VERSION = "1.11.0"
$NOTEPADPP_MAJOR_VER = "6"
$NOTEPADPP_VERSION = "$NOTEPADPP_MAJOR_VER.7.5"
$FXDEV_ARCH = "64"
$FXDEV_VERSION = "39.0a2"  # Change the URL in the $FXDEV_FTP variable as well.

# Programs
$FXDEV_FILENAME = "firefox-$FXDEV_VERSION.en-US.win$FXDEV_ARCH.installer.exe"
$MOZ_FTP = "https://ftp.mozilla.org/pub/mozilla.org"
$FXDEV_FTP = "$MOZ_FTP/firefox/nightly/2015/04/2015-04-13-00-40-06-mozilla-aurora/$FXDEV_FILENAME"
$FXDEV_FILE_WITH_DIR = "$DOWNLOADS\$FXDEV_FILENAME"

# MozillaBuild
# For 32-bit, use "start-shell-msvc2013.bat". For 64-bit, use "start-shell-msvc2013-x64.bat"
$MOZILLABUILD_INSTALLDIR = "C:\mozilla-build"
$MOZILLABUILD_START_SCRIPT = "start-shell-msvc2013.bat"
#$MOZILLABUILD_START_SCRIPT = "start-shell-msvc2013-x64.bat"
$MOZILLABUILD_START_SCRIPT_FULL_PATH = "$MOZILLABUILD_INSTALLDIR\fz-$MOZILLABUILD_START_SCRIPT"
$HG_BINARY = "$MOZILLABUILD_INSTALLDIR\hg\hg.exe"
