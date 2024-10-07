import gleam/dynamic.{type Dynamic, field, string}
import gleam/result
import lib/common/email.{type Email, type Invalid, type Valid}
import lib/common/id
import lib/common/password.{type NonValidatedPassword, type ValidatedPassword}

pub type LoginUser {
  LoginUser(email: Email(Invalid), password: NonValidatedPassword)
}

pub type ValidLoginUser {
  ValidLoginUser(
    id: id.Id(ValidLoginUser),
    email: Email(Valid),
    password_hash: ValidatedPassword,
  )
}

pub fn from_json(json: Dynamic) -> Result(LoginUser, String) {
  let decoder =
    dynamic.decode2(
      LoginUser,
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
  |> result.map_error(fn(_) { "Invalid login submission" })
}
