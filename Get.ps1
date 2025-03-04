param (
    [string]$RepoUrl = "https://github.com/alex-bue/cs2-config",
    [string]$TempDir = "$env:TEMP\cs2-config-temp",
    [string]$Cs2ConfigPath # Optional custom CS2 config path
)

# Ensure full language mode
if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage") {
    Write-Host "Error: Script cannot run due to restricted execution policy." -ForegroundColor Red
    Exit
}

Clear-Host
Write-Output "-------------------------------------------------------------------------------------------"
Write-Output " CS2 Config - Get Script"
Write-Output "-------------------------------------------------------------------------------------------"

Write-Output "> Downloading latest CS2 config..."

# Cleanup old temp folder if it exists
if (Test-Path $TempDir) {
    Remove-Item -Recurse -Force $TempDir
}
New-Item -ItemType Directory -Path $TempDir | Out-Null

$ZipPath = "$TempDir\repo.zip"
Invoke-WebRequest -Uri "$RepoUrl/archive/main.zip" -OutFile $ZipPath

Write-Output ""
Write-Output "> Unpacking..."

# Extract files
Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force

# Remove ZIP file after extraction
Remove-Item $ZipPath

# Locate extracted directory
$ExtractedDir = Get-ChildItem -Path $TempDir -Directory | Where-Object { $_.Name -match "cs2-config-main" } | Select-Object -ExpandProperty FullName
$CfgDir = Join-Path $ExtractedDir "cfg"

if (!(Test-Path -Path $CfgDir)) {
    Write-Output "Error: 'cfg' directory not found in the extracted repository." -ForegroundColor Red
    Exit 1
}

Write-Output "> Running InstallCs2Config.ps1..."

# Ensure Install script path is correctly resolved
$InstallScriptPath = Join-Path $PSScriptRoot "InstallCs2Config.ps1"

# Ensure the script exists
if (!(Test-Path -Path $InstallScriptPath)) {
    Write-Output "Error: InstallCs2Config.ps1 not found at '$InstallScriptPath'." -ForegroundColor Red
    Exit 1
}

# Build argument list correctly
$InstallArgs = @(
    "-ExecutionPolicy", "Bypass",
    "-File", "`"$InstallScriptPath`"",
    "-SourcePath", "`"$CfgDir`""
)

if ($Cs2ConfigPath) {
    $InstallArgs += @("-Cs2ConfigPath", "`"$Cs2ConfigPath`"")
}

# Run InstallCs2Config.ps1 in the same window, keeping logs visible
Start-Process powershell.exe -ArgumentList $InstallArgs -NoNewWindow -Wait

Write-Output ""
Write-Output "> Cleaning up temporary files..."
Remove-Item -Recurse -Force $TempDir

Write-Output ""
Write-Output "CS2 configuration installation complete!"

