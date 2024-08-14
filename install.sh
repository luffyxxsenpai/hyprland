#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <package_list_file>"
  exit 1
fi

# Check if input file exists
if [ ! -f "$1" ]; then
  echo "File not found!"
  exit 1
fi

# Temporary files for logging
failed_log=$(mktemp)
install_log=$(mktemp)

# Function to install a package using pacman
install_with_pacman() {
  local package=$1
  echo "Installing $package with pacman..."
  if pacman -S --needed --noconfirm "$package" >/dev/null 2>&1; then
    echo "$package installed successfully with pacman."
  else
    echo "$package" >>"$failed_log"
    echo "Failed to install $package with pacman."
  fi
}

# Function to install a package using yay
install_with_yay() {
  local package=$1
  echo "Installing $package with yay..."
  if yay -S --needed --noconfirm "$package" >/dev/null 2>&1; then
    echo "$package installed successfully with yay."
  else
    echo "$package" >>"$failed_log"
    echo "Failed to install $package with yay."
  fi
}

# Read the package list and attempt to install each package
while IFS= read -r package; do
  # Skip empty lines
  if [ -z "$package" ]; then
    continue
  fi

  # Install with pacman first
  install_with_pacman "$package" &

  # If pacman fails, try with yay
  if grep -Fxq "$package" "$failed_log"; then
    install_with_yay "$package" &
  fi

done <"$1"

# Wait for all background processes to finish
wait

# Check and output failed installations
if [ -s "$failed_log" ]; then
  echo "The following packages failed to install:"
  cat "$failed_log"
else
  echo "All packages installed successfully."
fi

# Clean up
rm "$failed_log" "$install_log"

# Define the target and backup directories for moving files
TARGET_DIR="$HOME/.config"
BACKUP_DIR="$TARGET_DIR/backup_$(date +%Y%m%d_%H%M%S)"

# Create the target and backup directories
mkdir -p "$TARGET_DIR"
mkdir -p "$BACKUP_DIR"

# Process each item in the current directory (the Git repo)
for ITEM in $(find . -maxdepth 1 -mindepth 1); do
  # Get the basename of the item
  BASENAME=$(basename "$ITEM")

  # Define the target path
  TARGET_PATH="$TARGET_DIR/$BASENAME"

  # Check if the item already exists in the target directory
  if [ -e "$TARGET_PATH" ]; then
    echo "Item $TARGET_PATH already exists. Moving to backup directory."
    # Move the existing item to the backup directory
    mv "$TARGET_PATH" "$BACKUP_DIR/"
  fi

  # Move the new item to the target directory
  echo "Moving $ITEM to $TARGET_PATH."
  mv "$ITEM" "$TARGET_PATH"
done

echo "All items have been processed."

# Prompt the user to restart
read -p "Do you want to restart your system now? (y/n): " restart_choice
if [ "$restart_choice" == "y" ]; then
  echo "Restarting the system..."
  sudo reboot
else
  echo "System restart skipped."
fi
