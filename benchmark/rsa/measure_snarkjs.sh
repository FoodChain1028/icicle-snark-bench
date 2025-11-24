#!/bin/bash

# Script to measure snarkjs proof generation time
# Usage: ./measure_snarkjs.sh [iterations]

set -e

# Default values
ITERATIONS=${1:-5}
ZKEY_FILE="circuit_final.zkey"
WITNESS_FILE="witness.wtns"
PROOF_FILE="proof.json"
PUBLIC_FILE="public.json"

echo "=== SnarkJS Proof Generation Performance Test ==="
echo "Circuit: RSA verification"
echo "Iterations: $ITERATIONS"
echo "Files: $ZKEY_FILE, $WITNESS_FILE"
echo ""

# Check if required files exist
if [ ! -f "$ZKEY_FILE" ]; then
    echo "Error: $ZKEY_FILE not found!"
    exit 1
fi

if [ ! -f "$WITNESS_FILE" ]; then
    echo "Error: $WITNESS_FILE not found!"
    exit 1
fi

# Check if snarkjs is available
if ! command -v snarkjs &> /dev/null; then
    echo "Error: snarkjs not found! Please install with: npm install -g snarkjs"
    exit 1
fi

echo "Starting $ITERATIONS proof generation runs..."
echo ""

times=()
total_time=0

for i in $(seq 1 $ITERATIONS); do
    echo -n "Run $i/$ITERATIONS: "

    # Time the proof generation (capture both stdout and stderr)
    start_time=$(date +%s.%3N)
    snarkjs groth16 prove "$ZKEY_FILE" "$WITNESS_FILE" "$PROOF_FILE.tmp" "$PUBLIC_FILE.tmp" >/dev/null 2>&1
    end_time=$(date +%s.%3N)

    # Calculate duration
    duration=$(echo "$end_time - $start_time" | bc)
    times+=($duration)
    total_time=$(echo "$total_time + $duration" | bc)

    printf "%.3f seconds\n" $duration

    # Clean up temporary files
    rm -f "$PROOF_FILE.tmp" "$PUBLIC_FILE.tmp"
done

echo ""
echo "=== Results ==="

# Calculate statistics
avg_time=$(echo "scale=3; $total_time / $ITERATIONS" | bc)

# Find min and max
min_time=${times[0]}
max_time=${times[0]}

for time in "${times[@]}"; do
    if (( $(echo "$time < $min_time" | bc -l) )); then
        min_time=$time
    fi
    if (( $(echo "$time > $max_time" | bc -l) )); then
        max_time=$time
    fi
done

echo "Average time: $avg_time seconds"
echo "Min time: $min_time seconds"
echo "Max time: $max_time seconds"

# Calculate standard deviation if we have enough samples
if [ $ITERATIONS -gt 1 ]; then
    sum_sq=0
    for time in "${times[@]}"; do
        diff=$(echo "$time - $avg_time" | bc)
        sq=$(echo "$diff * $diff" | bc)
        sum_sq=$(echo "$sum_sq + $sq" | bc)
    done
    variance=$(echo "scale=6; $sum_sq / ($ITERATIONS - 1)" | bc)
    stddev=$(echo "scale=3; sqrt($variance)" | bc)
    echo "Std deviation: $stddev seconds"
fi

echo ""
echo "Note: First run may be slower due to initialization overhead."
echo "For best results, run on a warmed-up system."
