#!/bin/bash

main() {
  set -e

  # Remove .tmp-install directory if it exists
  if [ -d ".tmp-install" ]; then
    rm -rf .tmp-install
  fi

  mkdir .tmp-install
  cd .tmp-install || exit

  # Grab the latest release
  latest_release_url=$(curl -s https://api.github.com/repos/bytesquid/composer-rust/releases/latest | grep "browser_download_url.*gnu.tar.gz" | cut -d : -f 2,3 | tr -d \" | xargs echo -n)
  if [[ -z "$latest_release_url" ]]; then
    echo "Failed to fetch the latest release URL. Exiting."
    exit 1
  fi

  # Download the latest release
  echo "Downloading the latest release from: $latest_release_url"
  tar_file="composer_rust_latest.tar.gz"
  retries=5
  for i in $(seq 1 $retries); do
    if wget -q -O "$tar_file" "$latest_release_url"; then
      echo "Download successful."
      break
    else
      echo "Attempt $i of $retries failed. Error:" >&2
      wget -O "$tar_file" "$latest_release_url" 2>&1 | grep -i 'error\|failed' >&2
      if [ "$i" -eq "$retries" ]; then
        echo "All attempts to download failed. Exiting." >&2
        exit 1
      fi
      sleep 1
    fi
  done

  # Untar it
  echo "Untar $tar_file"
  tar -xzf "$tar_file"

  # Move it to PATH
  # Install the composer binary for the current user
  echo "Installing the composer binary for the current user..."
  INSTALL_DIR="$HOME/.local/bin"
  mkdir -p "$INSTALL_DIR"
  cp "./composer" "$INSTALL_DIR"

  # Check if the installation was successful
  if [ $? -eq 0 ]; then
    echo "Installation successful. The composer binary has been installed to $INSTALL_DIR"
    echo "Make sure $INSTALL_DIR is in your PATH."
  else
    echo "Installation failed. Please check the error messages above." >&2
    exit 1
  fi

  # Clean up
  cd ..
  rm -rf .tmp-install
}

main