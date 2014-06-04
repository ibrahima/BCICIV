#!/usr/bin/env bash

windows=( 40 80 100 120 200 )
NWs=(1.5 2 2.5 3 3.5 4 5 6)
NFFT=256
channels=":"
datafile='data/sub1_comp'
overlaps=(0 0.5 0.75)
corecount=4;

for windowlen in "${windows[@]}"; do
    echo "Window Length=$windowlen"
    for overlap in "${overlaps[@]}"; do
        echo "overlap = $overlap"
        c=0
        for NW in "${NWs[@]}"; do
            (( c+= 1))
            matlab -nojvm -nodisplay -nosplash -r "fx_gen('$datafile', $windowlen, $NW, 1000, $overlap, $NFFT, $channels);quit" &
            if ! (( c % corecount)); then
                # Wait on children so as not to overload the machine
                wait
            fi
        done
    done

done
