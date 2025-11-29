#!/usr/bin/env zsh
set -e

# Directory with the preprocessed 150x150 tiles
src_dir="processed_tiles"

cd "$(dirname "$0")" || exit 1
cd "$src_dir" || { echo "Cannot cd into $src_dir"; exit 1; }

# Only regular .png files, ignore .import etc.
tiles=( *.png(.N) )

if (( ${#tiles[@]} == 0 )); then
  echo "No preprocessed .png tiles found in $src_dir"
  exit 1
fi

echo "Building tileset from ${#tiles[@]} tiles..."

# Choose columns so grid is roughly square: smallest c with c*c >= n
n=${#tiles[@]}
cols=1
while (( cols * cols < n )); do
  (( cols++ ))
done
rows=$(( (n + cols - 1) / cols ))

echo "Grid: ${cols} columns x ${rows} rows"

# Build atlas with NO gaps (each tile already 150x150)
magick montage "${tiles[@]}" \
  -tile ${cols}x${rows} \
  -geometry +0+0 \
  -background none \
  ../tileset.png

echo "Done -> $(cd .. && pwd)/tileset.png"