import gleam/regex

pub type Invalid

pub type Valid

pub type Email(validation) {
  Email(value: String)
}

pub fn from_string(email: String) -> Email(Invalid) {
  Email(email)
}

pub fn unwrap(email: Email(Valid)) {
  email.value
}

/// Validates that an email string has a valid format
pub fn validate_format(
  to_verify to_verify: Email(Invalid),
) -> Result(Email(Valid), String) {
  case is_valid_email_string(to_verify) {
    True -> Ok(Email(to_verify.value))
    False -> Error("Not a valid email string")
  }
}

fn is_valid_email_string(to_verify: Email(Invalid)) -> Bool {
  let assert Ok(reg) =
    regex.from_string(
      "(?:[a-z0-9!#$%&\\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\\'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])",
    )

  regex.check(reg, to_verify.value)
}
