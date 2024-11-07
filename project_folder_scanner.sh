#!/bin/bash

# Output file
output_file="combined_data.txt"
# Maximum lines per file (user can adjust this limit)
max_lines=500
# Control whether to render the full directory tree
render_tree_output=false

# Directories to scan. Use "NONE" to skip directory scanning or "ALL" to scan the entire project.
# Example: directories=("src") to scan a single folder or directories=("src" "lib") to scan multiple folders.
directories=("src")

# Files to scan. Set specific files to process here.
# Example: files=("scripts/setup.sh" "config/settings.js")
files=("scripts/example.sh" "config/sample-config.js" "src/utils/helper.ts")

# Directories or files to ignore. Use simple paths or patterns.
# Example: ignore=("node_modules" "dist" "test" "*.log" "config/secret")
ignore=("node_modules" "dist" "build" "public" "test" "logs" "src/private" "src/temp")

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
    echo -e "${YELLOW}Skipping directory processing as 'NONE' is specified.${RESET}"
elif [[ ${#directories[@]} -eq 1 && ${directories[0]} == "ALL" ]]; then
    directories=(".")
    echo -e "${YELLOW}'ALL' specified. Scanning the entire current directory.${RESET}"
fi

# Function to clean up temporary files
cleanup() {
    if [[ -n "$temp_files" && -f "$temp_files" ]]; then
        rm -f "$temp_files"
    fi
}

# Improved ignore logic for the `find` command
if [[ ${#directories[@]} -gt 0 && ${directories[0]} != "NONE" ]]; then
    echo -e "${GREEN}Scanning directories for files...${RESET}"

    # Create a temporary file for listing files
    temp_files=$(mktemp) || { echo -e "${RED}Failed to create a temporary file. Exiting.${RESET}"; exit 1; }

    # Use trap to ensure the temporary file is removed on script exit or error
    trap cleanup EXIT

    # Iterate over each directory in the directories array and use find
    for dir in "${directories[@]}"; do
        # List all relevant files and save to the temporary file
        if ! find "$dir" -type f \( -name "*.sh" -o -name "*.tsx" -o -name "*.ts" -o -name "*.js" -o -name "*.jsx" \) > "$temp_files"; then
            echo -e "${RED}Failed to execute find command. Exiting.${RESET}"
            exit 1
        fi

        # Filter out ignored paths
        while read -r file; do
            should_ignore=false
            for ignore_path in "${ignore[@]}"; do
                if [[ "$file" == *"$ignore_path"* ]]; then
                    should_ignore=true
                    break
                fi
            done

            if [ "$should_ignore" = false ]; then
                line_count=$(wc -l < "$file")
                if [ "$line_count" -gt "$max_lines" ]; then
                    echo -e "${YELLOW}Skipping $file (too large: $line_count lines)${RESET}"
                    continue
                fi
                echo "########## FILE: $file ##########" >> "$output_file"
                cat "$file" >> "$output_file"
                echo -e "\n\n" >> "$output_file"
            fi
        done < "$temp_files"
    done
fi

# Process individual files specified in the files array
if [ ${#files[@]} -gt 0 ]; then
    echo -e "${GREEN}Processing specified individual files...${RESET}"
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            line_count=$(wc -l < "$file")
            if [ "$line_count" -gt "$max_lines" ]; then
                echo -e "${YELLOW}Skipping $file (too large: $line_count lines)${RESET}"
                continue
            fi
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
