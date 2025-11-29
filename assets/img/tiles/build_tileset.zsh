#!/usr/bin/env zsh
set -e

cd "$(dirname "$0")" || exit 1

# Only regular .png files, no directories, no .import etc.
tiles=( *.png(.N) )

if (( ${#tiles[@]} == 0 )); then
  echo "No .png tiles found"
  exit 1
fi

cols=4
rows=$(( (${#tiles[@]} + cols - 1) / cols ))

magick montage "${tiles[@]}" \
  -tile ${cols}x${rows} \
  -geometry +0+0 \
  tileset.png
