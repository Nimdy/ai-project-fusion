
# Project Folder Scanner Script

This script helps gather content from configuration and script files in your project directories and combines it into a single file. This consolidated file can then be used with AI Language Models (LLMs) to help refine or generate prompts that better match your project structure and setup.

---

## Overview

The **Project Folder Scanner Script** is designed to:
- **Scan specified directories** for specific file types (e.g., `.sh`, `.conf`, `Dockerfile`).
- **Add directory structure information** if the `tree` command is available.
- **Combine files** into a single output file, `combined_data.txt`, to make it easier to provide an AI model with a full overview of your project.

This is especially helpful if you're working with multiple configuration or script files and want to provide the AI with a consolidated view of your project, improving its ability to understand the context when generating responses.

## How It Works

1. **Directory Structure**: Adds a directory structure overview (if `tree` is installed).
2. **File Content Inclusion**: Combines specified file types into one file, with headers indicating each file path.
3. **Line Limit**: Skips any files with lines exceeding a defined maximum (default is 500 lines) to prevent the output file from becoming too large.

---

## Requirements

- **Bash Shell**: Ensure you are using a bash-compatible shell to run the script.
- **`tree` Command**: If available, the `tree` command will add a directory structure to the output file.
  - Install it with:
    - **macOS**: `brew install tree`
    - **Ubuntu/Debian**: `sudo apt-get install tree`
    - **CentOS/RHEL**: `sudo yum install tree`

---

## Usage

### 1. Configure Directories

Open the script file and set your directories within the `directories` array:

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

If you leave `directories=()` empty, it will default to the current directory where the script is located.

### 2. Make the Script Executable

```bash
chmod +x project_folder_scanner.sh
```

### 3. Run the Script

```bash
./project_folder_scanner.sh
```

### 4. Review Output

After running, check `combined_data.txt` for the combined content. The file will include:
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

This script makes it easy to share project details with AI tools, helping them understand your project layout for better context when responding. Feel free to customize the directories and settings as needed for your use case.

