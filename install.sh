#!/bin/bash

# Installation process func
install_gitleaks() {
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
          # OS type - Linux
          curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.1/gitleaks_8.18.1_linux_x64.tar.gz -o gitleaks.tar.gz &&
          tar -xzf gitleaks.tar.gz &&
          chmod +x gitleaks &&
          sudo mv gitleaks /usr/local/bin/gitleaks
        elif [[ "$OSTYPE" == "darwin"* ]]; then
          # OS type - macOS
          curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.1/gitleaks_8.18.1_darwin_x64.tar.gz -o gitleaks.tar.gz &&
          tar -xzf gitleaks.tar.gz &&
          chmod +x gitleaks &&
          sudo mv gitleaks /usr/local/bin/gitleaks
        elif [[ "$OSTYPE" == "darwin_arm64"* ]]; then
          # OS type - macOS_ARM
          curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.1/gitleaks_8.18.1_darwin_arm64.tar.gz -o gitleaks.tar.gz &&
          tar -xzf gitleaks.tar.gz &&
          chmod +x gitleaks &&
          sudo mv gitleaks /usr/local/bin/gitleaks
        else
          echo "Unsupported OS"
          exit 1
        fi
}

# Checking if Python is installed
    if ! command -v python &>/dev/null; then
        echo "Error: Python is not installed. Please install Python before running this script."
        exit 1
    fi

 # Install pre-commit
    pip install pre-commit

# Checking if gitleaks is installed
if ! command -v gitleaks &>/dev/null; then
  read -p "Gitleaks is not installed. Do you want to install it? (yes/no): " choice
  case "$choice" in
    yes|Yes|YES|y|Y )
      install_gitleaks
      ;;
    * )
      echo "Gitleaks installation skipped."
      ;;
  esac
else
  echo "Gitleaks is already installed."
fi

# Clean afteer installation
rm -rf gitleaks.tar.gz

# Checking the version of gitleaks after installation
echo "Gitleaks installed. Version:"
gitleaks version

# Create pre-commit configuration yaml file
    pre-commit sample-config > .pre-commit-config.yaml
    cat <<EOF >> .pre-commit-config.yaml
-   repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.1
    hooks:
    -   id: gitleaks
EOF

    # Update pre-commit hooks
    pre-commit autoupdate

    # Install pre-commit hooks
    pre-commit install --install-hooks

    # Run pre-commit
    pre-commit

    # Inform the user
    echo "Congratulations! Your commits are now protected from secret leakages."
