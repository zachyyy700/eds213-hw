#!/bin/bash
# create empty csv with columns first: echo "label,avg_time,num_reps" >> sql_methods.csv
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
    duckdb "$db_file" "$query" > /dev/null
done

finish=$SECONDS
total=$(($finish-$start))

avg_time=$(echo "scale=7; $total/$num_reps" | bc)
echo "$label,$avg_time,$num_reps" >> $csv_file

# The fastest method seems to be the third, the method using except. Seen in the second run of the except trials, tt's fastest time avg_time was 0.01 per iteration over a total of 100 iterations. It's kind of difficult to say since each method scores rather similar in time per iteration. Additionally, perhaps if we were to measure time to more levels of granularity, we could see a clearer difference.