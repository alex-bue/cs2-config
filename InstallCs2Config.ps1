param (
    [string]$SourcePath,
    [string]$Cs2ConfigPath = "$env:ProgramFiles(x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg"
)

# Ensure full language mode
if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage") {
    Write-Host "Error: Script cannot run due to restricted execution policy." -ForegroundColor Red
    Exit
}

Clear-Host
Write-Output "-------------------------------------------------------------------------------------------"
Write-Output " CS2 Config - Install Script"
Write-Output "-------------------------------------------------------------------------------------------"

# Auto-detect SourcePath if not provided
if (-not $SourcePath) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $SourcePath = Join-Path $ScriptDir "cfg"
    Write-Output "> Auto-detected SourcePath: $SourcePath"
}

# Validate SourcePath
if (-not (Test-Path -Path $SourcePath -PathType Container)) {
    Write-Output "Error: SourcePath '$SourcePath' is not a valid directory." -ForegroundColor Red
    Exit 1
}

# Validate Cs2ConfigPath
if (-not (Test-Path -Path $Cs2ConfigPath -PathType Container)) {
    Write-Output "Error: Provided Cs2ConfigPath '$Cs2ConfigPath' is not a valid directory." -ForegroundColor Red
    Exit 1
}

Write-Output "> Installing CS2 configuration files from '$SourcePath' to '$Cs2ConfigPath'..."

# Copy configuration files
Copy-Item -Path "$SourcePath\*" -Destination $Cs2ConfigPath -Recurse -Force

Write-Output ""
Write-Output "Configuration files successfully installed to $Cs2ConfigPath"

