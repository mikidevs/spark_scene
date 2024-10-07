//// Reprents the create user, used during registration

import gleam/dynamic.{type Dynamic, field, string}
import gleam/result
import lib/shared/types/email.{type Email, type Invalid, type Valid}
import lib/shared/types/password.{
  type NonValidatedPassword, type ValidatedPassword,
}

pub opaque type CreateUser {
  CreateUser(
    full_name: String,
    email: Email(Invalid),
    password: NonValidatedPassword,
  )
}

pub type ValidCreateUser {
  ValidCreateUser(
    full_name: String,
    email: Email(Valid),
    password: ValidatedPassword,
  )
}

pub fn from_json(json: Dynamic) -> Result(CreateUser, String) {
  let decoder =
    dynamic.decode3(
      CreateUser,
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

pub fn validate(create_user: CreateUser) -> Result(ValidCreateUser, String) {
  let CreateUser(full_name, email, password) = create_user
  // structural validation
  use email <- result.try(email.validate_format(email))
  use password <- result.try(password.validate_format(password))
  Ok(ValidCreateUser(full_name, email, password))
}
