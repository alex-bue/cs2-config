param(
    [string]$SteamPath = "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg"
)

# The cfg directory within the Git repository - assuming this script is located in the root of the repo and 'cfg' is a folder at this location
$cfgDirInRepo = Join-Path -Path $PSScriptRoot -ChildPath "cfg"

# Validate input
$knownCfgFile = "gamemode_competitive.cfg"

# Validate the CS:GO cfg directory by checking for the presence of the config.cfg file
if (-not (Test-Path -Path (Join-Path -Path $SteamPath -ChildPath $knownCfgFile))) {
    Write-Host "The provided SteamPath does not lead to an existing or complete CS:GO cfg directory with a known config file. Check the path and try again."
    exit
}

# Create symlinks for each file in the 'cfg' folder of the Git repository
Get-ChildItem -Path $cfgDirInRepo -File | ForEach-Object {
    $filename = $_.Name
    $symlinkPath = Join-Path -Path $SteamPath -ChildPath $filename

    # Create a symlink in the CS:GO cfg directory pointing to the repo's cfg file
    New-Item -ItemType SymbolicLink -Path $symlinkPath -Target $_.FullName
    Write-Host "Symlink created for $filename."
}
