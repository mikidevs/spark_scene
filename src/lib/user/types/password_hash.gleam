// import antigone
// import gleam/bit_array

// pub fn create_password(pass: String) -> Password {
//   pass |> hash |> Password
// }

// pub fn unwrap(pass: Password) {
//   pass.value
// }

// fn hash(str: String) -> String {
//   let bits = bit_array.from_string(str)
//   antigone.hash(antigone.hasher(), bits)
// }

pub type PasswordHash {
  PasswordHash(value: String)
}
