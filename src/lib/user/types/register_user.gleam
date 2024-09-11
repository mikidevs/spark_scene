import gleam/dynamic.{type Dynamic, field, string}

pub type RegisterUser {
  RegisterUser(full_name: String, email: String, password_hash: String)
}

pub fn decode_from_json(
  json: Dynamic,
) -> Result(RegisterUser, dynamic.DecodeErrors) {
  let decoder =
    dynamic.decode3(
      RegisterUser,
      field("full_name", of: string),
      field("email", of: string),
      field("password_hash", of: string),
    )

  decoder(json)
}
