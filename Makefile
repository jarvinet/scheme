SRCDIRS = core support src

SUBDIRS = core support src lib test

regsim:
	for d in $(SRCDIRS); do (cd $$d; make all); done

makercslinks:
	for d in $(SUBDIRS); do (cd $$d; make $@); done

rmrcslinks:
	for d in $(SUBDIRS); do (cd $$d; make $@); done

clean:
	for d in $(SUBDIRS); do (cd $$d; make $@); done
	rm -f *~

backup: clean
	(cd ..; tar cvfz scheme.tgz Scheme)
