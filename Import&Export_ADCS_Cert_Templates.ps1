#Export CA published templates (Win2012 R2-) using certutil
$array = @()
$templates = certutil -catemplates
foreach ($template in $templates) {
    $templateName = ($template -split ":")[0]
    if ($templateName -ne "CertUtil") {
        $templateName
        $array += $templateName
    }
}
$array | out-file C:\TemplatesBackup.txt

#Export CA published templates (Win2016+)
# Requires ADCSAdministration module 
(Get-CATemplate).name | Out-File C:\TemplatesBackup.txt

#Republish CA Templates
# Requires ADCSAdministration pws module
$templates = Get-Content C:\TemplatesBackup.txt
Write-Host "Found a total of $($templates.count) published templates"
foreach ($template in $templates) {
    Write-Host "Publishing template $($template)"
    Add-CATemplate -Name $template -Confirm:$false
}