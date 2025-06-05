# Read configuration file
$configPath = Join-Path $PSScriptRoot "date_config.json"

# Check if JSON file exists
if (Test-Path $configPath) {
    $config = Get-Content $configPath | ConvertFrom-Json
    Write-Host "Configuration loaded from $configPath" -ForegroundColor Cyan
} else {
    Write-Host "Configuration file not found, using default values" -ForegroundColor Yellow
    $config = @{
        date_format = "yyyy-DDD"
        auto_update = $true
    }
}

# Generate date in year-day format
$currentDate = Get-Date
$year = $currentDate.Year
$dayOfYear = $currentDate.DayOfYear

# Build format according to JSON (yyyy-DDD) with final dash
if ($config.date_format -eq "yyyy-DDD") {
    $customDateFormat = "$year-$dayOfYear-"
} else {
    # Fallback if JSON format changes
    $customDateFormat = "$year-$dayOfYear-"
}

# Set environment variable at USER level for persistence
[Environment]::SetEnvironmentVariable("AUTOCAD_CURRENT_DATE", $customDateFormat, "User")

# Also set it for current session (immediate availability)
$env:AUTOCAD_CURRENT_DATE = $customDateFormat

# Confirmation display
Write-Host "Environment variable defined:" -ForegroundColor Green
Write-Host "AUTOCAD_CURRENT_DATE = $customDateFormat" -ForegroundColor Yellow

# Launch AutoCAD if specified
if ($args[0] -eq "-launch") {
    $autocadPath = "C:\Program Files\Autodesk\AutoCAD 2024\acad.exe"
    if (Test-Path $autocadPath) {
        Start-Process $autocadPath
        Write-Host "AutoCAD launched with environment variable" -ForegroundColor Green
    } else {
        Write-Host "AutoCAD not found at specified path" -ForegroundColor Red
    }
}