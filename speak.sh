#!/usr/bin/env bash

SPEED=80

for v in $@; do
    espeak -v $v -s $SPEED -p 0 -l 1000 -w audio/raw/$v-0.wav -f phonemes.txt &
    espeak -v $v -s $SPEED -p 50 -l 1000 -w audio/raw/$v-50.wav -f phonemes.txt &
    espeak -v $v -s $SPEED -p 99 -l 1000 -w audio/raw/$v-99.wav -f phonemes.txt &
done

wait
