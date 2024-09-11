//// Functions for auth validations

import antigone
import gleam/bit_array
import gleam/order
import gleam/regex
import gleam/result
import gleam/string
import lib/user/types/login_user.{type LoginUser}

pub fn validate_password(
  to_verify: String,
  hashed_password: String,
) -> Result(Nil, String) {
  let is_valid =
    to_verify
    |> bit_array.from_string
    |> antigone.verify(hashed_password)

  case is_valid {
    True -> Ok(Nil)
    False -> Error("Password is incorrect")
  }
}

pub fn is_valid_email_string(to_verify: String) {
  let assert Ok(reg) =
    regex.from_string(
      "(?:[a-z0-9!#$%&\\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\\'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])",
    )

  regex.check(reg, to_verify)
}

pub fn validate_email(to_verify: String, email: String) -> Result(Nil, String) {
  case string.compare(to_verify, email) {
    order.Eq -> Ok(Nil)
    _ -> Error("Email is incorrect")
  }
}

pub fn validate_login_user(
  to_verify: LoginUser,
  against: LoginUser,
) -> Result(Nil, String) {
  let login_user.LoginUser(valid_email, valid_password) = against
  let login_user.LoginUser(email, pass) = to_verify

  [validate_email(email, valid_email), validate_password(pass, valid_password)]
  |> result.all
  |> result.map(fn(_) { Nil })
}
