#!/bin/bash

# Read the branch name from user input
read -p "Enter the branch name: " branch_name

# Check if the branch exists
if git show-ref --quiet refs/heads/"$branch_name"; then
  # Branch exists, so checkout to it
  echo "Branch '$branch_name' already exists. Checking out..."
  git checkout "$branch_name"
else
  # Branch doesn't exist, ask to create it
  read -p "Branch '$branch_name' does not exist. Do you want to create it? (y/n): " create_branch

  if [ "$create_branch" == "y" ] || [ "$create_branch" == "Y" ]; then
    # Create the branch and checkout to it
    git checkout -b "$branch_name"
    echo "Branch '$branch_name' created and checked out."
    read -p "Do you want to push it in remote? (y/n): " create_remote
    if [ "$create_remote" == "y" ] || [ "$create_remote" == "Y" ]; then
        git push --set-upstream origin "$branch_name"
    fi
  else
    echo "Branch '$branch_name' was not created."
  fi
fi
