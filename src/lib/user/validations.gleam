//// Functions for auth validations

import antigone
import gleam/bit_array
import gleam/bool
import gleam/order
import gleam/regex
import gleam/string
import lib/user/types/email
import lib/user/types/login_user.{type LoginUser}
import lib/user/types/user.{type User}

pub fn is_valid_email_string(to_verify: email.Email) -> Bool {
  let assert Ok(reg) =
    regex.from_string(
      "(?:[a-z0-9!#$%&\\'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&\\'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])",
    )

  regex.check(reg, to_verify.value)
}

fn is_valid_password(to_verify: String, hashed_password: String) -> Bool {
  to_verify
  |> bit_array.from_string
  |> antigone.verify(hashed_password)
}

fn is_valid_email(
  to_verify to_verify: email.Email,
  against email: email.Email,
) -> Bool {
  case string.compare(to_verify.value, email.value) {
    order.Eq -> True
    _ -> False
  }
}

pub fn validate_login_user(
  to_verify: LoginUser,
  against: User,
) -> Result(Nil, String) {
  let login_user.LoginUser(email, pass) = to_verify
  let user.User(_, _, email: valid_email, password_hash: valid_password) =
    against

  use <- bool.guard(
    !is_valid_email(email, against: valid_email),
    Error("Email is not valid"),
  )
  use <- bool.guard(
    !is_valid_password(pass, valid_password),
    Error("Password is not valid"),
  )
  Ok(Nil)
}
