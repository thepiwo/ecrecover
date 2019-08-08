extern crate c_vec;
extern crate ethcore_builtin;
#[macro_use]
extern crate lazy_static;
extern crate libc;
extern crate parity_bytes;
#[macro_use]
extern crate rustler;

use ethcore_builtin::EcRecover;
use crate::ethcore_builtin::Implementation;
use parity_bytes::BytesRef;
use rustler::*;

mod atoms {
    rustler_atoms! {
        atom ok;
    }
}

rustler_export_nifs!(
    "ecrecover",
    [
        ("ecrecover", 1, nif_ecrecover),
    ],
    Some(on_load)
);


#[no_mangle]
fn on_load(_env: Env, _load_info: Term) -> bool {
    true
}

pub fn nif_ecrecover<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let input: Binary = args[0].decode()?;
    let mut byte_ref = Vec::new();
    let ecrecover = EcRecover { };
    let _result = match ecrecover.execute(input.as_slice(),
                                          &mut BytesRef::Flexible(&mut byte_ref)) {
        Ok(_) => (),
        Err(_e) => return Err(rustler::Error::Atom("ecrecover failed")),
    };
    Ok((atoms::ok(), byte_ref.as_slice()).encode(env))
}
