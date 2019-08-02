# ecrecover
FFI export of Ethereum's ecrecover, with Erlang integration.

prerequisite:
- a checked out copy of my fork of parity-ethereum (https://github.com/johnsnewby/parity-ethereum) checked out in the same directory this is (i.e. it will be referenced as `../parity-ethereum`)

to compile:
`cargo build`
`make` (automatically runs tests).

to test:
`make test` (requires gcc)

(if you don't see `Test passed` then something went wrong).

## Erlang integration

The binary `erl_ecrecover` works with Erlang Ports to provice ecrecover to an Erlang process. The file `src/ecrecover.erl` has the necessary Erlang code. Run it like this:

```
Eshell V9.3  (abort with ^G)
1> c("src/ecrecover").
{ok,ecrecover}
2> ecrecover:start("./erl_ecrecover").
<0.68.0>
3> ecrecover:ecrecover("47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad000000000000000000000000000000000000000000000000000000000000001b650acf9d3f5f0a2c799776a1254355d5f4061762a237396a99a0e0e3fc2bcd6729514a0dacb2e623ac4abd157cb18163ff942280db4d5caad66ddf941ba12e03").
"000000000000000000000000c08b5542d177ac6686946920409741463a15dddb"
```

You may test if from the command line using the file `data/data/erl_ecrecover.input.bin`, a failing test is in `data/erl_ecrecover.input-fail.bin`:

```
$ cat data/erl_ecrecover.input.bin | ./erl_ecrecover
@000000000000000000000000c08b5542d177ac6686946920409741463a15dddb$
```
