#!/usr/bin/env zsh
set -e

cd "$(dirname "$0")" || exit 1

# INPUT directory with original tiles
input_dir="unprocessed_tiles"

# OUTPUT directory for processed (cropped + resized) tiles
processed_dir="processed_tiles"
mkdir -p "$processed_dir"

# Only regular .png files from the input directory, no .import etc.
src_tiles=(${input_dir}/*.png(.N))

if (( ${#src_tiles[@]} == 0 )); then
  echo "No .png tiles found in $input_dir"
  exit 1
fi

echo "Found ${#src_tiles[@]} source tiles in $input_dir"

# --- Shave configuration ----------------------------------------------------
shave_left=87
shave_right=82
shave_top=80
shave_bottom=88

# Final tile size
target_size=150

echo "Preprocessing tiles (crop L=${shave_left}, R=${shave_right}, T=${shave_top}, B=${shave_bottom}, resize to ${target_size}x${target_size})..."

for f in "${src_tiles[@]}"; do
  # get original width and height
  read width height <<< "$(magick identify -format "%w %h" "$f")"

  # compute new cropped size
  new_width=$(( width - shave_left - shave_right ))
  new_height=$(( height - shave_top - shave_bottom ))

  if (( new_width <= 0 || new_height <= 0 )); then
    echo "Skipping $f: crop would result in non-positive size (${new_width}x${new_height})"
    continue
  fi

  offset_x=$shave_left
  offset_y=$shave_top

  # output filename (strip directory from $f)
  filename="${f:t}"

  # crop and resize (single line to avoid CLI parsing issues)
  magick "$f" -crop ${new_width}x${new_height}+${offset_x}+${offset_y} +repage -resize ${target_size}x${target_size}! -background none "$processed_dir/$filename"
done

echo "Done. Processed tiles in: $processed_dir"
