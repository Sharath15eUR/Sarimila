# Linux Assignment Module 3


This assignment involves creating a shell script, `backup_manager.sh`, that automates the backup of files based on a specific file extension from a source directory to a backup directory. 

## Steps and Explanation for Each Question

### **1. Validate Input Arguments**

   The first step was ensuring that the script accepts three arguments: the source directory, the backup directory, and the file extension. If any of these are missing, the script prints a usage message and exits gracefully.

### **2. Check for Source Directory**

   The script checks if the source directory exists. If it doesn't, an error message is displayed, and the script stops. This prevents any further actions from being carried out on a non-existent directory.

### **3. Create Backup Directory if It Doesn't Exist**

   If the backup directory doesn't already exist, the script automatically creates it. If for any reason the directory creation fails, an error message is displayed, and the script exits.

### **4. Find and Back Up Matching Files**

   The script then uses file globbing to find all files in the source directory that match the given file extension. It handles cases where no files are found, gracefully exiting without errors.
   
   For each matching file:
   - It calculates the file size and adds it to a running total.
   - The file is then copied to the backup directory.
   
   During this process, the script keeps track of how many files were processed and the total size of all files backed up.

### **5. Handle Overwriting of Files in Backup Directory**

   The script checks if a file with the same name already exists in the backup directory:
   - If the source file is newer than the backup file, it gets copied over.
   - If the source file is older or the same, the script skips the backup for that file.

### **6. Generate a Backup Report**

   After completing the backup process, the script generates a `backup_report.log` file in the backup directory. The report includes:
   - The total number of files processed
   - The total size of the files backed up
   - The backup directory path

