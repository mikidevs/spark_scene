//// Represents the User type sent in during registration and login

import gleam/dynamic.{type Dynamic, field, string}

pub type AuthUser {
  AuthUser(full_name: String, email: String, password_hash: String)
}

pub fn decode_from_json(json: Dynamic) -> Result(AuthUser, dynamic.DecodeErrors) {
  let decoder =
    dynamic.decode3(
      AuthUser,
      field("full_name", of: string),
      field("email", of: string),
      field("password_hash", of: string),
    )

  decoder(json)
}
