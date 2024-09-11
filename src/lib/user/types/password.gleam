import antigone
import gleam/bit_array

pub type PasswordHash {
  PasswordHash(value: String)
}

pub fn hash(password: String) -> String {
  let bits = bit_array.from_string(password)
  antigone.hash(antigone.hasher(), bits)
}
