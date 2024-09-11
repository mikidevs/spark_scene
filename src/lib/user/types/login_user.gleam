import gleam/dynamic.{type Dynamic, field, string}

pub type LoginUser {
  LoginUser(email: String, password_hash: String)
}

pub fn decode_from_json(
  json: Dynamic,
) -> Result(LoginUser, dynamic.DecodeErrors) {
  let decoder =
    dynamic.decode2(
      LoginUser,
      field("email", of: string),
      field("password_hash", of: string),
    )

  decoder(json)
}
