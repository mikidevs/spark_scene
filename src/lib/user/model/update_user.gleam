//// Reprents the data when a user updates their information

import gleam/dynamic.{type Dynamic, field, int, string}
import gleam/result
import lib/common/email.{type Email, type Invalid, type Valid}
import lib/common/id
import lib/common/password.{type NonValidatedPassword, type ValidatedPassword}

pub opaque type UpdateUser {
  UpdateUser(
    id: id.Id(UpdateUser),
    full_name: String,
    email: Email(Invalid),
    password: NonValidatedPassword,
  )
}

pub type ValidUpdateUser {
  ValidUpdateUser(
    id: id.Id(ValidUpdateUser),
    full_name: String,
    email: Email(Valid),
    password: ValidatedPassword,
  )
}

pub fn from_json(json: Dynamic) -> Result(UpdateUser, String) {
  let decoder =
    dynamic.decode4(
      UpdateUser,
      field("id", of: fn(dyn) {
        int(dyn)
        |> result.map(fn(i) { id.from_int(i) })
      }),
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
  |> result.replace_error("Invalid update submission")
}

pub fn validate(update_user: UpdateUser) -> Result(ValidUpdateUser, String) {
  let UpdateUser(id, full_name, email, password) = update_user
  // structural validation
  use email <- result.try(email.validate_format(email))
  use password <- result.try(password.validate_format(password))
  Ok(ValidUpdateUser(id.from_int(id.to_int(id)), full_name, email, password))
}
