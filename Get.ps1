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

Write-Output "> Running InstallCs2Config..."

# Build argument list for InstallCs2Config
$DeployArgs = "-ExecutionPolicy Bypass -File `"$PSScriptRoot\InstallCs2Config`" -SourcePath `"$CfgDir`""
if ($Cs2ConfigPath) {
    $DeployArgs += " -Cs2ConfigPath `"$Cs2ConfigPath`""
}

# Run Deploy script with extracted config path and optional Cs2ConfigPath
Start-Process powershell.exe -PassThru -ArgumentList $DeployArgs -Verb RunAs

Write-Output ""
Write-Output "> Cleaning up temporary files..."
Remove-Item -Recurse -Force $TempDir

Write-Output ""
Write-Output "CS2 configuration deployment complete!"
