# PSBOOTSTRAPBEGIN
Write-Verbose "Setting up ssh configurations..."
New-Item $SSH_DIR -type directory | out-null
New-Item "$SSH_DIR\id_dsa.pub" -type file -value '<public key>' | out-null
New-Item "$SSH_DIR\id_dsa" -type file -value '<private key>' | out-null
New-Item "$SSH_DIR\config" -type file -value 'Host *
StrictHostKeyChecking no

Host hg.mozilla.org
User fuzzbots' | out-null
Write-Verbose "Finished setting up ssh configurations."
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
    % { $_ -replace ' --login -i', ' --login -c "python -u ~/fuzzing/loopBot.py -b \"--random\" -t \"js\" --target-time 28800 | tee ~/log-loopBotPy.txt"' } |
    out-file $MOZILLABUILD_START_SCRIPT_FULL_PATH -encoding utf8 |
    out-null
Write-Verbose "Finished setting up configurations."
# Step 2: Now convert the file generated in step 1 from Unicode with BOM to Unicode without BOM:
# Adapted from http://stackoverflow.com/a/5596984
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
[System.IO.File]::WriteAllLines($MOZILLABUILD_START_SCRIPT_FULL_PATH,
                                (Get-Content $MOZILLABUILD_START_SCRIPT_FULL_PATH), $Utf8NoBomEncoding)

Write-Verbose "Cloning fuzzing repository..."
Measure-Command { & $HG_BINARY --cwd $MY_HOME clone -e "$MOZILLABUILD_INSTALLDIR\msys\bin\ssh.exe -i $SSH_DIR\id_dsa -o stricthostkeychecking=no -C -v" `
    <repository location> fuzzing |
    Out-Host }
Write-Verbose "Finished cloning fuzzing repository."


Write-Verbose "Commencing fuzzing."
# Only for certain machines: & schtasks.exe /create /ru Administrators /sc onlogon /delay 0000:01 /tr $MOZILLABUILD_START_SCRIPT_FULL_PATH /tn jsFuzzing
& $MOZILLABUILD_START_SCRIPT_FULL_PATH | Write-Output

# PSBOOTSTRAPEND
