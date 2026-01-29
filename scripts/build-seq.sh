#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2025 OpenWrt.org
#
# Manage build sequence numbers for image files
# Usage: scripts/build-seq.sh <command>
# Commands:
#   get      - Get current sequence number for today (and increment)
#   reset    - Reset sequence for today
#   get_date - Get current date in YYYYMMDD format
#   init     - Initialize the counter directory

# Counter directory in tmpfs (typically /run or /tmp)
COUNTER_DIR="${BUILD_SEQ_DIR:-/run/openwrt-build-seq}"
COUNTER_FILE="$COUNTER_DIR/counter"

# Initialize counter directory
init_counter() {
    mkdir -p "$COUNTER_DIR"
}

# Get current date in YYYYMMDD format
get_date() {
    date +%Y%m%d
}

# Get or create date file
get_date_file() {
    local date_file="$COUNTER_DIR/curr_date"
    if [ ! -f "$date_file" ]; then
        get_date > "$date_file"
    fi
    echo "$date_file"
}

# Check if date changed and reset counter if needed
check_date_change() {
    local date_file=$(get_date_file)
    local curr_date=$(get_date)
    local stored_date=$(cat "$date_file" 2>/dev/null || echo "")

    if [ "$curr_date" != "$stored_date" ]; then
        # Date changed, reset counter
        echo "$curr_date" > "$date_file"
        echo "1" > "$COUNTER_FILE"
        echo "1"
    else
        # Same date, read counter
        local counter=1
        if [ -f "$COUNTER_FILE" ]; then
            counter=$(cat "$COUNTER_FILE" 2>/dev/null || echo "1")
        else
            # First time today, initialize counter file
            echo "1" > "$COUNTER_FILE"
        fi
        echo "$counter"
    fi
}

# Get current sequence number (without incrementing)
get_seq() {
    init_counter
    check_date_change
}

# Increment and get sequence number
increment_seq() {
    init_counter
    local seq=$(check_date_change)
    seq=$((seq + 1))
    echo "$seq" > "$COUNTER_FILE"
    echo "$seq"
}

# Reset sequence for today
reset_seq() {
    init_counter
    local date_file=$(get_date_file)
    local curr_date=$(get_date)
    echo "$curr_date" > "$date_file"
    echo "1" > "$COUNTER_FILE"
    echo "1"
}

# Main command dispatcher
case "${1:-}" in
    get)
        increment_seq
        ;;
    get_date)
        get_date
        ;;
    reset)
        reset_seq
        ;;
    init)
        init_counter
        reset_seq
        ;;
    *)
        echo "Usage: $0 {get|get_date|reset|init}" >&2
        exit 1
        ;;
esac
