//// Functions for auth validations

import antigone
import gleam/bit_array
import gleam/bool
import gleam/order
import gleam/regex
import gleam/string
import lib/auth/model/login_user.{type LoginUser}
import lib/auth/model/validation_user.{type ValidationUser}
import lib/user/model/email.{type Email}

pub fn validate_login_user(
  to_verify: LoginUser,
  against: ValidationUser,
) -> Result(Nil, String) {
  let login_user.LoginUser(email, pass) = to_verify
  let validation_user.ValidationUser(_, _, valid_email, valid_password) =
    against

  use email <- result.try(email.validate_format(email))
  use password <- result.try(password.validate_format(pass))

  Ok(Nil)
}
