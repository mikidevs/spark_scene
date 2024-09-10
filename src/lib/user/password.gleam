import antigone
import gleam/bit_array

pub opaque type Password {
  Password(password: String)
}

pub fn create_password(pass: String) -> Password {
  pass |> hash |> Password
}

pub fn unwrap(pass: Password) {
  pass.password
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
