# PSBOOTSTRAPBEGIN
# mozilla-central bundle
$MCBUNDLE_FTP = "http://ftp.mozilla.org/pub/mozilla.org/firefox/bundles/mozilla-central.hg"
$MCBUNDLE_FILE = "$DOWNLOADS\mozilla-central.hg"
DownloadBinary $MCBUNDLE_FTP $MCBUNDLE_FILE

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
# PSBOOTSTRAPEND
