extern crate c_vec;
extern crate ethcore_builtin;
#[macro_use]
extern crate lazy_static;
extern crate libc;
extern crate parity_bytes;
#[macro_use]
extern crate rustler;

use std::ffi::*;
use ethcore_builtin::EcRecover;
use crate::ethcore_builtin::Implementation;
use c_vec::{CVec};
use parity_bytes::BytesRef;
use rustler::*;
use std::ptr::copy_nonoverlapping;

const INPUT_LENGTH: usize = 512;
const OUTPUT_LENGTH: usize = 32;

mod atoms {
    rustler_atoms! {
        atom ok;
    }
}

rustler_export_nifs!(
    "nifecrecover",
    [
        ("ecrecover", 2, nif_ecrecover),
    ],
    Some(on_load)
);

struct EcrecoverResource { }

#[no_mangle]
fn on_load(env: Env, _load_info: Term) -> bool {
    println!("on_load");
    rustler::resource_struct_init!(EcrecoverResource, env);
    true
}

pub fn nif_ecrecover<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let input: String = args[0].decode()?;
    let mut output: String = args[1].decode()?;
    let mut byte_ref = Vec::new();
    let ecrecover = EcRecover { };
    let result = match ecrecover.execute(input.as_bytes(),
                                         &mut BytesRef::Flexible(&mut byte_ref)) {
        Ok(x) => x,
        Err(e) => return Err(rustler::Error::Atom("ecrecover failed")),
    };
    match String::from_utf8(byte_ref) {
        Ok(x) => {
            output.push_str(&x);
            Ok((atoms::ok(), true).encode(env))
        },
        Err(x) => Err(rustler::Error::Atom("Invalid UTF-8")),
    }
}

/**
 * C interface to the ethereum ecrecover implementation. Returns 1 on success,
 * 0 on failure (in which case there are no guarantees as to what is in output.
 *
 * Memory allocated by caller, expected to be an array of bytes, as above-- 512 in,
 * 32 out.
 */
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
