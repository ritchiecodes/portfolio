#!/bin/bash

# Define the quality (0-100, 80-85 is a good balance)
QUALITY=80

# Loop through all specified image types
for file in *.{jpg,jpeg,png,jfif}; do
  # Check if the file actually exists to handle cases where no files match the glob
  [ -e "$file" ] || continue
  
  # Extract the filename without the extension
  filename=$(basename -- "$file")
  extension="${filename##*.}"
  filename="${filename%.*}"
  
  # Convert the image using cwebp
  cwebp -q $QUALITY "$file" -o "${filename}.webp"
  
  echo "Converted $file to ${filename}.webp"
done

echo "Conversion complete!"
