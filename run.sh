#!/bin/bash

make clean

make build

if [ $? -ne 0 ]; then
    echo "Compilation failed ☠️"
    exit 1
fi

echo "Running sequential..."
TSEQ=$( { time -f%e ./prac_s > ./output/sequential.txt; } 2>&1 )
echo "Time: $TSEQ"

echo "Running parallel..."
TPAR=$( { time -f%e ./prac_p > ./output/parallel.txt; } 2>&1 )
echo "Time: $TPAR"

diff ./output/sequential.txt ./output/parallel.txt > /dev/null

if [ $? -eq 0 ]; then
    echo "OK 👍"
else
    echo "FAIL ☠️"
fi

echo -n "Speedup: "
echo "$TSEQ / $TPAR" | bc -l
