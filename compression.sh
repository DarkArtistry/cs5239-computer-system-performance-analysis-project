#!/usr/bin/env bash

echo ",0_compression_rate,0_compression_time,1_compression_rate,1_compression_time,2_compression_rate,2_compression_time,3_compression_rate,3_compression_time,4_compression_rate,4_compression_time,5_compression_rate,5_compression_time,6_compression_rate,6_compression_time,7_compression_rate,7_compression_time,8_compression_rate,8_compression_time,9_compression_rate,9_compression_time" > compression.csv
for var in "$@"
do
    # echo "$var,0,1,2,3,4,5,6,7,8,9" >>compression.csv
    Record="$var,"
    for i in 0 1 2 3 4 5 6 7 8 9
        do
            START="$(date +%s%N)"
            Rate="$(zip -$i -v $var.zip $var | echo $(awk '{if (match($5, "%")) rate=$5; gsub("%", "", rate); print rate;}'))"
            Record+="$Rate,"
            Duration=$[ $(date +%s%N) - ${START}]
            if [ $i == 9 ];
            then
                # zip -$i -v $var.zip $var
                Record+="$Duration"
            else
                Record+="$Duration,"
            fi
        done

    echo $Record >>compression.csv
done