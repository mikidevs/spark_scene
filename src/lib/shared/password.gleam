import antigone
import gleam/bit_array
import gleam/regex

pub fn hash(password: String) -> String {
  let bits = bit_array.from_string(password)
  antigone.hash(antigone.hasher(), bits)
}

/// Minumum eight characters, at least one uppercase letter, one lowercase letter, one number, one special character
pub fn must_be_valid(pass: String) -> Result(String, String) {
  let assert Ok(reg) =
    regex.from_string("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")

  case regex.check(reg, pass) {
    True -> Ok(pass)
    False -> Error("Not a valid password string")
  }
}

/// This is used for login so it is assumed that the password already is a valid format, if it is not, it will simply fail on hash validation
pub fn verify_password(
  to_verify: String,
  hashed_password: String,
) -> Result(Nil, String) {
  case
    to_verify
    |> bit_array.from_string
    |> antigone.verify(hashed_password)
  {
    True -> Ok(Nil)
    False -> Error("Password is incorrect")
  }
}
