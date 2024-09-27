//// Reprents the create user, used during registration

import gleam/dynamic.{type Dynamic, field, string}
import gleam/result

pub type RegisterUser {
  RegisterUser(full_name: String, email: String, password: String)
}

pub fn from_json(json: Dynamic) -> Result(RegisterUser, String) {
  let decoder =
    dynamic.decode3(
      RegisterUser,
      field("full_name", of: string),
      field("email", of: string),
      field("password", of: string),
    )

  decoder(json)
  |> result.map_error(fn(_) { "Invalid registration submission" })
}
