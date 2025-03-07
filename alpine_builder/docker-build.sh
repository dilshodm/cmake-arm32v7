#!/bin/sh

REL=1

# Determine the directory of the script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

build_docker() {
    ARCH=$1
    PLATFORM=$2
    echo "!!! Building arch: $ARCH, platform: $PLATFORM !!!"

    # Release build
    docker build --platform $PLATFORM \
        -t dilshodm/apline-builder-$ARCH:3_${REL} \
        "$SCRIPT_DIR"
}

build_docker arm64 linux/arm64
build_docker amd64 linux/amd64
build_docker arm   linux/arm/v7
