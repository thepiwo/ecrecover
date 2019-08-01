# ecrecover
FFI export of Ethereum's ecrecover

prerequisite:
- a checked out copy of parity-ethereum (https://github.com/paritytech/parity-ethereum) checked out in the same directory this is (i.e. it will be referenced as `../parity-ethereum`)

to compile:
`cargo build`

to test:
`make` (requires gcc)
./test

(if you don't see `Test passed` then something went wrong).