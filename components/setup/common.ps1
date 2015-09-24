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
