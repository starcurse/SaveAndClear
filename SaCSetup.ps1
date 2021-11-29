#Variables
$SaCVerification = "C:\Security\Scripts\Configuration\SaCVerification.txt"
$Verification = "C:\Security\Scripts\Configuration\PCVerification.txt"
$PCisConfigured = Test-Path -Path $Verification
$ScriptisConfigured = Test-Path -Path $SaCVerification
$SecurityFolder = Test-Path -Path "C:\Security"
$ScriptFolderExists = Test-Path -Path "C:\Security\Scripts"
$ExcelTemplatesExists = Test-Path -Path "C:\Security\Scripts\ExcelTemplates"
$ConfigurationExists = Test-Path -Path "C:\Security\Scripts\Configuration"
$LogsExists = Test-path -Path "C:\Security\Scripts\Logs"
$GeneralErrorsExists = Test-Path -Path "C:\Security\Scripts\Logs\GeneralErrors.txt"
$ResultsExists = Test-Path -Path "C:\Security\Results"
$SaCExists = Test-Path -Path "C:\Security\Results\SaveAndClear"
$SaCLogExists = Test-Path -Path "C:\Security\Results\SaveAndClear\Logs"
$ScriptlogExists = Test-Path -Path "C:\Security\Results\SaveAndClear\Logs\ScriptLog.txt"
$SaCCurrentYearVerification = "C:\Security\Scripts\SaveAndClear\Verification\SaveAndClearCurrentYear.txt"
$ComputerDoc = "C:\Security\Scripts\SaveAndClear\Documents\ComputersDoc.txt"
$SecPath = "C:\Security\Scripts\SaveAndClear\Documents\SecurityPathway.txt"
$AppPath = "C:\Security\Scripts\SaveAndClear\Documents\ApplicationPathway.txt"
$SysPath = "C:\Security\Scripts\SaveAndClear\Documents\SystemPathway.txt"
$DrivePath = "C:\Security\Scripts\SaveAndClear\Documents\DriveLetter.txt"
$GeneralErrors = "C:\Security\Scripts\Logs\GeneralErrors.txt"
$CompDocExists = Test-Path -Path $ComputerDoc
$SecPathExists = Test-Path -Path $SecPath
$AppPathExists = Test-Path -Path $AppPath
$SysPathExists = Test-Path -Path $SysPath
$InitialSetupExists = Test-Path "C:\InitialSetup"
$timestamp = Get-Date -Format "MM/dd/yyyy HH:mm"
$today = Get-Date -format yyyy
$yesterday = (Get-Date).AddDays(-1).ToString('yyyy')
$PathsAreSet = Test-Path -Path $SaCCurrentYearVerification

try {
  if ($PCisConfigured -eq $false) {
    if ($SecurityFolder -eq $false) {
      New-Item -Path "C:\Security" -ItemType "Directory"
    }
    if ($ScriptFolderExists -eq $false) {
      New-Item -Path "C:\Security\Scripts" -ItemType "Directory"
    }
    if ($ExcelTemplatesExists -eq $false) {
      New-Item -Path "C:\Security\Scripts\ExcelTemplates" -ItemType "Directory"
    }
    if ($ConfigurationExists -eq $false) {
      New-Item -Path "C:\Security\Scripts\Configuration" -ItemType "Directory"
    }
    if ($LogsExists -eq $false) {
      New-Item -Path "C:\Security\Scripts\Logs" -ItemType "Directory"
    }
    if ($GeneralErrorsExists -eq $false) {
      New-Item -Path "C:\Security\Scripts\Logs\GeneralErrors.txt"
    }
    if ($ResultsExists -eq $false) {
      New-Item -Path "C:\Security\Results" -ItemType "Directory"
    }
    New-Item -Path $Verification
  }
} Catch {
  Write-OutPut "Error setting up PCconfiguration on $timestamp" | Add-Content -Path $GeneralErrors
}
try {
  if ($ScriptisConfigured -eq $false) {
    if ($SaCExists -eq $false) {
      New-Item -Path "C:\Security\Results\SaveAndClear" -ItemType "Directory"
    }
    if ($SaCLogExists -eq $false) {
      New-Item -Path "C:\Security\Results\SaveAndClear\Logs" -ItemType "Directory"
    }
    if ($ScriptlogExists -eq $false) {
      New-Item -Path "C:\Security\Results\SaveandClear\Logs\ScriptLog.txt"
    }
    if ($SacExists -eq $true) {
      if ($SaCLogExists -eq $true) {
        if ($ScriptlogExists -eq $true) {
          New-Item -Path $SaCVerification
        } else {
          Write-Output "Error creating Save and Clear file framework on $timestamp"
        }
      }
    }
}
} Catch {
  Write-OutPut "Error setting up Script Configuration on $timestamp" | Add-Content -Path $GeneralErrors
}
try {
  if ($CompDocExists -eq $false) {
    New-Item -Path $ComputerDoc
  }
  if ($SecPathExists -eq $false) {
    New-Item -Path $SecPath
  }
  if ($AppPathExists -eq $false) {
    New-Item -Path $AppPath
  }
  if ($SysPathExists -eq $false) {
    New-Item -Path $SysPath
  }
} catch{
  Write-OutPut "Error with making path documents on $timestamp" | Add-Content -Path $GeneralErrors
}
try {
    if ($PathsAreSet -eq $false) {
        $ComputerNames = Read-Host "Please type the name(s) of the computer(s) whose logs will be saved and cleared. (Format: WS1, DNS1, WS2)"
        Set-Content -Path $ComputerDoc $ComputerNames 
        $SecurityPathway = Read-Host "Please type the partial pathway for the location you would like the security audit log to be saved. (Format: \Security\Example2\Example3)"
        Set-Content -Path $SecPath $SecurityPathway
        $ApplicationPathway = Read-Host "Please type the partial pathway for the location you would like the application audit log to be saved. (Format: \Security\Example2\Example3)"
        Set-Content -Path $AppPath $ApplicationPathway
        $SystemPathway = Read-Host "Please type the partial pathway for the location you would like the system audit log to be saved. NOTE: Do not include drive letter. (Format: \Security\Example2\Example3)"
        Set-Content -Path $SysPath $SystemPathway
        $DriveLetter = Read-Host "Please type the letter of the drive you want to save your audits to. NOTE: If there the drive letter varies, type the most common one. (Format: C)"
        Set-Content -Path $DrivePath $DriveLetter
        New-Item -Path $SaCCurrentYearVerification
    }
} catch {
    Write-OutPut "Error with writing pathway on $timestamp" | Add-Content -Path $GeneralErrors
}
try {
    if ($today -ne $yesterday) {Remove-Item $SaCCurrentYearVerification}
} Catch {
  Write-OutPut "Error with scanning for current year on $timestamp" | Add-Content -Path $GeneralErrors
}
if ($InitialSetupExists -eq $true) {
  Remove-Item -Path "C:\InitialSetup" -Recurse
}