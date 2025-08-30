#!/bin/bash

# Compress large images that are causing GitHub Pages issues
# This script targets the specific large files identified

echo "Starting compression of large images for GitHub Pages optimization..."

# Create compressed directory
mkdir -p "assets/images/compressed"

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
    else
        echo "File not found: $input_file"
    fi
}

# Compress the specific large files identified
echo "Compressing large gallery images..."

# Large files that need compression
compress_image "assets/images/gallery/_DSC3449.JPG" "assets/images/compressed/_DSC3449.jpg"
compress_image "assets/images/gallery/_DSC0416.JPG" "assets/images/compressed/_DSC0416.jpg"
compress_image "assets/images/gallery/_DSC7819.JPG" "assets/images/compressed/_DSC7819.jpg"

# Also check for other potentially large images
echo "Checking for other large images..."
find assets/images -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.JPG" | while read file; do
    size=$(stat -f%z "$file")
    if [ $size -gt 5000000 ]; then  # Files larger than 5MB
        echo "Large file found: $file ($(($size / 1024 / 1024))MB)"
        filename=$(basename "$file")
        compress_image "$file" "assets/images/compressed/$filename"
    fi
done

echo ""
echo "Compression complete!"
echo "Compressed images are in: assets/images/compressed/"
echo ""
echo "Next steps:"
echo "1. Review the compressed images"
echo "2. Replace the original large files with compressed versions"
echo "3. Update your HTML files to reference the new compressed images"
echo "4. Commit and push to trigger GitHub Pages rebuild"
