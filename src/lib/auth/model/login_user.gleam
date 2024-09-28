import gleam/dynamic.{type Dynamic, field, string}
import gleam/result
import lib/common/email.{type Email, type Invalid}

pub type LoginUser {
  LoginUser(email: Email(Invalid), password: String)
}

pub fn decode_from_json(json: Dynamic) -> Result(LoginUser, String) {
  let decoder =
    dynamic.decode2(
      LoginUser,
      field("email", of: fn(dyn) {
        use email_str <- result.try(dynamic.string(dyn))
        Ok(email.from_string(email_str))
      }),
      field("password", of: string),
    )

  decoder(json)
  |> result.map_error(fn(_) { "Invalid login submission" })
}
