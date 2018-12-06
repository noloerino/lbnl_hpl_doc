#!/bin/bash
# for the extremeley lazy, generates a nodelist

case $# in
    [0-2])
        echo "Usage: $0 start end cluster"
        exit 1
        ;;
esac

[ -e nodelist ] && rm nodelist
for i in `seq $1 1 $2`; do
    printf "n%04d.%s\n" $i $3 >> nodelist
done
