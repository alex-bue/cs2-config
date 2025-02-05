#!/bin/bash

# Default Steam directory
DEFAULT_STEAM_PATH="/mnt/c/Program\ Files \(x86\)/Steam/steamapps/common/Counter-Strike\ Global\ Offensive/game/csgo/cfg"
# /mnt/c/Games/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg
GITHUB_REPO_URL="https://github.com/alex-bue/cs2-config"

# Parsing arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
  --steampath)
    user_steam_path="$2"
    shift
    ;;
  *)
    echo "Unknown parameter passed: $1"
    exit 1
    ;;
  esac
  shift
done

# Function to check if the provided directory is valid
is_valid_directory() {
  local path=$1
  if [ ! -d "$path" ]; then
    echo "Error: Provided path '$path' is not a valid directory."
    exit 1
  fi
}

# Check if the user-provided Steam path is specified
if [[ -n "$user_steam_path" ]]; then
  # Validate the provided Steam path
  is_valid_directory "$user_steam_path"
  cs2_directory="$user_steam_path"
else
  # Use default Steam path if no arguments are provided
  cs2_directory="$DEFAULT_STEAM_PATH"
  is_valid_directory "$cs2_directory"
fi

echo "CS2 configuration files will be deployed to: $cs2_directory"

# Temporary directory for downloading the GitHub repository
temp_dir=$(mktemp -d)

# Download the GitHub repository archive
curl -L "$GITHUB_REPO_URL/archive/master.zip" -o "$temp_dir/repo.zip"
unzip "$temp_dir/repo.zip" -d "$temp_dir"

# Dynamically find the extracted cfg directory
extracted_cfg_dir=$(find "$temp_dir" -type d -name "cfg" | head -n 1)

if [ -z "$extracted_cfg_dir" ]; then
  echo "Error: 'cfg' directory not found in the extracted repository."
  exit 1
fi

cp -r "$extracted_cfg_dir/"* "$cs2_directory/"

# Cleanup
rm -rf "$temp_dir"
echo "Cleanup complete. Configuration files deployed successfully."
