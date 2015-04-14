PLATFORM ?= $(shell uname)

ifeq ($(PLATFORM),Linux)
    GIMP ?= $(shell which gimp)
endif
ifeq ($(PLATFORM),Darwin)
    GIMP ?= $(wildcard /Applications/Gimp.app/Contents/MacOS/gimp-*)
endif

ifeq ($(wildcard $(GIMP)),)
    $(error Gimp must be installed. Set GIMP variable to executable path.)
endif

ASSETS := $(wildcard assets/*.png)
SRCS := $(wildcard text/*.txt)
OUTPUT := $(SRCS:text/%.txt=output/%.png)

output/%.png: text/%.txt src/create-play-promo.scm $(ASSETS)
	echo '(localize-subheading "$(shell cat $<)" "Essential PragmataPro" "$@") (gimp-quit 0)' | cat src/create-play-promo.scm - | $(GIMP) -n -i -b -

all: $(OUTPUT)
