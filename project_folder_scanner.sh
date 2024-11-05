#!/bin/bash

# Output file
output_file="combined_data.txt"
# Maximum lines per file (user can adjust this limit)
max_lines=500

# Directories to scan. Set your directories here as an array.
# Example: directories=("/path/to/dir1" "/path/to/dir2")
directories=("/path/to/dir1" "/path/to/dir2")

# If no directories are specified, default to the current directory
if [ ${#directories[@]} -eq 0 ]; then
    directories=(".")
fi

# Clear or create the output file
> "$output_file"

# Check if tree command exists and run it on each specified directory
if command -v tree &> /dev/null; then
    echo "########## DIRECTORY STRUCTURE ##########" >> "$output_file"
    for dir in "${directories[@]}"; do
        echo "Directory structure for $dir:" >> "$output_file"
        tree "$dir" >> "$output_file"
        echo -e "\n" >> "$output_file"
    done
else
    echo "tree command not found. Skipping directory structure." >> "$output_file"
fi
echo -e "\n\n" >> "$output_file"

# Find and concatenate each file from the specified directories, skipping large files
for dir in "${directories[@]}"; do
    find "$dir" -type f \( -name "*.sh" -o -name "*.conf" -o -name "*.config" -o -name "*.cnf" -o -name "*.cf" -o -name "*.yml" -o -name "Dockerfile" \) | while read -r file; do
        # Count lines in the file
        line_count=$(wc -l < "$file")
        
        # Skip the file if it exceeds the max line limit
        if [ "$line_count" -gt "$max_lines" ]; then
            echo "Skipping $file (too large: $line_count lines)"
            continue
        fi
        
        # Add file path header and contents to output
        echo "########## FILE: $file ##########" >> "$output_file"
        cat "$file" >> "$output_file"
        echo -e "\n\n" >> "$output_file"
    done
done

echo "Directory structure and selected files have been combined into $output_file with headers."
