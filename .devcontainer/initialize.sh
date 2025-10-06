#!/usr/bin/env zsh

# Create .zsh_history file if it doesn't exist
touch "${PWD}/.zsh_history"

# Support multiple gitconfig files
# e.g. if ~/.gitconfig contains `includeIf` statements
# Create .gitconfigs directory and hard link all .gitconfig* files
mkdir -p ~/.gitconfigs
for file in ~/.gitconfig*; do
    if [ -f "$file" ]; then
        target=~/.gitconfigs/$(basename "$file")
        if [ ! -e "$target" ]; then
            ln "$file" "$target"
        fi
    fi
done

# You can add more files to create here, for example:
# touch "${PWD}/your_file.txt"env bash

# Create .zsh_history file if it doesn't exist
touch "${PWD}/.zsh_history"

# Create .gitconfigs directory and hard link all .gitconfig* files
mkdir -p ~/.gitconfigs
ln ~/.gitconfig* ~/.gitconfigs/ 2>/dev/null || true

# You can add more files to create here, for example:
# touch "${PWD}/your_file.txt"