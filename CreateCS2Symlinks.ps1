# Ensure the script is in the root of the repo where the cfg folder is located
$cfgDir = Join-Path -Path $PSScriptRoot -ChildPath "cfg"

# Replace this with the path to your CS:GO cfg directory on your Windows machine
$csgoCfgDir = "C:\Games\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg" 

# Check if the CS:GO cfg directory exists
if (-not (Test-Path -Path $csgoCfgDir)) {
    Write-Host "CS:GO cfg directory not found. Ensure you have the correct path."
    exit
}

# Create symlinks for each file in the cfg folder of the Git repository
Get-ChildItem -Path $cfgDir -File | ForEach-Object {
    $filename = $_.Name
    $symlinkPath = Join-Path -Path $csgoCfgDir -ChildPath $filename

    # Check if the symlink or file already exists in the CS:GO cfg folder
    if (Test-Path -Path $symlinkPath) {
        Write-Host "File or symlink named $filename already exists in $csgoCfgDir. Skipping."
    } else {
        # Create a symlink in the CS:GO cfg directory pointing to the repo's cfg file
        New-Item -ItemType SymbolicLink -Path $symlinkPath -Target $_.FullName
        Write-Host "Symlink created for $filename."
    }
}