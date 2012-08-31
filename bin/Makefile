SUBDIRS = interpreter test

clean:
	rm -f $(CLEANFILES)
	for d in $(SUBDIRS); do (cd $$d; make $@); done

makercslinks:
	ln -s ../RCS/bin RCS
	for d in $(SUBDIRS); do (cd $$d; make $@); done

rmrcslinks:
	rm -f RCS
	for d in $(SUBDIRS); do (cd $$d; make $@); done
