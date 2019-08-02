extern crate c_vec;
extern crate ethcore_builtin;
extern crate libc;
extern crate parity_bytes;

use std::ffi::*;
use ethcore_builtin::EcRecover;
use crate::ethcore_builtin::Implementation;
use c_vec::{CVec};
use parity_bytes::BytesRef;
use std::ptr::copy_nonoverlapping;

const INPUT_LENGTH: usize = 512;
const OUTPUT_LENGTH: usize = 32;

#[no_mangle]
pub unsafe extern "C" fn ecrecover(input: *const libc::c_uchar, output: *mut libc::c_uchar) -> i16 {
    let ecrecover = EcRecover { };
    let mut byte_ref = Vec::new();
    ecrecover.execute(unsafe { std::slice::from_raw_parts(input as *const u8, INPUT_LENGTH) },
                      &mut BytesRef::Flexible(&mut byte_ref));
    let mut ptr: &mut[u8] = unsafe { std::slice::from_raw_parts_mut(output as *mut u8, OUTPUT_LENGTH) };
    if byte_ref.len() != OUTPUT_LENGTH {
        return 0;
    }
    ptr.copy_from_slice(byte_ref.as_slice());
    return 1;
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
