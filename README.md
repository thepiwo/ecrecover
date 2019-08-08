# ecrecover
FFI (NIF) export of Ethereum's ecrecover for use from Erlang.

### prerequisite:
- a checked out copy of my fork of parity-ethereum (https://github.com/johnsnewby/parity-ethereum) checked out in the same directory this is (i.e. it will be referenced as `../parity-ethereum`)

### to compile:
`cargo build`

## Erlang integration

The shared library uses NIF. Use the erlang file `sec/nifecrecover.erl` to use this:

```
c("src/ecrecover").
Decoded = ecrecover:hexstr_to_bin("47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad000000000000000000000000000000000000000000000000000000000000001b650acf9d3f5f0a2c799776a1254355d5f4061762a237396a99a0e0e3fc2bcd6729514a0dacb2e623ac4abd157cb18163ff942280db4d5caad66ddf941ba12e03").
ecrecover:ecrecover(Decoded).
ecrecover:time_taken_to_execute(fun() -> nifecrecover:ecrecover(Decoded) end).
```
