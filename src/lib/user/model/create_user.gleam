//// Reprents the create user, used during registration

import formal/form
import gleam/dynamic.{type Dynamic, field, string}
import gleam/result
import wisp

pub type CreateUser {
  CreateUser(full_name: String, email: String, password: String)
}

pub fn from_form_data(form_data: wisp.FormData) -> Result(CreateUser, form.Form) {
  form.decoding({
    use full_name <- form.parameter
    use email <- form.parameter
    use password <- form.parameter
    CreateUser(full_name: full_name, email: email, password: password)
  })
  |> form.with_values(form_data.values)
  |> form.field(
    "full_name",
    form.string
      |> form.and(form.must_not_be_empty),
  )
  |> form.field(
    "email",
    form.string
      |> form.and(form.must_not_be_empty)
      |> form.and(form.must_be_an_email),
  )
  |> form.field(
    "password",
    form.string
      |> form.and(form.must_not_be_empty)
      |> form.and(form.must_be_string_longer_than(8)),
  )
  |> form.finish
}

pub fn from_json(json: Dynamic) -> Result(CreateUser, String) {
  let decoder =
    dynamic.decode3(
      CreateUser,
      field("full_name", of: string),
      field("email", of: string),
      field("password", of: string),
    )

  // // structural validation
  // use email <- result.try(email.validate_format(email))
  // use password <- result.try(password.validate_format(password))
  decoder(json)
  |> result.replace_error("Invalid registration submission")
}
