#!/bin/bash

# Check if Docker command exists
if ! command -v docker &> /dev/null; then
    echo "Error: Docker command not found. Please make sure Docker is installed."
    exit 1
fi

# Argument handling
if [ $# -lt 1 ]; then
    echo "Error: Please provide image name as arguments."
    exit 1
fi

# Capture arguments
IMAGE_NAME="$1"

# Get the Git branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Get the Git commit hash (short format)
GIT_COMMIT=$(git rev-parse --short HEAD)

# Build with branch name and commit hash as build arguments
docker build -t "${IMAGE_NAME}:${BRANCH_NAME}" --build-arg BRANCH_NAME="${BRANCH_NAME}" --build-arg GIT_COMMIT="${GIT_COMMIT}" .

# Tag with commit ID
docker tag "${IMAGE_NAME}:${BRANCH_NAME}" "${IMAGE_NAME}:${GIT_COMMIT}"
