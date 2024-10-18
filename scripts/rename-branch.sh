#!/bin/bash

# fix-branch-name.sh

# Function to validate the branch name
validate_branch_name() {
    local branch_name="$1"
    local valid_pattern="^(feature|bugfix|hotfix|release|chore)/[a-z0-9-]+$"
    if [[ $branch_name =~ $valid_pattern ]]; then
        return 0
    else
        return 1
    fi
}

# Get current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

if validate_branch_name "$current_branch"; then
    echo "Current branch name '$current_branch' already follows the convention. No changes needed."
    exit 0
fi

echo "Current branch name: $current_branch"
echo "This branch name doesn't follow the new naming convention."
echo "Let's fix it!"

# Extract existing prefix and name
if [[ $current_branch == *"/"* ]]; then
    prefix=$(echo "$current_branch" | cut -d'/' -f1)
    name=$(echo "$current_branch" | cut -d'/' -f2-)
else
    prefix=""
    name="$current_branch"
fi

# Prompt for new prefix
echo "Select branch type:"
echo "1) feature"
echo "2) bugfix"
echo "3) hotfix"
echo "4) release"
echo "5) chore"
read -p "Enter your choice (1-5): " choice

case $choice in
    1) new_prefix="feature" ;;
    2) new_prefix="bugfix" ;;
    3) new_prefix="hotfix" ;;
    4) new_prefix="release" ;;
    5) new_prefix="chore" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

# Prompt for new name
read -p "Enter new branch name (use lowercase and hyphens, leave blank to keep '$name'): " new_name
new_name=${new_name:-$name}

# Convert to lowercase and replace spaces with hyphens
new_name=$(echo "$new_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Construct new branch name
new_branch_name="$new_prefix/$new_name"

# Validate new branch name
if ! validate_branch_name "$new_branch_name"; then
    echo "Error: The new branch name '$new_branch_name' is not valid."
    echo "It should follow the pattern: <type>/<description>"
    echo "Where <type> is one of: feature, bugfix, hotfix, release, chore"
    echo "And <description> uses only lowercase letters, numbers, and hyphens."
    exit 1
fi

echo "New branch name will be: $new_branch_name"
read -p "Do you want to rename the branch? (y/n): " confirm

if [[ $confirm == [Yy]* ]]; then
    git branch -m "$new_branch_name"
    echo "Branch renamed successfully."
    echo "If this branch was already pushed to remote, you'll need to:"
    echo "1. Delete the old remote branch: git push origin --delete $current_branch"
    echo "2. Push the new branch: git push -u origin $new_branch_name"
else
    echo "Branch renaming cancelled."
fi