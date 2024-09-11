import gleam/dynamic.{type Dynamic, field, string}
import gleam/result
import lib/user/types/email.{type Email}

pub type LoginUser {
  LoginUser(email: Email, password_hash: String)
}

pub fn decode_from_json(
  json: Dynamic,
) -> Result(LoginUser, dynamic.DecodeErrors) {
  let decoder =
    dynamic.decode2(
      LoginUser,
      field("email", of: fn(dyn) {
        use email_str <- result.try(dynamic.string(dyn))
        Ok(email.Email(email_str))
      }),
      field("password_hash", of: string),
    )

  decoder(json)
}
