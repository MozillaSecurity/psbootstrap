# PSBOOTSTRAPBEGIN
# Create a shortcut to ~ in Favorites. Adapted from http://stackoverflow.com/a/9701907
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$MY_HOME\Links\Administrator.lnk")
$Shortcut.TargetPath = "$MY_HOME"
$Shortcut.Save()

# Create a shortcut to C:\mozilla-build in Favorites. Adapted from http://stackoverflow.com/a/9701907
$WshShell2 = New-Object -comObject WScript.Shell
$Shortcut2 = $WshShell2.CreateShortcut("$MY_HOME\Links\mozilla-build.lnk")
$Shortcut2.TargetPath = "C:\mozilla-build"
$Shortcut2.Save()
# PSBOOTSTRAPEND
