#!/bin/bash

# Check if Docker command exists
if ! command -v docker &> /dev/null; then
    echo "Error: Docker command not found. Please make sure Docker is installed."
    exit 1
fi

# Argument handling
if [ $# -lt 2 ]; then
    echo "Error: Please provide image name and Dockerfile path as arguments."
    echo "Usage: $0 IMAGE_NAME DOCKERFILE_PATH"
    exit 1
fi

# Capture arguments
IMAGE_NAME="$1"
DOCKERFILE_PATH="$2"

# Ensure Dockerfile path exists
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "Error: Dockerfile '$DOCKERFILE_PATH' not found."
    exit 1
fi

# Get the Git branch name
BRANCH_NAME=$(git -C "$(dirname "$DOCKERFILE_PATH")" rev-parse --abbrev-ref HEAD)

# Get the Git commit hash (short format)
GIT_COMMIT=$(git -C "$(dirname "$DOCKERFILE_PATH")" rev-parse --short HEAD)

# Build with branch name and commit hash as build arguments
docker build -t "${IMAGE_NAME}:${BRANCH_NAME}" --build-arg BRANCH_NAME="${BRANCH_NAME}" --build-arg GIT_COMMIT="${GIT_COMMIT}" -f "${DOCKERFILE_PATH}" .

# Tag with commit ID
docker tag "${IMAGE_NAME}:${BRANCH_NAME}" "${IMAGE_NAME}:${GIT_COMMIT}"
