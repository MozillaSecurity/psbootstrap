# PSBOOTSTRAPBEGIN
# Firefox Developer Edition (Aurora)
DownloadBinary $FXDEV_FTP $FXDEV_FILE_WITH_DIR
Write-Verbose "Installing $FXDEV_FILE_WITH_DIR ..."
& $FXDEV_FILE_WITH_DIR -ms | out-null
Write-Verbose "Finished installing $FXDEV_FILE_WITH_DIR ."
# PSBOOTSTRAPEND
