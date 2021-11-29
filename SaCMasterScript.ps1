#Setup
try {
C:\Security\Scripts\SaveAndClear\SaCSetup.ps1
} catch {
    Write-Host "Error running setup, check the error log for additional details @ C:\Security\Results\SaveAndClear\Logs"
}
#Save and clear
try {
    C:\Security\Scripts\SaveAndClear\SaCMain.ps1
} catch {
    Write-Host "Error running script, check the error log for additional details @ C:\Security\Results\SaveAndClear\Logs"
}
