#!/bin/bash

# Output file
output_file="combined_data.txt"
# Maximum lines per file (user can adjust this limit)
max_lines=500

# Directories to scan. Set your directories here as an array.
# Example: directories=("/path/to/dir1" "/path/to/dir2")
directories=()

# Files to scan. Set your files here as an array.
# Example: files=("/path/to/file1.sh" "/path/to/file2.conf")
files=()

# Directories or files to ignore. Set your ignored paths or patterns here as an array.
# Example: ignore=("node_modules" ".next" "dist" ".env*" "*.log")
ignore=("node_modules" ".next" "dist" ".env*" "*.log" "packages")

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

# Build the ignore options for the find command, using -prune to skip directories
ignore_prunes=()
for item in "${ignore[@]}"; do
    ignore_prunes+=(-path "*/$item" -prune -o)
done

# Find and concatenate each file from the specified directories, skipping ignored directories and large files
for dir in "${directories[@]}"; do
    find "$dir" \( "${ignore_prunes[@]}" -false \) -o -type f \( -name "*.sh" -o -name "*.tsx" -o -name "*.ts" -o -name "*.js" -o -name "*.jsx" \) -print | while read -r file; do
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

# Process individual files specified in the files array
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
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
    else
        echo "File $file not found. Skipping."
    fi
done

echo "Directory structure and selected files have been combined into $output_file with headers."
