#!/bin/bash

search_dir=./data
for f in "$search_dir"/*
do
  BASEFSIZE=$(stat --printf="%s\n" ${f})
  echo $BASEFSIZE >> ${f}_size.txt
  for i in {0..9}
  do
    /bin/time -a -o ${f}_time.txt -f %E zip -${i} ${f}_${i}.zip ${f}
    FSIZE=$(stat --printf="%s\n" ${f}_${i}.zip)
    echo $FSIZE >> ${f}_size.txt
    echo "scale=8; $FSIZE / $BASEFSIZE" | bc >> ${f}_cr.txt
    rm ${f}_${i}.zip 
  done
done
