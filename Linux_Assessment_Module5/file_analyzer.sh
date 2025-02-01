#!/bin/bash

ERROR_LOG="errors.log"

search_directory() {
    local dir="$1"
    local keyword="$2"

    if [[ ! -d "$dir" ]]; then
        echo "Error: Directory '$dir' not found!" | tee -a "$ERROR_LOG"
        return
    fi

    for file in "$dir"/*; do
        if [[ -d "$file" ]]; then
            search_directory "$file" "$keyword"  # Recursive call for subdirectories
        elif [[ -f "$file" ]]; then
            if grep -q "$keyword" "$file" 2>> "$ERROR_LOG"; then
                echo "Found '$keyword' in: $file"
            fi
        fi
    done
}

# searching a keyword in a file
search_file() {
    local file="$1"
    local keyword="$2"

    if [[ -f "$file" ]]; then
        if grep -q "$keyword" "$file" 2>> "$ERROR_LOG"; then
            echo "Found '$keyword' in: $file"
        else
            echo "Keyword '$keyword' not found in: $file"
        fi
    else
        echo "Error: File '$file' not found!" | tee -a "$ERROR_LOG"
    fi
}

display_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>   Search for a keyword in a directory (recursive search)
  -k <keyword>     Specify the keyword to search for
  -f <file>        Search for a keyword in a specific file
  --help           Display this help menu

Examples:
  $0 -d Folder -k cook
  $0 -f Folder/f1.txt -k risks
  $0 --help
EOF
}

# Checking arguments
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments provided!" | tee -a "$ERROR_LOG"
    display_help
    exit 1
fi

# command-line arguments using getopts
while getopts ":d:k:f:-:" opt; do
    case "$opt" in
        d) directory="$OPTARG" ;;
        k) keyword="$OPTARG" ;;
        f) file="$OPTARG" ;;
        -) case "$OPTARG" in
               help) display_help; exit 0 ;;
               *) echo "Error: Invalid option '--$OPTARG'" | tee -a "$ERROR_LOG"; exit 1 ;;
           esac ;;
        ?) echo "Error: Invalid option '-$OPTARG'" | tee -a "$ERROR_LOG"; exit 1 ;;
    esac
done

# input validation
if [[ -n "$directory" && -z "$keyword" ]]; then
    echo "Error: Keyword required when using -d option!" | tee -a "$ERROR_LOG"
    exit 1
fi
if [[ -n "$file" && -z "$keyword" ]]; then
    echo "Error: Keyword required when using -f option!" | tee -a "$ERROR_LOG"
    exit 1
fi

# Searching based on input
if [[ -n "$directory" ]]; then
    search_directory "$directory" "$keyword"
elif [[ -n "$file" ]]; then
    search_file "$file" "$keyword"
else
    echo "Error: Missing required arguments!" | tee -a "$ERROR_LOG"
    display_help
    exit 1
fi
