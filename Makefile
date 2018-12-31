audio_files := $(wildcard audio/raw/*.wav)

.PHONY: all audio

all: audio

audio: $(subst raw/,,$(audio_files))

speak: speak.sh
	mkdir -p audio/raw
	bash speak.sh mb-us1 mb-us2 mb-us3

audio/%.wav: audio/raw/%.wav
	sox $^ $@ gain -1 rate 44100
