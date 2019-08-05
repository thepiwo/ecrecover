DEBUG ?= 0
ifeq ($(DEBUG), 1)
    CFLAGS =-DDEBUG=1
else
    CFLAGS=-DNDEBUG -Ofast
endif

CC = gcc
LIBS = -llibecrecover.so
LDPATH = -Ltarget/debug
INCLUDEPATH = -Iinclude

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $(INCLUDEPATH) $@ $<

all: test erl_ecrecover

test: src/test.c src/base64.c target/release/libecrecover.so
	$(CC) -o $@ $^ $(INCLUDEPATH) $(CFLAGS) $(LDPATH)
	./test

erl_ecrecover: src/erl_ecrecover.c src/base64.c src/erl_comm.c target/debug/libecrecover.so
	$(CC) -o$ $@ $^ $(INCLUDEPATH) $(CFLAGS) $(LDPATH)

clean:
	rm -f erl_ecrecover test
