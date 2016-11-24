# Common Latex makefile for building LaTex documents
# Author: Stefan Misik

# Programs used
LATEXMK  = latexmk
PDFLATEX = pdflatex
CP       = cp
MKDIR    = mkdir -p

# Sources
SRC ?=
# Main document is frst in SRC array
MAIN ?= $(word 1,$(SRC))
# Pre-defined tex input directory
INPUT_DIR ?= ../common/texinputs/
# Required files
REQUIRE ?=

# Texmaker Flags
TEMFLAGS = -pdf -bibtex -silent -shell-escape
# Flags to pass pdflatex command
PLFLAGS  = -shell-escape -synctex=-1

# Output - Can not be changed
OUT = $(patsubst %.tex,%.pdf,$(MAIN))

# Garbage files
GARBAGE_SRC_SUFFIXES = .aux .log .fdb_latexmk
GARBAGE_MAIN_SUFFIXES = .bbl .blg .lof .loa .lot .out .toc .synctex.gz   \
    .synctex .synctex\(busy\) .fls .auxlock .nav .snm
CLEANUP = $(REQUIRE)                                                     \
          $(foreach EXT,$(GARBAGE_SRC_SUFFIXES),$(SRC:.tex=$(EXT)))      \
          $(foreach EXT,$(GARBAGE_MAIN_SUFFIXES),$(MAIN:.tex=$(EXT)))

# Tikz temporary folder
TIKZTEMP = ./tikz_tmp

TEMFLAGS += -pdflatex='$(PDFLATEX) $(PLFLAGS) %O %S'

################################################################################


all: $(OUT)

.PHONY: all clean cleanup FORCE

$(OUT): $(SRC) $(REQUIRE)
	$(MKDIR) $(TIKZTEMP)
	$(LATEXMK) $(TEMFLAGS) $(MAIN)

$(REQUIRE): %: $(INPUT_DIR)%
	$(CP) $< $@

clean: FORCE
	$(RM) $(OUT) $(CLEANUP)
	$(RM) -r $(TIKZTEMP)

cleanup: FORCE
	$(RM) $(CLEANUP)
	$(RM) -r $(TIKZTEMP)

FORCE:



