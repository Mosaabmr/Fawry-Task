#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    exit 1
}

# Check for minimum arguments
if [ "$#" -lt 2 ]; then
    usage
fi

# Initialize flags
show_line_numbers=false
invert_match=false

# Parse options
while [[ "$1" == -* ]]; do
    case "$1" in
        *n*) show_line_numbers=true ;;
        *v*) invert_match=true ;;
        *) usage ;;
    esac
    shift
done

# Check if there are exactly 2 arguments left
if [ "$#" -ne 2 ]; then
    usage
fi

search="$1"
file="$2"

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found!"
    exit 1
fi

# Read the file line by line
line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))
    # Check match
    if echo "$line" | grep -i -q -- "$search"; then
        match=true
    else
        match=false
    fi

    # Handle invert match
    if $invert_match; then
        match=$(! $match && echo true || echo false)
    fi

    # Print if match
    if $match; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"
