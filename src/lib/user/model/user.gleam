//// Represents the User entity, sent out from backend
//// Does not concern itself with validation since data in the db is assumed to be valid

import gleam/json.{object, string}
import gleam/list
import lib/shared/types/id.{type Id}

pub type User {
  User(id: Id(User), full_name: String, email: String)
}

pub fn serialise(user: User) -> json.Json {
  object([
    #("id", string(id.show(user.id))),
    #(
      "attributes",
      object([
        #("full_name", string(user.full_name)),
        #("email", string(user.email)),
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
