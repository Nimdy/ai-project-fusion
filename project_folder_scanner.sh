#!/bin/bash

# Output file
output_file="combined_data.txt"
# Maximum lines per file (user can adjust this limit)
max_lines=500
# Control whether to render the full directory tree
render_tree_output=true

# Directories to scan. Use "NONE" to skip directory scanning or "ALL" to scan the entire project.
# Example: directories=("src" "config") to scan these folders only.
directories=("src" "config" "scripts")

# Files to scan. Set your files here as an array.
# Example: Specify individual files like ("config/settings.js" "src/index.ts")
files=("src/main.ts" "config/settings.js" "scripts/deploy.sh" "src/components/ExampleComponent.tsx")

# Directories or files to ignore. Use simple paths or patterns.
# Example: ignore=("node_modules" "build" "dist" "logs")
ignore=("node_modules" ".next" "dist" "build" "logs" "test"
"src/private" "config/secret" "scripts/old-scripts")

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

# Render full directory tree if render_tree_output is true
if [[ "$render_tree_output" == true ]]; then
    if command -v tree &> /dev/null; then
        echo -e "${GREEN}Rendering full directory tree...${RESET}"
        echo "########## FULL DIRECTORY TREE ##########" >> "$output_file"
        
        # Build the ignore pattern for the tree command
        ignore_pattern=$(IFS="|"; echo "${ignore[*]}")
        tree . -I "$ignore_pattern" >> "$output_file"
        echo -e "\n\n" >> "$output_file"
    else
        echo -e "${RED}tree command not found. Skipping directory tree rendering.${RESET}"
    fi
fi

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
