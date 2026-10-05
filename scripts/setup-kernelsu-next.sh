#!/bin/bash
set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KSU_DIR="$ROOT_DIR/KernelSU-Next"
DRIVER_DIR="$ROOT_DIR/drivers"
TARGET_LINK="$DRIVER_DIR/kernelsu"
KSU_REPO_URL="https://github.com/KernelSU-Next/KernelSU-Next.git"

mkdir -p "$DRIVER_DIR"

if [ -L "$TARGET_LINK" ] || [ -e "$TARGET_LINK" ]; then
    rm -rf "$TARGET_LINK"
fi

if [ ! -d "$KSU_DIR/.git" ]; then
    git clone --depth 1 "$KSU_REPO_URL" "$KSU_DIR"
else
    git -C "$KSU_DIR" fetch --depth 1 --tags origin
    if git -C "$KSU_DIR" describe --tags --abbrev=0 >/dev/null 2>&1; then
        git -C "$KSU_DIR" checkout --detach "$(git -C "$KSU_DIR" describe --tags --abbrev=0)"
    else
        git -C "$KSU_DIR" checkout --detach "$(git -C "$KSU_DIR" rev-parse --abbrev-ref HEAD)"
    fi
fi

ln -s "../KernelSU-Next/kernel" "$TARGET_LINK"

echo "KernelSU-Next linked into $TARGET_LINK"
