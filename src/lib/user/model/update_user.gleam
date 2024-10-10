//// Reprents the data when a user updates their information

import gleam/dynamic.{type Dynamic, field, int, string}
import gleam/result
import lib/shared/types/id

pub type UpdateUser {
  UpdateUser(
    id: id.Id(UpdateUser),
    full_name: String,
    email: String,
    password: String,
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
      field("email", of: string),
      field("password", of: string),
    )

  // use email <- result.try(email.validate_format(email))
  // use password <- result.try(password.validate_format(password))
  decoder(json)
  |> result.replace_error("Invalid update submission")
}
