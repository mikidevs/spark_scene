import antigone
import gleam/bit_array
import gleam/dynamic
import gleam/result

pub opaque type Password {
  Password(value: String)
}

pub fn create_password(pass: String) -> Password {
  pass |> hash |> Password
}

pub fn unwrap(pass: Password) {
  pass.value
}

pub fn validate(to_verify: String, hashed_password: Password) -> Bool {
  to_verify
  |> bit_array.from_string
  |> antigone.verify(unwrap(hashed_password))
}

fn hash(str: String) -> String {
  let bits = bit_array.from_string(str)
  antigone.hash(antigone.hasher(), bits)
}

pub fn decoder(dyn: dynamic.Dynamic) -> Result(Password, dynamic.DecodeErrors) {
  use pass <- result.try(dynamic.string(dyn))
  Ok(Password(pass))
}
