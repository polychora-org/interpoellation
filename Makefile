audio_files := $(wildcard audio/raw/*.wav)

.PHONY: all audio

all: audio

audio: $(subst raw/,,$(audio_files))

audio/%.wav: audio/raw/%.wav
	sox $^ $@ gain -1 rate 44100
