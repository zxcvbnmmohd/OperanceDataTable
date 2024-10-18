#!/bin/bash

# create-branch.sh
echo "Select branch type:"
echo "1) feature"
echo "2) bugfix"
echo "3) hotfix"
echo "4) release"
echo "5) chore"

# shellcheck disable=SC2162
read -p "Enter your choice (1-5): " choice

case $choice in
  1) prefix="feature" ;;
  2) prefix="bugfix" ;;
  3) prefix="hotfix" ;;
  4) prefix="release" ;;
  5) prefix="chore" ;;
  *) echo "Invalid choice"; exit 1 ;;
esac

# shellcheck disable=SC2162
read -p "Enter branch name (use lowercase and hyphens): " name

branch="${prefix}/${name}"

git checkout -b "$branch"

echo "Created and switched to branch: $branch"