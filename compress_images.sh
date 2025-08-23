#!/bin/bash

# Image compression script for web optimization
# This script compresses images to web-friendly sizes while maintaining quality

echo "Starting image compression for web optimization..."

# Create compressed directory structure
mkdir -p "assets/images/Gallery-compressed/Cycling man"
mkdir -p "assets/images/Gallery-compressed/Habor Fest at Downtown Boston"
mkdir -p "assets/images/Gallery-compressed/New Entry Event/Summer Farm Picnic"
mkdir -p "assets/images/Gallery-compressed/Travel highlights"
mkdir -p "assets/images/Gallery-compressed/Weekend Markets at Downtown Boston"

# Function to compress images
compress_image() {
    local input_file="$1"
    local output_file="$2"
    
    if [ -f "$input_file" ]; then
        echo "Compressing: $input_file"
        
        # Get original dimensions
        local width=$(sips -g pixelWidth "$input_file" | tail -1 | cut -d: -f2 | tr -d ' ')
        local height=$(sips -g pixelHeight "$input_file" | tail -1 | cut -d: -f2 | tr -d ' ')
        
        # Calculate new dimensions (max 1200px for web, maintain aspect ratio)
        local max_dimension=1200
        local new_width=$width
        local new_height=$height
        
        if [ $width -gt $max_dimension ] || [ $height -gt $max_dimension ]; then
            if [ $width -gt $height ]; then
                new_width=$max_dimension
                new_height=$((height * max_dimension / width))
            else
                new_height=$max_dimension
                new_width=$((width * max_dimension / height))
            fi
        fi
        
        # Compress image with sips
        sips -s format jpeg -z $new_height $new_width --setProperty formatOptions quality=0.8 "$input_file" --out "$output_file"
        
        # Get compressed file size
        local original_size=$(stat -f%z "$input_file")
        local compressed_size=$(stat -f%z "$output_file")
        local reduction=$((100 - (compressed_size * 100 / original_size)))
        
        echo "  Original: ${width}x${height}, ${original_size} bytes"
        echo "  Compressed: ${new_width}x${new_height}, ${compressed_size} bytes"
        echo "  Size reduction: ${reduction}%"
    fi
}

echo "Compressing Cycling man images..."
for img in "assets/images/Gallery/Cycling man"/*.{jpg,JPG,jpeg}; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        compress_image "$img" "assets/images/Gallery-compressed/Cycling man/$filename"
    fi
done

echo "Compressing Habor Fest images..."
for img in "assets/images/Gallery/Habor Fest at Downtown Boston"/*.{jpg,JPG,jpeg}; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        compress_image "$img" "assets/images/Gallery-compressed/Habor Fest at Downtown Boston/$filename"
    fi
done

echo "Compressing Summer Farm Picnic images..."
for img in "assets/images/Gallery/New Entry Event/Summer Farm Picnic"/*.{jpg,JPG,jpeg}; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        compress_image "$img" "assets/images/Gallery-compressed/New Entry Event/Summer Farm Picnic/$filename"
    fi
done

echo "Compressing Travel highlights images..."
for img in "assets/images/Gallery/Travel highlights"/*.{jpg,JPG,jpeg}; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        compress_image "$img" "assets/images/Gallery-compressed/Travel highlights/$filename"
    fi
done

echo "Compressing Weekend Markets images..."
for img in "assets/images/Gallery/Weekend Markets at Downtown Boston"/*.{jpg,JPG,jpeg}; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        compress_image "$img" "assets/images/Gallery-compressed/Weekend Markets at Downtown Boston/$filename"
    fi
done

echo "Compression complete!"
echo "Original Gallery size: $(du -sh assets/images/Gallery | cut -f1)"
echo "Compressed Gallery size: $(du -sh assets/images/Gallery-compressed | cut -f1)"
echo ""
echo "You can now:"
echo "1. Review the compressed images in assets/images/Gallery-compressed/"
echo "2. Replace the original Gallery folder with the compressed version"
echo "3. Add the compressed images to git and push to GitHub"
