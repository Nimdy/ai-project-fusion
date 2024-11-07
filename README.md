
# AI Project Fusion

AI Project Fusion is a powerful tool that consolidates essential project files and configurations into a single, AI-friendly format. By automatically gathering and combining files from your project directories, it optimizes context for AI Language Models (LLMs), helping you generate better, more insightful prompts.

---

## Overview

AI Project Fusion is designed to:
- **Scan specified directories and files** for common configuration and script types (e.g., `.sh`, `.conf`, `Dockerfile`).
- **Include a directory structure** overview if the `tree` command is available.
- **Combine content** into one output file, `combined_data.txt`, with headers for each file and directory structure details.
- **Skip large files** exceeding a customizable line count (default: 500 lines) to maintain a manageable output.

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

## Usage

### 1. Configure Directories and Files

Open the script file and set your directories and files in the arrays:

- **Directories**: Add the paths of directories you want to scan.
  ```bash
  directories=("/path/to/dir1" "/path/to/dir2")
  ```

  - **Single Directory Example**:
    ```bash
    directories=("/home/user/projects/my_project")
    ```

  - **Multiple Directories Example**:
    ```bash
    directories=("/home/user/projects/my_project" "/home/user/other_project")
    ```

- **Files**: Add individual file paths to scan.
  ```bash
  files=("/path/to/file1.sh" "/path/to/file2.conf")
  ```

  - **Single File Example**:
    ```bash
    files=("/home/user/projects/my_project/start.sh")
    ```

  - **Multiple Files Example**:
    ```bash
    files=("/home/user/config/settings.conf" "/home/user/scripts/deploy.sh")
    ```

If you leave `directories=()` empty, it will default to the current directory (`.`).

### 2. Make the Script Executable

```bash
chmod +x project_folder_scanner_updated.sh
```

### 3. Run the Script

```bash
./project_folder_scanner_updated.sh
```

### 4. Review Output

Check `combined_data.txt` for the combined content, which includes:
- The directory structure (if `tree` is available).
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
- **Add or Remove File Types**: Modify the `find` command in the script to include or exclude specific file types.

This tool is ideal for developers who want to enhance AI-driven workflows by providing clear and comprehensive project contexts. Feel free to customize it further for your needs!
