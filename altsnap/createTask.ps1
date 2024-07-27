# Function to get the localized name for the Users group
function Get-LocalizedUsersGroupName {
    $usersGroupSID = "S-1-5-32-545"
    $usersGroup = New-Object System.Security.Principal.SecurityIdentifier($usersGroupSID)
    $usersGroup.Translate([System.Security.Principal.NTAccount]).Value
}

# Get the localized Users group name
$usersGroupName = Get-LocalizedUsersGroupName

# Create the scheduled task
$trigger = New-ScheduledTaskTrigger -AtLogOn -RandomDelay "00:00:10"
$principal = New-ScheduledTaskPrincipal -GroupId $usersGroupName -RunLevel Highest
$action = New-ScheduledTaskAction -Execute "$HOME\AppData\Roaming\AltSnap\AltSnap.exe"
$settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -ExecutionTimeLimit 0
Register-ScheduledTask -TaskName "AltSnap" -Trigger $trigger -Principal $principal -Action $action -Description "Start AltSnap on logon" -Force -Settings $settings
