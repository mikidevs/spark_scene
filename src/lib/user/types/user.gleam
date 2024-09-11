//// Represents the User type sent out from gets

import gleam/json.{object, string}
import lib/common/id.{type Id}
import lib/user/types/email.{type Email}

pub type User {
  User(id: Id, full_name: String, email: Email)
}

pub fn encode_to_json(user: User) -> json.Json {
  object([
    #("id", string(id.unwrap(user.id))),
    #("full_name", string(user.full_name)),
    #("email", string(user.email.value)),
  ])
}
