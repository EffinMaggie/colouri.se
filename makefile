root:=http://colouri.se/
name:=Magnus Achim Deininger

# programmes
ZIP:=zip
SQLITE3:=sqlite3

# data files
DATABASES:=

# don't delete intermediary files
.SECONDARY:

# meta rules
all: colourise
run: run-colourise
clean:
	rm -f $(DATABASES) colourise; true
scrub: clean

databases: $(DATABASES) colourise

# pattern rules for databases
%.sqlite3: src/%.sql
	rm -f $@ && $(SQLITE3) $@ < $<

# specific rule to build the colourise daemon
colourise: src/colourise.cpp include/ef.gy/http.h
	clang++ -Iinclude/ -O2 src/colourise.cpp -lboost_system -lboost_regex -lboost_filesystem -lboost_iostreams -o colourise && strip -x colourise

# specific rule to run the colourise daemon
run-colourise: colourise
	killall colourise; rm -f /var/tmp/colourise.socket && (nohup ./colourise /var/tmp/colourise.socket &) && sleep 1 && chmod a+w /var/tmp/colourise.socket
