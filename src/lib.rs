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

const LENGTH: usize = 32;
#[repr(C)]
struct Buffer {
    data: *mut [u8;LENGTH],
}


#[no_mangle]
pub unsafe extern "C" fn ecrecover(input: *const libc::c_uchar, output: *mut libc::c_uchar) {
    let ecrecover = EcRecover { };
    let mut byte_ref = Vec::new();
    ecrecover.execute(unsafe { std::slice::from_raw_parts(input as *const u8, LENGTH) },
                      &mut BytesRef::Flexible(&mut byte_ref));
    let mut ptr: &mut[u8] = unsafe { std::slice::from_raw_parts_mut(output as *mut u8, LENGTH) };
    ptr.copy_from_slice(byte_ref.as_slice());
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
