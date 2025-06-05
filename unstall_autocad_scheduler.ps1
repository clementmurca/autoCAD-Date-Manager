# AutoCAD scheduled tasks uninstallation script
Write-Host "=== AutoCAD Scheduled Tasks Uninstallation ===" -ForegroundColor Cyan

# Check administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as administrator!" -ForegroundColor Red
    Write-Host "Right-click on PowerShell > Run as administrator" -ForegroundColor Yellow
    pause
    exit 1
}

# List of tasks to remove
$TasksToRemove = @(
    "AutoCAD Date - Session Active",
    "AutoCAD Date - Daily"
)

Write-Host "Searching for existing AutoCAD tasks..." -ForegroundColor Yellow

try {
    foreach ($TaskName in $TasksToRemove) {
        Write-Host "`nChecking task: $TaskName" -ForegroundColor Cyan
        
        # Check if task exists
        $Task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
        
        if ($null -ne $Task) {
            Write-Host "✓ Task found: $TaskName (State: $($Task.State))" -ForegroundColor Green
            
            # Remove the task
            Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction Stop
            Write-Host "✓ Task '$TaskName' successfully removed" -ForegroundColor Green
        } else {
            Write-Host "⚠ Task '$TaskName' not found (already removed or never created)" -ForegroundColor Yellow
        }
    }

    # Final verification
    Write-Host "`n=== Final verification ===" -ForegroundColor Cyan
    $RemainingTasks = @()
    
    foreach ($TaskName in $TasksToRemove) {
        $Task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
        if ($null -ne $Task) {
            $RemainingTasks += $TaskName
        }
    }
    
    if ($RemainingTasks.Count -eq 0) {
        Write-Host "✓ All AutoCAD tasks have been successfully removed!" -ForegroundColor Green
    } else {
        Write-Host "⚠ Tasks still present:" -ForegroundColor Yellow
        foreach ($TaskName in $RemainingTasks) {
            Write-Host "  - $TaskName" -ForegroundColor Red
        }
    }

    # Environment variables cleanup
    Write-Host "`n=== Environment variables cleanup ===" -ForegroundColor Cyan
    $EnvVarsToRemove = @(
        "AUTOCAD_CURRENT_DATE",
        "AUTOCAD_PROJECT_DATE",
        "AUTOCAD_YEAR",
        "AUTOCAD_DAY_OF_YEAR"
    )
    
    foreach ($EnvVar in $EnvVarsToRemove) {
        if ([Environment]::GetEnvironmentVariable($EnvVar, "Process")) {
            [Environment]::SetEnvironmentVariable($EnvVar, $null, "Process")
            Write-Host "✓ Variable '$EnvVar' removed" -ForegroundColor Green
        }
    }

    Write-Host "`n=== Uninstallation completed successfully! ===" -ForegroundColor Green
    Write-Host "AutoCAD scheduled tasks have been removed from the system." -ForegroundColor White
    Write-Host "You can verify in Task Scheduler (taskschd.msc)" -ForegroundColor Gray

} catch {
    Write-Host "ERROR during removal: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "You can try to remove manually via Task Scheduler" -ForegroundColor Yellow
    exit 1
}

Write-Host "`nPress any key to close..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")