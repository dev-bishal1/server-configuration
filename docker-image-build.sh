#!/bin/bash

# Check if Docker command exists
if ! command -v docker &> /dev/null; then
    echo "Error: Docker command not found. Please make sure Docker is installed."
    exit 1
fi

# Argument handling
if [ $# -lt 2 ]; then
    echo "Error: Please provide image name and repository name as arguments."
    exit 1
fi

# Capture arguments
IMAGE_NAME="$1"
REPOSITORY_NAME="$2"

# Get the Git branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Get the Git commit hash (short format)
GIT_COMMIT=$(git rev-parse --short HEAD)

# Build Docker image with branch name and commit hash as tags
docker build -t "${IMAGE_NAME}:${BRANCH_NAME}" -t "${IMAGE_NAME}:${GIT_COMMIT}" .

# Tag image with repository name for pushing
docker tag "${IMAGE_NAME}:${BRANCH_NAME}" "${REPOSITORY_NAME}:${BRANCH_NAME}"
docker tag "${IMAGE_NAME}:${GIT_COMMIT}" "${REPOSITORY_NAME}:${GIT_COMMIT}"

# Push the image to the repository with all tags
docker push "${REPOSITORY_NAME}" --all-tags
