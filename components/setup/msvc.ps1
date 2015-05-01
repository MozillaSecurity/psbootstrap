# PSBOOTSTRAPBEGIN
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
# PSBOOTSTRAPEND
