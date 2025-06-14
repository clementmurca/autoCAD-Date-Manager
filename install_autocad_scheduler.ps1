# Automatic installation script for AutoCAD scheduled tasks
param(
    [string]$ScriptPath = (Join-Path $PSScriptRoot "autocad_date_manager.ps1"),
    [string]$MorningTime = "07:00"
)

Write-Host "=== AutoCAD Scheduled Tasks Installation ===" -ForegroundColor Cyan
Write-Host "Script path: $ScriptPath" -ForegroundColor Yellow
Write-Host "Morning time: $MorningTime" -ForegroundColor Yellow

# Check if main script exists
if (-not (Test-Path $ScriptPath)) {
    Write-Host "ERROR: Script $ScriptPath does not exist!" -ForegroundColor Red
    exit 1
}

# Check administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as administrator!" -ForegroundColor Red
    Write-Host "Right-click on PowerShell > Run as administrator" -ForegroundColor Yellow
    pause
    exit 1
}

try {
    # === TASK 1: At session logon ===
    Write-Host "`n1. Creating task 'AutoCAD Date - Session Active'..." -ForegroundColor Green
    
    $ActionSession = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`""
    $TriggerSession = New-ScheduledTaskTrigger -AtLogon
    $SettingsSession = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    $PrincipalSession = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
    
    Register-ScheduledTask -TaskName "AutoCAD Date - Session Active" -Action $ActionSession -Trigger $TriggerSession -Settings $SettingsSession -Principal $PrincipalSession -Description "Runs AutoCAD date script at each session logon" -Force
    
    Write-Host "✓ Task 'AutoCAD Date - Session Active' created successfully" -ForegroundColor Green

    # === TASK 2: Every morning ===
    Write-Host "`n2. Creating task 'AutoCAD Date - Daily'..." -ForegroundColor Green
    
    $ActionDaily = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`""
    $TriggerDaily = New-ScheduledTaskTrigger -Daily -At $MorningTime
    $SettingsDaily = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -WakeToRun
    $PrincipalDaily = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
    
    Register-ScheduledTask -TaskName "AutoCAD Date - Daily" -Action $ActionDaily -Trigger $TriggerDaily -Settings $SettingsDaily -Principal $PrincipalDaily -Description "Runs AutoCAD date script every morning at $MorningTime" -Force
    
    Write-Host "✓ Task 'AutoCAD Date - Daily' created successfully" -ForegroundColor Green

    # === VERIFICATION ===
    Write-Host "`n=== Verification of created tasks ===" -ForegroundColor Cyan
    
    $TaskSession = Get-ScheduledTask -TaskName "AutoCAD Date - Session Active" -ErrorAction SilentlyContinue
    $TaskDaily = Get-ScheduledTask -TaskName "AutoCAD Date - Daily" -ErrorAction SilentlyContinue
    
    if ($TaskSession) {
        Write-Host "✓ Task 'Session Active': " -ForegroundColor Green -NoNewline
        Write-Host $TaskSession.State -ForegroundColor Yellow
    }
    
    if ($TaskDaily) {
        Write-Host "✓ Task 'Daily': " -ForegroundColor Green -NoNewline
        Write-Host $TaskDaily.State -ForegroundColor Yellow
    }

    # === IMMEDIATE EXECUTION ===
    Write-Host "`n=== Immediate execution ===" -ForegroundColor Cyan
    Write-Host "Running AutoCAD script now..." -ForegroundColor Yellow
    & $ScriptPath

    Write-Host "`n=== Installation completed successfully! ===" -ForegroundColor Green
    Write-Host "Your tasks are now configured:" -ForegroundColor White
    Write-Host "- Script executed immediately (just now)" -ForegroundColor Yellow
    Write-Host "- Script will run at each new session logon" -ForegroundColor Yellow
    Write-Host "- Script will run every morning at $MorningTime" -ForegroundColor Yellow
    Write-Host "`nYou can verify in Task Scheduler (taskschd.msc)" -ForegroundColor Gray

} catch {
    Write-Host "ERROR during task creation: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`nPress any key to close..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")