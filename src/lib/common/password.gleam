pub type Password {
  NonValidatedPassword(value: String)
  ValidatedPassword(value: String)
}

pub fn validate_password(
  to_verify to_verify: NonValidatedPassword,
  hashed_password hashed_password: String,
) -> Result(ValidatedPassword, String) {
  case is_valid_password_string(to_verify.value) {
    True -> {
      to_verify.value
      |> bit_array.from_string
      |> antigone.verify(hashed_password)
      |> Ok
    }
    False -> Error("Password is not valid")
  }
}

/// Minumum eight characters, at least one uppercase letter, one lowercase letter, one number, one special character
fn is_valid_password_string(to_verify: String) -> Bool {
  let assert Ok(reg) =
    regex.from_string("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")

  regex.check(reg, to_verify)
}
