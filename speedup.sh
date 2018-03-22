#!/bin/bash

make clean

make build

if [ $? -ne 0 ]; then
    echo "Compilation failed ☠️"
    exit 1
fi

ITER=$1
# TSEQ=$2
TSEQ=68.6

ACCUMULATED=0

for i in $(seq 1 "$ITER") 
do
  echo "Iteration $i..."
  TIME=$( { srun -p gat time -f%e ./prac_p > /dev/null; } 2>&1 )
  echo "Time: $TIME"

  SPEEDUP=$(echo "$TSEQ / $TIME" | bc -l)
  echo "Speedup: $SPEEDUP"

  ACCUMULATED=$(echo "$ACCUMULATED + $SPEEDUP" | bc -l)
  echo
done

echo "========================="
AVERAGE=$(echo "$ACCUMULATED / $ITER" | bc -l)
echo "Speedup average: $AVERAGE"

