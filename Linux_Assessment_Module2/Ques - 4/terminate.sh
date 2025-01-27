#!/bin/bash

pid=$(ps -eo pid,pmem --sort=-pmem | awk 'NR==2 {print $1}')

process=$(ps -p "$pid" -o comm=)

if [ -n "$pid" ]; then
    echo "Process with the highest memory usage: PID $pid ($process)"
    read -p "Terminate this process? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        kill -9 "$pid"
        echo "Process $pid ($process) terminated."
    else
        echo "Termination canceled."
    fi
else
    echo "No process found."
fi
