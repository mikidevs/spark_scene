import gleam/dynamic.{type Dynamic, field, string}
import gleam/result
import lib/shared/types/id

pub type LoginUser {
  LoginUser(email: String, password: String)
}

pub type ValidLoginUser {
  ValidLoginUser(email: String, password_hash: String)
}

pub fn from_json(json: Dynamic) -> Result(LoginUser, String) {
  let decoder =
    dynamic.decode2(
      LoginUser,
      field("email", of: string),
      field("password", of: string),
    )

  decoder(json)
  |> result.map_error(fn(_) { "Invalid login submission" })
}
