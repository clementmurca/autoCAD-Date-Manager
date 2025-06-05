# Read the configuration file
$configPath = Join-Path $PSScriptRoot "date_config_json"
$config = Get-Content $configPath | ConvertFrom-Json

# Generation of the date in year-day format
$currentDate = Get-Date
$year = $currentDate.Year
$dayOfYear = $currentDate.DayOfYear

# Customised format: year-day of year-
$customDateFormat = "$year$-$dayOfYear-"

# Definition of the single environment variable
[Environment]::SetEnvironmentVariable("AUTOCAD_CURRENT_DATE", $customDateFormat, "Process")

# Confirmation display
Write-Host "Variable d'environnement définie :" -ForegroundColor Green
Write-Host "AUTOCAD_CURRENT_DATE = $customDateFormat" -ForegroundColor Yellow

# Launch AutoCAD if specified
if ($args[0] -eq "-launch") {
    $autocadPath = "C:\Program Files\Autodesk\AutoCAD 2024\acad.exe"
    if (Test-Path $autocadPath) {
        Start-Process $autocadPath
        Write-Host "AutoCAD lancé avec la variable d'environnement" -ForegroundColor Green
    }
}