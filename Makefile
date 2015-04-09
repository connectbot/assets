GIMP=/Applications/Gimp.app/Contents/MacOS/gimp-2.8

SRCS=$(wildcard text/*.txt)
OUTPUT=$(SRCS:text/%.txt=output/%.png)

output/%.png: text/%.txt assets/connectbot-promo.xcf src/create-play-promo.scm
	echo '(localize-subheading "$(shell cat $<)" "Essential PragmataPro" "assets/connectbot-promo.xcf" "$@") (gimp-quit 0)' | cat src/create-play-promo.scm - | $(GIMP) -n -i -b -

all: $(OUTPUT)
