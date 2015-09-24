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
