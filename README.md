
# AI Project Fusion

AI Project Fusion is a powerful tool that consolidates essential project files and configurations into a single, AI-friendly format. By automatically gathering and combining files from your project directories, it optimizes context for AI Language Models (LLMs), helping you generate better, more insightful prompts.

---

## Overview

AI Project Fusion is designed to:
- **Scan specified directories and files** for common configuration and script types (e.g., `.sh`, `.conf`, `Dockerfile`).
- **Include a directory structure** overview if the `tree` command is available.
- **Control tree rendering**: Choose between rendering the full directory tree or a custom tree based on specified directories.
- **Skip large files** exceeding a customizable line count (default: 500 lines) to maintain a manageable output.
- **Ignore unwanted directories and files** using customizable patterns.

This makes it easier to provide AI models with a well-organized overview of your project, improving their understanding and the quality of responses.

---

## Requirements

- **Bash Shell**: Ensure you are using a bash-compatible shell to run the script.
- **`tree` Command**: If available, the `tree` command will add a directory structure overview to the output.
  - Install it with:
    - **macOS**: `brew install tree`
    - **Ubuntu/Debian**: `sudo apt-get install tree`
    - **CentOS/RHEL**: `sudo yum install tree`

---

## Configuration

### Output File
The script writes all combined data to `combined_data.txt`.

### Maximum Line Limit
```bash
max_lines=500
```
- Adjust this value to change the maximum number of lines allowed per file.

### Directory Scanning
Specify directories to scan:
```bash
directories=("NONE")  # Options: "NONE", "ALL", or specify directories like ("/path/to/dir1" "/path/to/dir2")
```
- **`NONE`**: Skip directory scanning.
- **`ALL`**: Scan the entire current directory.
- **Custom Directories**: Specify one or more directories to scan.

### File Inclusion
Specify individual files to include:
```bash
files=("app/layout.tsx")  # Add more files as needed
```

### Ignore List
Define patterns to exclude from the scan:
```bash
ignore=("node_modules" ".next" "dist" ".env*" "*.log" "packages" "public" "types" "infra" "constants")
```
- Use patterns to skip specific directories or files.

### Tree Output Control
Control how the directory tree is rendered:
```bash
render_tree_output=true  # Set to false to render a custom tree respecting ignore settings
```

---

## Usage

### 1. Configure Directories and Files

Open the script file and set your directories, files, and ignore patterns in the arrays.

### 2. Make the Script Executable

```bash
chmod +x ai_project_fusion.sh
```

### 3. Run the Script

```bash
./ai_project_fusion.sh
```

### 4. Review Output

Check `combined_data.txt` for the combined content, which includes:
- The directory structure (if `tree` is available and configured to render).
- Each file’s content with headers marking the file path.

---

## Example Output

```
########## DIRECTORY STRUCTURE ##########
.
├── config
│   └── settings.conf
└── scripts
    └── start.sh

########## FILE: ./config/settings.conf ##########
# Example config settings
setting=value

########## FILE: ./scripts/start.sh ##########
#!/bin/bash
echo "This is a sample script"
```

---

## Customization

- **Adjust `max_lines`**: Change the `max_lines` variable to set the maximum number of lines per file.
- **Control Tree Rendering**: Use `render_tree_output` to choose between full or custom tree rendering.
- **Add or Remove File Types**: Modify the `find` command in the script to include or exclude specific file types.
- **Expand or Simplify the Ignore List**: Update the `ignore` array to exclude more or fewer items.

This tool is ideal for developers who want to enhance AI-driven workflows by providing clear and comprehensive project contexts. Feel free to customize it further for your needs!

---

## Troubleshooting

- **`tree` Command Not Found**: Install `tree` using your package manager.
- **Files or Directories Not Ignored**: Ensure your patterns in the `ignore` array are correctly formatted.

---

## License

This script is open-source and available under the MIT License. Feel free to modify and use it in your projects.

---

## Contributions

Contributions are welcome! If you have suggestions or improvements, please submit a pull request or open an issue.

---

Enjoy using AI Project Fusion, and feel free to reach out if you have any questions or need further assistance!
