word1 := "bath room door"
word2 := "blood stained gate"

voices := mb-us1 mb-us2 mb-us3
pitch_levels := 0 50 99
audio_files := $(foreach voice,$(voices),$(foreach pitch,$(pitch_levels),audio/raw/$(voice)-$(pitch).wav))
audio_files_pat := $(subst .,%,$(audio_files))

.PHONY: all audio clean
.INTERMEDIATE: $(audio_files)

all: audio

audio: phonemes.txt $(subst raw/,,$(audio_files))

phonemes.txt: gen_utterances.hs
	./gen_utterances.hs $(word1) $(word2) > $@

$(audio_files_pat): speak.sh phonemes.txt
	mkdir -p audio/raw
	bash speak.sh mb-us1 mb-us2 mb-us3


audio/%.wav: audio/raw/%.wav
	sox $^ $@ gain -1 rate 44100

clean:
	rm phonemes.txt
	rm -rf audio
