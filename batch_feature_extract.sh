#!/usr/bin/env bash

windows=( 40 80 100 120 )
NWs=(1.5)
NFFT=256
channels=":"
datafile='data/sub1_comp'
overlap=(0 0.5 0.75)

for windowlen in "${windows[@]}"; do
    echo "Window Length=$windowlen"
    for NW in "${NWs[@]}"; do
        echo "NW=$NW"
        for overlap in "${overlap[@]}"; do
            matlab -nodisplay -nosplash -r "fx_gen('$datafile', $windowlen, $NW, 1000, $overlap, $NFFT, $channels);quit" &
        done
        # Wait on children so as not to overload the machine
        wait
    done
done
