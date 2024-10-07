import antigone
import gleam/bit_array
import gleam/regex

pub opaque type NonValidatedPassword {
  NonValidatedPassword(value: String)
}

pub type ValidatedPassword {
  ValidatedPassword(value: String)
}

pub fn hash(password: String) -> String {
  let bits = bit_array.from_string(password)
  antigone.hash(antigone.hasher(), bits)
}

pub fn from_string(value: String) -> NonValidatedPassword {
  NonValidatedPassword(value)
}

pub fn unwrap(password: ValidatedPassword) -> String {
  password.value
}

pub fn validate_format(
  to_verify to_verify: NonValidatedPassword,
) -> Result(ValidatedPassword, String) {
  case is_valid_password_string(to_verify.value) {
    True -> Ok(ValidatedPassword(to_verify.value))
    False -> Error("Not a valid password string")
  }
}

/// Minumum eight characters, at least one uppercase letter, one lowercase letter, one number, one special character
fn is_valid_password_string(to_verify: String) -> Bool {
  let assert Ok(reg) =
    regex.from_string("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")

  regex.check(reg, to_verify)
}

/// This is used for login so it is assumed that the password already is a valid format, if it is not, it will simply fail on hash validation
pub fn verify_password(
  to_verify: NonValidatedPassword,
  hashed_password: ValidatedPassword,
) -> Result(Nil, String) {
  case
    to_verify.value
    |> bit_array.from_string
    |> antigone.verify(hashed_password.value)
  {
    True -> Ok(Nil)
    False -> Error("Password is incorrect")
  }
}
