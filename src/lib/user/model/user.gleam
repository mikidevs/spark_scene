//// Represents the User entity, sent out from backend

import gleam/json.{object, string}
import gleam/list
import lib/common/id.{type Id}
import lib/user/types/email.{type Email}

pub type User {
  User(id: Id, full_name: String, email: Email, password_hash: String)
}

pub fn serialise(user: User) -> json.Json {
  object([
    #("id", string(id.show(user.id))),
    #(
      "attributes",
      object([
        #("full_name", string(user.full_name)),
        #("email", string(user.email.value)),
      ]),
    ),
  ])
}

pub fn serialise_many(users: List(User)) -> json.Json {
  let users =
    users
    |> list.map(serialise)
    |> json.preprocessed_array()

  json.object([#("users", users)])
}
