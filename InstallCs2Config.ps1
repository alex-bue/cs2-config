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
Write-Output ""

# Track copied files
$CopiedFiles = @()

# Loop through each file and copy
$files = Get-ChildItem -Path $SourcePath -File
foreach ($file in $files) {
    $destinationFile = Join-Path $Cs2ConfigPath $file.Name
    if (Test-Path $destinationFile) {
        Write-Output "  - Replacing existing file: $file"
        Remove-Item -Path $destinationFile -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 200  # Small delay to release file lock
    } else {
        Write-Output "  - Copying new file: $file"
    }
    
    # Copy file
    Copy-Item -Path $file.FullName -Destination $Cs2ConfigPath -Force
    $CopiedFiles += $file.Name
}

Write-Output ""
Write-Output "Installation complete!"
Write-Output "-------------------------------------------------------------------------------------------"
Write-Output "Summary of installed files:"
foreach ($file in $CopiedFiles) {
    Write-Output "  - $file -> $Cs2ConfigPath"
}
Write-Output "-------------------------------------------------------------------------------------------"
Exit 0

