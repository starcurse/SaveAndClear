#Variables
$timestamp = Get-Date -Format "MM/dd/yyyy HH:mm"
$CurrentDate = Get-Date -format "MM-dd-yyyy"
$ComputerDoc = "C:\Security\Scripts\SaveAndClear\Documents\ComputersDoc.txt"
$SecPath = "C:\Security\Scripts\SaveAndClear\Documents\SecurityPathway.txt"
$AppPath = "C:\Security\Scripts\SaveAndClear\Documents\ApplicationPathway.txt"
$SysPath = "C:\Security\Scripts\SaveAndClear\Documents\SystemPathway.txt"
$DrivePath = "C:\Security\Scripts\SaveAndClear\Documents\DriveLetter.txt"
$Scriptlog = "C:\Security\Results\SaveandClear\Logs\ScriptLog.txt"
$ComputerNames = (Get-Content -Path $ComputerDoc) -split ","
$Credential = Get-Credential -Credential $env:USERNAME
$SecurityPathway = Get-Content -Path $SecPath
$ApplicationPathway = Get-Content -Path $AppPath
$SystemPathway = Get-Content -Path $SysPath
$DriveLetter = Get-Content -Path $DrivePath

#For each computer, save the event logs. If the computer is the host computer, then don't ask for credentials. This is the spot I get the "RPC Server Unavaliable" error.
try {
foreach ($pcName in $ComputerNames){
    if ($pcName -ne $env:COMPUTERNAME) {
    $Security = Get-WmiObject -Class Win32_NTEventlogFile -Credential $Credential -ComputerName $pcName -filter "LogfileName = 'Security'"
    $Application = Get-WmiObject -Class Win32_NTEventlogFile -Credential $Credential -ComputerName $pcName -filter "LogfileName = 'Application'"
    $System = Get-WmiObject -Class Win32_NTEventlogFile -Credential $Credential -ComputerName $pcName -filter "LogfileName = 'System'"
    $Security.BackupEventlog($("$SecurityPathway\$CurrentDate.evtx") -f $pcName)
    $Application.BackupEventlog($("$ApplicationPathway\$CurrentDate`_App.evtx") -f $pcName)
    $System.BackupEventlog($("$SystemPathway\$CurrentDate`_Sys.evtx") -f $pcName)
} if ($pcname -eq $env:COMPUTERNAME){
    $Security = Get-WmiObject -Class Win32_NTEventlogFile -ComputerName $pcName -filter "LogfileName = 'Security'"
    $Application = Get-WmiObject -Class Win32_NTEventlogFile -ComputerName $pcName -filter "LogfileName = 'Application'"
    $System = Get-WmiObject -Class Win32_NTEventlogFile -ComputerName $pcName -filter "LogfileName = 'System'"
    $Security.BackupEventlog($("$SecurityPathway\$CurrentDate.evtx") -f $pcName)
    $Application.BackupEventlog($("$ApplicationPathway\$CurrentDate`_App.evtx") -f $pcName)
    $System.BackupEventlog($("$SystemPathway\$CurrentDate`_Sys.evtx") -f $pcName)
}
}
} catch {
    Write-OutPut "$pcName had issues saving the logs at $timestamp" | Add-Content -Path $Scriptlog
}
#For each computer, check to see if the event logs have been saved and then clear the event log. Notate this in the log. 
foreach ($pcName in $ComputerNames) {
    $SecuritySaved = Test-Path -Path "\\$pcName\$DriveLetter$\$SecurityPathway\$CurrentDate.evtx"
    $ApplicationSaved = Test-Path -Path "\\$pcName\$DriveLetter$\$ApplicationPathway\$CurrentDate`_App.evtx"
    $SystemSaved = Test-Path -Path "\\$pcName\$DriveLetter$\$SystemPathway\$CurrentDate`_Sys.evtx"
    if ($SecuritySaved -eq $true) {
        Clear-EventLog -LogName Security -ComputerName $pcName
        Write-OutPut "Security Log for $pcName cleared at $timestamp" | Add-Content -Path $Scriptlog
    } else {
        Write-OutPut "Security Log for $pcName failed to save at $timestamp and was not cleared" | Add-Content -Path $Scriptlog
    }
    if ($ApplicationSaved -eq $true) {
        Clear-EventLog -LogName Application -ComputerName $pcName
        Write-OutPut "Application Log for $pcName cleared at $timestamp" | Add-Content -Path $Scriptlog
    } else {
        Write-OutPut "Application Log for $pcName failed to save at $timestamp and was not cleared" | Add-Content -Path $Scriptlog
    }
    if ($SystemSaved -eq $true) {
        Clear-EventLog -LogName System -ComputerName $pcName
        Write-OutPut "System Log for $pcName cleared at $timestamp" | Add-Content -Path $Scriptlog
    } else {
        Write-OutPut "System Log for $pcName failed to save at $timestamp and was not cleared" | Add-Content -Path $Scriptlog
    }
}