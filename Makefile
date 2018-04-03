NAME=hasktags
ROOT=result/bin/$(NAME).jsexe
# Note: nodejs-externs is from https://github.com/dcodeIO/node.js-closure-compiler-externs.git
# You can `git clone https://github.com/dcodeIO/node.js-closure-compiler-externs.git nodejs-externs`
EXTERNS=$(shell find nodejs-externs/ -maxdepth 1 -name '*.js' | sed 's/^/--externs=/')

all: npm/$(NAME).js

$(ROOT)/all.js: src $(NAME).cabal default.nix
	nix build

npm/$(NAME).js: $(ROOT)/all.js $(ROOT)/all.js.externs
	closure-compiler $(ROOT)/all.js --compilation_level=ADVANCED_OPTIMIZATIONS $(EXTERNS) --externs=$(ROOT)/all.js.externs > npm/$(NAME).js

.PHONY: clean
clean:
	rm result
	rm $(NAME).js
