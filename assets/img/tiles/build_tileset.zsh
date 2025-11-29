#!/usr/bin/env zsh
set -e

cd "$(dirname "$0")" || exit 1

# Only regular .png files, no directories, no .import etc.
src_tiles=( *.png(.N) )

if (( ${#src_tiles[@]} == 0 )); then
  echo "No .png tiles found"
  exit 1
fi

echo "Found ${#src_tiles[@]} source tiles"

# --- Shave configuration ----------------------------------------------------
# Amount to remove from each side in pixels
shave_left=83
shave_right=78
shave_top=75
shave_bottom=84

# Final tile size after crop (change to 32 if you really want 32x32)
target_size=150

# Directory for processed (cropped + resized) tiles
processed_dir="processed_tiles"
mkdir -p "$processed_dir"

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

  # crop and resize
  magick "$f" \
    -crop ${new_width}x${new_height}+${offset_x}+${offset_y} +repage \
    -resize ${target_size}x${target_size}\! \
    -background none \
    "$processed_dir/$f"
done
