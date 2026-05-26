#!/bin/bash
if [ $# -ne 5 ]; then
    echo "Need 5 parameters."
    exit 1
fi
label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

start=$SECONDS
for i in $(seq $num_reps); do
    duckdb "$db_file" "$query"
    echo "$i time"
done

finish=$SECONDS
total=$(($finish-$start))

avg_time=$(echo "scale=7; $total/$num_reps" | bc)
echo "$label,$avg_time" >> "$csv_file"

# final script call:
#(base) zachloo@169-231-36-100 hw5 % bash 5-3.sh test_label3 1000 "FROM Bird_nests SELECT COUNT(*)" data/database.duckdb bash_output.csv 