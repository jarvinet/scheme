# $@ target
# $* matching stem
# $^ dependencies

all: libplugin.so dlload
	@echo "Remember to set LD_LIBRARY_PATH"
	@echo 'LD_LIBRARY_PATH=`pwd`:$$LD_LIBRARY_PATH ; export LD_LIBRARY_PATH'

dlload: dlload.c main.c
	gcc -rdynamic -ldl -o$@ $^

libplugin.so: plugin.o
	gcc -shared -Wl,-soname,$@.1 -o $@.1.0 $^
	ln -s $@.1.0 $@.1
	ln -s $@.1 $@

plugin.o: plugin.c
	gcc -fPIC -c $^

clean:
	rm -f dlload plugin.o core *~
	rm -f libplugin.so libplugin.so.1 libplugin.so.1.0
