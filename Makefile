UNAME := $(shell uname)

ifeq ($(OS),Windows_NT)
	nif_lib_src = ecrecover.dll
	nif_lib = ecrecover.dll
else
ifeq ($(UNAME), Linux)
	nif_lib_src = libecrecover.so
	nif_lib = ecrecover.so
endif
ifeq ($(UNAME), Darwin)
	nif_lib_src = libecrecover.dylib
	nif_lib = ecrecover.so
endif
endif

all: priv/$(nif_lib) compile

compile:
	./rebar3 compile

priv/$(nif_lib): src/lib.rs
ifneq ($(ECRECOVER_DISABLE_NIF_BUILD), true)
	cargo build --release
	cp target/release/$(nif_lib_src) $@
endif

clean:
	rm -f priv/$(nif_lib) target/release/$(nif_lib_src)
	./rebar3 clean
