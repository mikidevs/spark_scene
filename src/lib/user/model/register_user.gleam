//// Reprents the create user, used during registration

import gleam/dynamic.{type Dynamic, field, string}
import gleam/result
import lib/common/email.{type Email, type Invalid, type Valid}
import lib/common/password.{type NonValidatedPassword, type ValidatedPassword}

pub opaque type RegisterUser {
  RegisterUser(
    full_name: String,
    email: Email(Invalid),
    password: NonValidatedPassword,
  )
}

pub type ValidRegisterUser {
  ValidRegisterUser(
    full_name: String,
    email: Email(Valid),
    password: ValidatedPassword,
  )
}

pub fn from_json(json: Dynamic) -> Result(RegisterUser, String) {
  let decoder =
    dynamic.decode3(
      RegisterUser,
      field("full_name", of: string),
      field("email", of: fn(dyn) {
        string(dyn)
        |> result.map(fn(str) { email.from_string(str) })
      }),
      field("password", of: fn(dyn) {
        string(dyn)
        |> result.map(fn(str) { password.from_string(str) })
      }),
    )

  decoder(json)
  |> result.replace_error("Invalid registration submission")
}

pub fn validate(reg_user: RegisterUser) -> Result(ValidRegisterUser, String) {
  let RegisterUser(full_name, email, password) = reg_user
  // structural validation
  use email <- result.try(email.validate_format(email))
  use password <- result.try(password.validate_format(password))
  Ok(ValidRegisterUser(full_name, email, password))
}
