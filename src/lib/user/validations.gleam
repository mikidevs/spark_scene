//// Functions for auth validations

import antigone
import gleam/bit_array
import gleam/order
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
