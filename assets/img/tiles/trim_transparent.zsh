#!/usr/bin/env zsh
set -e

cd "$(dirname "$0")" || exit 1

# INPUT DIRECTORY (change if needed)
input_dir="unprocessed_tiles"

# OUTPUT DIRECTORY
output_dir="processed_tiles"

# Create output directory
mkdir -p "$output_dir"

# Read only .png files from the input directory
src_tiles=(${input_dir}/*.png(.N))

if (( ${#src_tiles[@]} == 0 )); then
  echo "No .png tiles found in $input_dir"
  exit 1
fi

echo "Found ${#src_tiles[@]} source tiles in $input_dir"

target_size=150

echo "Preprocessing tiles (auto-trim transparent border, resize to ${target_size}x${target_size})..."

for f in $src_tiles; do
  filename="${f:t}"   # extract filename only (strip path)
  magick "$f" -alpha on -trim +repage -resize ${target_size}x${target_size}! -background none "$output_dir/$filename"
done

echo "Done. Output in: $output_dir"
