OUTDIR = bin
SRCDIR = src
OUTFILE = output

MKDIR = mkdir
RM = rm -rf
VCS = vcs
VCS_FLAGS = -lca -t ps -sverilog -debug_all -timescale=1ns/100ps +lint=PCWM

SOURCES = $(wildcard $(SRCDIR)/*.sv)

all: compile

clean:
	$(RM) $(OUTDIR)

setup:
	$(MKDIR) -p $(OUTDIR)

compile: setup
	$(VCS) $(SOURCES) $(VCS_FLAGS) -o ${OUTDIR}/$(OUTFILE)

run:
	export DISPLAY=gmslctl04:2.0
	${OUTDIR}/$(OUTFILE) -gui
