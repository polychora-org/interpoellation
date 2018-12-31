#!/usr/bin/env bash

SPEED=80

for v in $@; do
    espeak -v $v -s $SPEED -p 0 -l 1000 -w audio/raw/$v-0.wav -f phonemes.txt &
    espeak -v $v -s $SPEED -p 50 -l 1000 -w audio/raw/$v-50.wav -f phonemes.txt &
    espeak -v $v -s $SPEED -p 99 -l 1000 -w audio/raw/$v-99.wav -f phonemes.txt &
done

# espeak -v m1 -s 100 -p 100 < phonemes.txt &
# espeak -v f1 -s 100 -p 0 < phonemes.txt &
# espeak -v whisper -s 100 -p 50 < phonemes.txt &
# espeak -v croak -s 100 -p 50 < phonemes.txt &
# espeak -v mb-sw1-en -s $SPEED < phonemes.txt &
# espeak -v mb-sw2-en -s $SPEED < phonemes.txt &
# espeak -v mb-gr2-en -s 110 < phonemes.txt &
# espeak -v mb-de4-en -s $SPEED < phonemes.txt &
# espeak -v mb-de5-en -s $SPEED < phonemes.txt &
