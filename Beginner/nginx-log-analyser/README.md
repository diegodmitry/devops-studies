# Nginx Log Analyser

A Bash script to analyze Nginx access logs from the command line.

This project is part of my DevOps learning journey, following the roadmap.sh DevOps path.

- Roadmap.sh project: https://roadmap.sh/projects/nginx-log-analyser
- Level: Beginner
- Main topics: Linux, Bash, Shell Scripting, Log Analysis, Nginx, Command Line Tools

## Goal

The goal of this project is to create a command-line tool called `nginx-log-analyser.sh` that receives an Nginx access log file as an argument and extracts useful operational information from it.

This kind of script is useful for support, infrastructure, DevOps, and SRE tasks, where engineers often need to quickly inspect logs, identify traffic patterns, detect errors, and support troubleshooting activities.

## Requirements from roadmap.sh

The original roadmap.sh project asks for a shell script that reads an Nginx access log file and provides the following information:

- Top 5 IP addresses with the most requests
- Top 5 most requested paths
- Top 5 response status codes
- Top 5 user agents

The log file contains fields such as:

- IP address
- Date and time
- Request method and path
- Response status code
- Response size
- Referrer
- User agent

Example expected output:

```text
Top 5 IP addresses with the most requests:
45.76.135.253 - 1000 requests
142.93.143.8 - 600 requests
178.128.94.113 - 50 requests
43.224.43.187 - 30 requests
178.128.94.113 - 20 requests

Top 5 most requested paths:
/api/v1/users - 1000 requests
/api/v1/products - 600 requests
/api/v1/orders - 50 requests
/api/v1/payments - 30 requests
/api/v1/reviews - 20 requests

Top 5 response status codes:
200 - 1000 requests
404 - 600 requests
500 - 50 requests
401 - 30 requests
304 - 20 requests
```

## Implemented features

This script currently:

- Receives the Nginx log file as a command-line argument
- Validates if the log file argument was provided
- Extracts the top 5 IP addresses with the most requests
- Extracts the top 5 most requested paths
- Extracts the top 5 response status codes
- Extracts the top 5 user agents
- Uses standard Linux command-line tools to process and count log data
- Shows the analysis result directly in the terminal

## Technologies used

- Bash
- Linux CLI
- `awk`
- `sort`
- `uniq`
- `head`
- Nginx access logs
- Basic text processing
- Shell scripting
- Command-line arguments

## Project structure

```text
nginx-log-analyser/
├── README.md
└── nginx-log-analyser.sh
```

## How to run

Clone the repository:

```bash
git clone https://github.com/diegodmitry/devops-studies.git
```

Go to the project folder:

```bash
cd devops-studies/Beginner/nginx-log-analyser
```

Give execution permission:

```bash
chmod +x nginx-log-analyser.sh
```

Run the script with an Nginx access log file:

```bash
./nginx-log-analyser.sh /path/to/access.log
```

Or run it directly with Bash:

```bash
bash nginx-log-analyser.sh /path/to/access.log
```

Example:

```bash
bash nginx-log-analyser.sh nginx-access.log
```

## Example output

The script shows an output similar to:

```text
Top 5 Endereços IP mais requisitados:
45.76.135.253 - 1000 requests
142.93.143.8 - 600 requests
178.128.94.113 - 50 requests
43.224.43.187 - 30 requests
134.209.120.185 - 20 requests

Top 5 Caminhos mais requisitados:
/api/v1/users - 1000 requests
/api/v1/products - 600 requests
/api/v1/orders - 50 requests
/api/v1/payments - 30 requests
/api/v1/reviews - 20 requests

Top 5 Códigos de Status de Resposta:
200 - 1000 requests
404 - 600 requests
500 - 50 requests
401 - 30 requests
304 - 20 requests

Top 5 User Agents:
Mozilla/5.0 - 700 requests
curl/7.68.0 - 300 requests
PostmanRuntime/7.29.0 - 100 requests
```

## How the script works

### Top 5 IP addresses

```bash
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5
```

This command:

- Extracts the first field from each log line
- Sorts the IP addresses
- Counts repeated IPs
- Sorts the result from highest to lowest
- Shows only the top 5 results

### Top 5 requested paths

```bash
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5
```

This command extracts the request path from the log file.

In a common Nginx access log format, the path is usually located in field 7.

### Top 5 response status codes

```bash
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5
```

This command extracts the HTTP status code from each request.

Common examples:

- `200` - Success
- `301` - Redirect
- `400` - Bad request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not found
- `500` - Internal server error

### Top 5 user agents

```bash
awk -F\" '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5
```

This command uses double quotes as a field separator and extracts the user agent from the log line.

## Real-world scenario

A production Nginx server receives many requests every day.

When an incident happens, a support, infrastructure, cloud, or DevOps engineer may need to quickly answer questions such as:

- Which IP addresses are making the most requests?
- Which endpoints are receiving the most traffic?
- Are there many `404`, `401`, or `500` errors?
- Which clients, browsers, bots, or tools are accessing the system?
- Is there any suspicious or unusual traffic pattern?

This script helps with a quick first-level analysis directly from the terminal.

## What I practiced

With this project, I practiced:

- Writing Bash scripts
- Working with command-line arguments
- Reading and processing log files
- Extracting fields with `awk`
- Sorting text output
- Counting repeated values with `uniq -c`
- Filtering top results with `head`
- Understanding Nginx access log structure
- Building command-line tools for troubleshooting
- Thinking about operational analysis used in support and DevOps environments

## Requirements

This script is intended to run on Linux or macOS.

Recommended tools available on the system:

- `bash`
- `awk`
- `sort`
- `uniq`
- `head`

The script expects an Nginx access log file using a common access log format.

## Current limitations

- The script expects the log file path as the only argument
- It does not currently check if the provided file exists
- It does not currently check if the provided file is readable
- It assumes the Nginx log follows a common access log format
- The terminal output is currently in Portuguese
- The user agent output may be simplified when user agents contain multiple spaces
- It does not support command-line options yet
- It does not export the result to a file
- It does not support JSON, CSV, or HTML output
- It does not analyze logs by time range yet

## Possible improvements

Future improvements:

- Translate the terminal output to English
- Add a `--help` option
- Validate if the log file exists
- Validate if the log file is readable
- Improve user agent formatting to preserve the full user agent string
- Add support for custom Nginx log formats
- Add an option to export results to `.txt`, `.csv`, or `.json`
- Add support for filtering by date or time range
- Add support for showing top HTTP methods, such as `GET`, `POST`, `PUT`, and `DELETE`
- Add support for detecting possible suspicious IP addresses
- Add ShellCheck validation
- Add automated tests
- Create an alternative version using `grep` and `sed`
- Create an alternative version using only `awk`

## Reference

- https://roadmap.sh/projects/nginx-log-analyser