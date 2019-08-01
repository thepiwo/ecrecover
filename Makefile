
CC = gcc
LIBS = -llibecrecover.so
LDPATH = -Ltarget/debug

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $<



test: src/test.c include/ecrecover.h target/debug/libecrecover.so
	$(CC) -o $@ $^ $(CFLAGS) $(LDPATH)
