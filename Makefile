GIMP=/Applications/Gimp.app/Contents/MacOS/gimp-2.8

ASSETS=$(wildcard assets/*.png)
SRCS=$(wildcard text/*.txt)
OUTPUT=$(SRCS:text/%.txt=output/%.png)

output/%.png: text/%.txt src/create-play-promo.scm $(ASSETS)
	echo '(localize-subheading "$(shell cat $<)" "Essential PragmataPro" "$@") (gimp-quit 0)' | cat src/create-play-promo.scm - | $(GIMP) -n -i -b -

all: $(OUTPUT)
