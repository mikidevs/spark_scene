//// Reprents the create user, used during registration

import gleam/dynamic.{type Dynamic, field, string}
import gleam/result
import lib/common/email.{type Email, type Invalid, type Valid}

pub type RegisterUserData {
  RegisterUserData(full_name: String, email: Email(Invalid), password: String)
}

pub type ValidRegisterUser {
  ValidRegisterUser(full_name: String, email: Email(Valid), password: String)
}

pub fn from_json(json: Dynamic) -> Result(RegisterUserData, String) {
  let decoder =
    dynamic.decode3(
      RegisterUserData,
      field("full_name", of: string),
      field("email", of: fn(dyn) {
        string(dyn)
        |> result.map(fn(str) { email.from_string(str) })
      }),
      field("password", of: string),
    )

  decoder(json)
  |> result.map_error(fn(_) { "Invalid registration submission" })
}
