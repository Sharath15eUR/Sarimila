#!/bin/bash

source_dir="$1"
backup_dir="$2"
file_extension="$3"

# Validate arguments
if [ -z "$source_dir" ] || [ -z "$backup_dir" ] || [ -z "$file_extension" ]; then
    echo "Usage: $0 <source_directory> <backup_directory> <file_extension>"
    exit 1F
fi

# verify if source directory exists
if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory does not exist!"
    exit 1
fi

# if backup directory not exist create one
if [ ! -d "$backup_dir" ]; then
    echo "Backup directory doesn't exist. let's create one..."
    mkdir -p "$backup_dir" || { echo "Failed to create backup directory. Exiting..."; exit 1; }
fi

# Globbing: Finding files that matches File extension
matching_files=("$source_dir"/*"$file_extension")

# Check if files matching the pattern exist
if [ ${#matching_files[@]} -eq 0 ]; then
    echo "No files matching the pattern '$file_extension' found in $source_dir"
    exit 0
fi

# variables for report
total_files=0
total_size=0

# Print the list of matched files and perform backup
echo "Backing up files from $source_dir to $backup_dir"
for file in "${matching_files[@]}"; do
    if [ -f "$file" ]; then
        # Get file size in bytes
        file_size=$(stat --format="%s" "$file")
        total_size=$((total_size + file_size))

        # Backup file
        cp "$file" "$backup_dir" && echo "Backing up $file"
        ((total_files++))
    fi
done

# Generate the backup report
echo "Backup completed!" > "$backup_dir/backup_report.log"
echo "Total files processed: $total_files" >> "$backup_dir/backup_report.log"
echo "Total size of files backed up: $total_size bytes" >> "$backup_dir/backup_report.log"
echo "Backup directory: $backup_dir" >> "$backup_dir/backup_report.log"

# for report location
echo "Report saved as backup_report.log in $backup_dir"

