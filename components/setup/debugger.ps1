# PSBOOTSTRAPBEGIN
# Standalone Debugging Tools for Windows as part of Windows 8.1 SDK
$DEBUGGINGTOOLS_FTP = "http://download.microsoft.com/download/A/6/A/A6AC035D-DA3F-4F0C-ADA4-37C8E5D34E3D/setup/WinSDKDebuggingTools_amd64/dbg_amd64.msi"
$DEBUGGINGTOOLS_SETUP = "$DOWNLOADS\Debugging_Tools_for_Windows_(x64).msi"
DownloadBinary $DEBUGGINGTOOLS_FTP $DEBUGGINGTOOLS_SETUP
Start-Process "msiexec" "/i $DEBUGGINGTOOLS_SETUP /Passive /NoRestart" -NoNewWindow -Wait

# !exploitable 1.6.0 (needs 7-zip to extract, from MozillaBuild)
$B_EXPLOITABLE_FTP = "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=msecdbg&DownloadId=671417&FileTime=130119256185830000&Build=20988"
$B_EXPLOITABLE_SETUP_FILENAME = "MSECExtensions_1_6_0"
$B_EXPLOITABLE_FILE = "$DOWNLOADS\$B_EXPLOITABLE_SETUP_FILENAME.zip"
DownloadBinary $B_EXPLOITABLE_FTP $B_EXPLOITABLE_FILE
ExtractArchive $B_EXPLOITABLE_FILE "$DOWNLOADS\$B_EXPLOITABLE_SETUP_FILENAME"
Copy-Item "$DOWNLOADS\$B_EXPLOITABLE_SETUP_FILENAME\x64\Release\*" "$env:programw6432\Debugging Tools for Windows (x64)\winext"
# PSBOOTSTRAPEND
