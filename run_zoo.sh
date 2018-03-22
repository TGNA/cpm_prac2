#!/bin/bash

make build_parallel

if [ $? -ne 0 ]; then
    echo "Compilation failed ☠️"
    exit 1
fi

if [ "$1" == "gat" ]; then
    if [ ! -f ./output/sequential_gat.txt ]; then
        make build_sequential
        echo "Running sequential..."
        TSEQ=$( { srun -p gat time -f%e ./prac_s > ./output/sequential_gat.txt; } 2>&1 )
        echo "Time: $TSEQ"
    else
        TSEQ=68.6
        echo "Setting default time: $TSEQ..."
    fi
elif [ "$1" == "teen" ]; then
    if [ ! -f ./output/sequential_teen.txt ]; then
        echo "Running sequential..."
        TSEQ=$( { srun -p teen time -f%e ./prac_s > ./output/sequential_teen.txt; } 2>&1 )
        echo "Time: $TSEQ"
    else
        TSEQ=24.8
        echo "Setting default time: $TSEQ..."
    fi
else
    echo "No server matched"
    exit 1
fi

if [ "$1" == "gat" ]; then
    echo "Running parallel..."
    TPAR=$( { srun -p gat time -f%e ./prac_p > ./output/parallel_gat.txt; } 2>&1 )
    echo "Time: $TPAR"
elif [ "$1" == "teen" ]; then
    echo "Running parallel..."
    TPAR=$( { srun -p teen time -f%e ./prac_p > ./output/parallel_teen.txt; } 2>&1 )
    echo "Time: $TPAR"
fi

if [ "$1" == "gat" ]; then
    diff ./output/sequential_gat.txt ./output/parallel_gat.txt > /dev/null
elif [ "$1" == "teen" ]; then
    diff ./output/sequential_teen.txt ./output/parallel_teen.txt > /dev/null
fi

if [ $? -eq 0 ]; then
    echo "OK 👍"
else
    echo "FAIL ☠️"
fi

echo -n "Speedup: "
echo "$TSEQ / $TPAR" | bc -l
