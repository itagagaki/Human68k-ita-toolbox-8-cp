# Makefile for ITA TOOLBOX #8 cp

AS	= HAS.X -i $(INCLUDE)
LK	= hlk.x -x
CV      = -CV.X -r
CP      = cp
RM      = -rm -f

INCLUDE = $(HOME)/fish/include

DESTDIR   = A:/usr/ita
BACKUPDIR = B:/cp/1.5
RELEASE_ARCHIVE = CP15
RELEASE_FILES = MANIFEST README ../NOTICE ../DIRECTORY ../HUPAIR CHANGES cp.1 cp.x

EXTLIB = ../lib/getlnenv.o $(HOME)/fish/lib/ita.l

###

PROGRAM = cp.x

###

.PHONY: all clean clobber install release backup

.TERMINAL: *.h *.s

%.r : %.x	; $(CV) $<
%.x : %.o	; $(LK) $< $(EXTLIB)
%.o : %.s	; $(AS) $<

###

all:: $(PROGRAM)

clean::

clobber:: clean
	$(RM) *.bak *.$$* *.o *.x

###

$(PROGRAM) : $(INCLUDE)/doscall.h $(INCLUDE)/chrcode.h $(EXTLIB)

include ../Makefile.sub

###
