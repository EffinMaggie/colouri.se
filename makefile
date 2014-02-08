root:=http://colouri.se/
name:=Magnus Achim Deininger

# programmes
ZIP:=zip
SQLITE3:=sqlite3

# data files
DATABASES:=colourise.sqlite3

# don't delete intermediary files
.SECONDARY:

# meta rules
all: $(DATABASES) colourise
run: run-colourise
clean:
	rm -f $(DATABASES) colourise; true
scrub: clean

# pattern rules for databases
%.sqlite3: src/%.sql
	rm -f $@ && $(SQLITE3) $@ < $<

# specific rule to build the colourise daemon
%: src/%.cpp include/ef.gy/*.h
	clang++ -std=c++0x -Iinclude/ -O2 $< -stdlib=libc++ -lboost_system -lboost_filesystem -lboost_iostreams -o $@ && strip -x $@

# specific rule to run the colourise daemon
run-colourise: colourise
	killall colourise; rm -f /var/tmp/colourise.socket && (nohup ./colourise /var/tmp/colourise.socket &) && sleep 1 && chmod a+w /var/tmp/colourise.socket
