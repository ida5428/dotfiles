#!/usr/bin/env bash

# Exit immediately if any command fails
set -e

# Check if a file path is provided
if [ $# -eq 0 ]; then
   echo "Usage: $0 <image-file-path>" >&2
   exit 1
fi

# Resolve input path
input_path="$1"

# Expand tilde if present
input_path="${input_path/#\~/$HOME}"

# Check if file exists
if [ ! -f "$input_path" ]; then
   echo "Error: File not found - $input_path" >&2
   exit 1
fi

# Use 'file' to check if it's an image
file_type="$(file --mime-type -b "$input_path")"
if [[ "$file_type" != image/* ]]; then
   echo "Error: Not an image file - $input_path" >&2
   exit 1
fi

# Create temporary PNG file
tmp_png="$(mktemp -t clipboard_image_XXXXXX).png"

# Convert to PNG using sips
if ! sips -s format png "$input_path" --out "$tmp_png" >/dev/null 2>&1; then
   echo "Error: Failed to convert image to PNG." >&2
   rm -f "$tmp_png"
   exit 1
fi

# Use osascript to copy to clipboard as raw PNG data
osascript <<EOF
set the clipboard to (read (POSIX file "$tmp_png") as «class PNGf»)
EOF

# Cleanup
rm -f "$tmp_png"

