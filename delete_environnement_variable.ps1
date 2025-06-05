# Remove the environment variable
[Environment]::SetEnvironmentVariable("AUTOCAD_CURRENT_DATE", $null, "Process")

# Verify that the variable is removed
$testVar = [Environment]::GetEnvironmentVariable("AUTOCAD_CURRENT_DATE", "Process")
if ($testVar -eq $null) {
    Write-Host "Variable AUTOCAD_CURRENT_DATE successfully removed" -ForegroundColor Green
} else {
    Write-Host "Variable still present: $testVar" -ForegroundColor Red
}