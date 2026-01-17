#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2025 OpenWrt.org
#
# Add date and sequence number suffix to image files
# Usage: scripts/add-seq-suffix.sh <file>
#
# This script renames files from:
#   openwrt-mediatek-filogic-glinet_gl-mt3000-erofs-sysupgrade.bin
# to:
#   openwrt-mediatek-filogic-glinet_gl-mt3000-erofs-sysupgrade-20260117-1.bin
#
# The sequence number is shared among all images built in the same session.

set -e

FILE="$1"

if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
    echo "Error: File not found or not specified" >&2
    exit 1
fi

# Get TOPDIR - use environment variable or derive from script location
if [ -z "$TOPDIR" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    TOPDIR="$(dirname "$SCRIPT_DIR")"
fi

# Get directory, basename, and extension
DIR=$(dirname "$FILE")
BASENAME=$(basename "$FILE")

# Check if file has extension
if [[ "$BASENAME" =~ \.(.+)$ ]]; then
    EXT="${BASH_REMATCH[1]}"
    NAME_WITHOUT_EXT="${BASENAME%.$EXT}"
else
    EXT=""
    NAME_WITHOUT_EXT="$BASENAME"
fi

# Get sequence number and date - read from saved file (shared for all images in same build)
SEQ=""
DATE=""
SEQ_FILE=""

# Try to get SEQ_FILE from environment (set by make)
if [ -n "$BUILD_SEQ_FILE" ] && [ -f "$BUILD_SEQ_FILE" ]; then
    SEQ_FILE="$BUILD_SEQ_FILE"
fi

# Otherwise, try to find .build_seq file in build_dir (search in all target dirs)
if [ -z "$SEQ_FILE" ]; then
    SEQ_FILE=$(find "${TOPDIR}/build_dir" -type d -name "target*" -exec find {} -name ".build_seq" -type f \; 2>/dev/null | head -1)
fi

if [ -n "$SEQ_FILE" ] && [ -f "$SEQ_FILE" ]; then
    SEQ=$(cat "$SEQ_FILE" 2>/dev/null | head -1 | tr -d '[:space:]')
fi

# Get date from build-seq.sh (date doesn't increment)
DATE=$("${TOPDIR}/scripts/build-seq.sh" get_date)

# If still no seq, get a new one (fallback, shouldn't happen in normal flow)
if [ -z "$SEQ" ]; then
    SEQ=$("${TOPDIR}/scripts/build-seq.sh" get)
fi

# Construct new filename
if [ -n "$EXT" ]; then
    NEW_BASENAME="${NAME_WITHOUT_EXT}-${DATE}-${SEQ}.${EXT}"
else
    NEW_BASENAME="${NAME_WITHOUT_EXT}-${DATE}-${SEQ}"
fi

NEW_FILE="${DIR}/${NEW_BASENAME}"

# Rename the file
mv "$FILE" "$NEW_FILE"

echo "$NEW_FILE"
