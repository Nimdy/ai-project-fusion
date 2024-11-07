#!/bin/bash

# Output file
output_file="combined_data.txt"
# Maximum lines per file (user can adjust this limit)
max_lines=500
# Control whether to render the full directory tree
render_tree_output=true

# Directories to scan. Use "NONE" to skip directory scanning or "ALL" to scan the entire project.
# Example: directories=("NONE") or directories=("ALL") or directories=("/path/to/dir1" "/path/to/dir2")
directories=("app")

# Files to scan. Set your files here as an array.
# Example: files=("/path/to/file1.sh" "/path/to/file2.conf") or files=() to skip individual files
files=()

# Directories or files to ignore. Set your ignored paths or patterns here as an array.
# Example: ignore=("node_modules" ".next" "dist" ".env*" "*.log")
ignore=("node_modules" ".next" "dist" ".env*" "*.log" "packages" "public" "types" "infra" "constants")

# Enable color output if the terminal supports it
if command -v tput &> /dev/null && [ "$(tput colors)" -ge 8 ]; then
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    RED="$(tput setaf 1)"
    RESET="$(tput sgr0)"
else
    GREEN=""
    YELLOW=""
    RED=""
    RESET=""
fi

# Clear or create the output file
> "$output_file"

# User feedback: Start of script
echo -e "${GREEN}Starting the file and directory processing script...${RESET}"

# Check if directories are set to "NONE", "ALL", or a specific set of directories
if [[ ${#directories[@]} -eq 1 && ${directories[0]} == "NONE" ]]; then
    # Skip directory processing
    echo -e "${YELLOW}Skipping directory processing as 'NONE' is specified.${RESET}"
elif [[ ${#directories[@]} -eq 1 && ${directories[0]} == "ALL" ]]; then
    # Default to scanning the entire current directory
    directories=(".")
    echo -e "${YELLOW}'ALL' specified. Scanning the entire current directory.${RESET}"
fi

# Check if tree command exists and output directory structure
if command -v tree &> /dev/null; then
    echo "########## DIRECTORY STRUCTURE ##########" >> "$output_file"

    if [[ "$render_tree_output" == true ]]; then
        echo -e "${YELLOW}Rendering full directory tree structure...${RESET}"
        # Build a single ignore pattern for the tree command
        ignore_pattern=$(IFS="|"; echo "${ignore[*]}")
        tree . -I "$ignore_pattern" >> "$output_file"
    else
        echo -e "${GREEN}Rendering directory structure based on specified directories and ignoring certain paths...${RESET}"
        for dir in "${directories[@]}"; do
            # Build a single ignore pattern for the tree command
            ignore_pattern=$(IFS="|"; echo "${ignore[*]}")
            echo "Directory structure for $dir:" >> "$output_file"
            tree "$dir" -I "$ignore_pattern" >> "$output_file"
            echo -e "\n" >> "$output_file"
        done
    fi
else
    echo -e "${RED}tree command not found. Skipping directory structure.${RESET}" >> "$output_file"
fi
echo -e "\n\n" >> "$output_file"

# Only process directories if "NONE" is not specified
if [[ ${#directories[@]} -gt 0 && ${directories[0]} != "NONE" ]]; then
    # Build the ignore options for the find command, using -prune to skip directories
    ignore_prunes=()
    for item in "${ignore[@]}"; do
        ignore_prunes+=(-path "*/$item" -prune -o)
    done

    # Find and concatenate each file from the specified directories, skipping ignored directories and large files
    echo -e "${GREEN}Scanning directories for files...${RESET}"
    for dir in "${directories[@]}"; do
        find "$dir" \( "${ignore_prunes[@]}" -false \) -o -type f \( -name "*.sh" -o -name "*.tsx" -o -name "*.ts" -o -name "*.js" -o -name "*.jsx" \) -print | while read -r file; do
            # Count lines in the file
            line_count=$(wc -l < "$file")
            
            # Skip the file if it exceeds the max line limit
            if [ "$line_count" -gt "$max_lines" ]; then
                echo -e "${YELLOW}Skipping $file (too large: $line_count lines)${RESET}"
                continue
            fi
            
            # Add file path header and contents to output
            echo "########## FILE: $file ##########" >> "$output_file"
            cat "$file" >> "$output_file"
            echo -e "\n\n" >> "$output_file"
        done
    done
fi

# Process individual files specified in the files array
if [ ${#files[@]} -gt 0 ]; then
    echo -e "${GREEN}Processing specified individual files...${RESET}"
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            # Count lines in the file
            line_count=$(wc -l < "$file")
            
            # Skip the file if it exceeds the max line limit
            if [ "$line_count" -gt "$max_lines" ]; then
                echo -e "${YELLOW}Skipping $file (too large: $line_count lines)${RESET}"
                continue
            fi

            # Add file path header and contents to output
            echo "########## FILE: $file ##########" >> "$output_file"
            cat "$file" >> "$output_file"
            echo -e "\n\n" >> "$output_file"
        else
            echo -e "${RED}File $file not found. Skipping.${RESET}"
        fi
    done
fi

# User feedback: End of script
echo -e "${GREEN}Directory structure and selected files have been combined into $output_file with headers.${RESET}"
echo -e "${GREEN}Script completed successfully!${RESET}"
