SOURCES = my.ml prop.ml sat_ifexpr.ml marina.ml main.ml
EXEC = marina

CAMLC = ocamlfind ocamlc
PACKAGES = -package cohttp-lwt-unix,lwt.unix,str
CUSTOM = -custom

all: depend $(EXEC)

OBJS = $(SOURCES:.ml=.cmo)

$(EXEC): $(OBJS)
	$(CAMLC) $(CUSTOM) -o $(EXEC) $(PACKAGES) -linkpkg $(OBJS)

.SUFFIXES: .ml .mli .cmo .cmi

%.cmo: %.ml
	$(CAMLC) -c $(PACKAGES) $<

%.cmi: %.mli
	$(CAMLC) -c $(PACKAGES) $<

doc: all
	mkdir -p doc
	rm -rf doc/*
	$(CAMLDOC) -d doc/ -html *.mli

clean:
	rm -f *.cm[io] *~ .*~ #*#
	rm -f $(EXEC)
	rm -rf doc
	rm .depend

test:
	ocamlfind ocamlc -package ounit2 -linkpkg -o test str.cma my.ml prop.ml sat_ifexpr.ml marina.ml test.ml
	./test

depend: $(SOURCES)
	$(CAMLDEP) my.mli prop.mli sat_ifexpr.mli marina.mli my.ml prop.ml sat_ifexpr.ml marina.ml main.ml > .depend

depend: $(SOURCES)
	$(CAMLDEP) my.mli prop.mli sat_ifexpr.mli marina.mli my.ml prop.ml sat_ifexpr.ml marina.ml main.ml > .depend

include .depend