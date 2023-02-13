#!/bin/bash

# Set the locale to the "C" locale
export LC_ALL=C

# Loop through each argument passed to the script
for f in "$@"
do
  # Run the ImageMagick "convert" command on the file specified by "f"
  convert "$f" \
  # Add a drop shadow to the image
  \( +clone -background black -shadow 25x5+5 \) +swap -background none -layers merge +repage \
  # Modify the RGBA channel of the image
  -channel RGBA -blur 0x2 -fill black -colorize 50% \
  # Change the brightness and saturation of the image
  -modulate 100,120 \
  # Modify the RGB channel of the image
  -channel RGB -sigmoidal-contrast 7,35% -modulate 100,120,100 \
  # Add a label to the image with the date and time specified in the EXIF data
  -pointsize 40 -font Monaco -fill "#FFA500" -gravity SouthWest \
  -annotate +50+50 "Date: $(identify -format "%[EXIF:DateTime]" "$1")" \
  # Save the result of all operations to a new file with a ".jpg" extension
  "${f}.jpg"
done
