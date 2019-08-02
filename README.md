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