# Log Archive Tool

A Bash script to archive old log files into a compressed `.tar.gz` file.

This project is part of my DevOps learning journey, following the roadmap.sh DevOps path.

- Roadmap.sh project: https://roadmap.sh/projects/log-archive-tool
- Level: Beginner
- Main topics: Linux, Bash, Shell Scripting, Log Management, File Archiving

## Goal

The goal of this project is to create a command-line tool called `log-archive-tool.sh` that receives a log directory as an argument, finds old `.log` files, compresses them into a `.tar.gz` archive, and stores the archive in a dedicated directory.

This kind of script is useful for keeping servers clean, reducing disk usage, and preserving logs for future troubleshooting or audit purposes.

## Requirements from roadmap.sh

The original roadmap.sh project asks for a tool that:

- Runs from the command line
- Accepts the log directory as an argument
- Compresses logs into a `.tar.gz` file
- Stores the compressed archive in a new directory
- Logs the date and time of the archive creation to a file

Example usage from the roadmap:

```bash
log-archive <log-directory>
```

## Implemented features

This script currently:

- Receives the log directory as a command-line argument
- Validates if the argument was provided
- Checks if the provided directory exists
- Creates an archive directory at `$HOME/logs_archive`
- Finds `.log` files modified more than 7 days ago
- Compresses the selected logs into a `.tar.gz` file
- Adds the current date and time to the archive filename
- Stores the archive inside `$HOME/logs_archive`
- Records the archive creation in an activity log file
- Shows success and error messages in the terminal

## Technologies used

- Bash
- Linux CLI
- `find`
- `tar`
- `date`
- `mkdir`
- File permissions
- Log rotation concepts
- Basic error handling

## Project structure

```text
log-archive-tool/
├── README.md
└── log-archive-tool.sh
```

## How to run

Clone the repository:

```bash
git clone https://github.com/diegodmitry/devops-studies.git
```

Go to the project folder:

```bash
cd devops-studies/Beginner/log-archive-tool
```

Give execution permission:

```bash
chmod +x log-archive-tool.sh
```

Run the script with a log directory:

```bash
./log-archive-tool.sh /path/to/logs
```

Or run it directly with Bash:

```bash
bash log-archive-tool.sh /path/to/logs
```

Example using `/var/log`:

```bash
bash log-archive-tool.sh /var/log
```

> Note: depending on the directory, you may need permission to read some log files.

## Example output

When the archive is created successfully, the script shows a message similar to:

```text
Logs antigos foram arquivados com sucesso em /home/user/logs_archive/logs_2026-05-12_14-30-20.tar.gz.
```

The script also writes an entry to:

```text
$HOME/logs_archive/archive_log.txt
```

Example log entry:

```text
[2026-05-12 14:30:20] Arquivo criado: logs_2026-05-12_14-30-20.tar.gz
```

## Archive naming format

The generated archive follows this format:

```text
logs_YYYY-MM-DD_HH-MM-SS.tar.gz
```

Example:

```text
logs_2026-05-12_14-30-20.tar.gz
```

## Real-world scenario

A Linux server stores many application logs over time.

If old logs are not archived, they can consume disk space and make troubleshooting harder.

A support, infrastructure, cloud, or DevOps engineer can use this script to:

- Archive old log files
- Reduce disk usage
- Keep historical logs available
- Organize logs by archive date and time
- Maintain a simple record of archive activity

This helps keep the system cleaner while preserving logs for future investigation.

## What I practiced

With this project, I practiced:

- Writing Bash scripts
- Working with command-line arguments
- Validating user input
- Checking if directories exist
- Searching files with `find`
- Filtering files by modification date
- Compressing files with `tar`
- Creating timestamp-based filenames
- Writing activity logs
- Thinking about operational tasks used in Linux environments

## Requirements

This script is intended to run on Linux.

Recommended tools available on the system:

- `bash`
- `find`
- `tar`
- `date`
- `mkdir`

Some features may vary depending on file permissions and the Linux distribution.

## Current limitations

- The script archives only files ending in `.log`
- The script archives only logs modified more than 7 days ago
- The archive directory is fixed as `$HOME/logs_archive`
- The current terminal output is in Portuguese
- It does not delete original log files after archiving
- It does not support command-line options yet
- It does not send archives to remote storage
- It does not run automatically on a schedule yet

## Possible improvements

Future improvements:

- Translate the terminal output to English
- Add a `--help` option
- Add a configurable archive directory
- Add a configurable retention period, for example `--days 7`
- Add a `--dry-run` option to preview files before archiving
- Add ShellCheck validation
- Add automated tests
- Add support for scheduled execution with cron
- Add support for deleting original logs after successful archive
- Add support for remote backup to S3 or another storage service
- Add better handling when no matching log files are found

## Reference

- https://roadmap.sh/projects/log-archive-tool