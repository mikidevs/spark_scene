//// Represents the User type sent out 

import gleam/json.{int, object, string}
import lib/user/types/email.{type Email}
import lib/user/types/id.{type Id}

pub type User {
  User(id: Id, full_name: String, email: Email, password_hash: String)
}

pub fn wrap(
  id: Int,
  full_name: String,
  email: String,
  password_hash: String,
) -> User {
  User(id.Id(id), full_name, email.Email(email), password_hash)
}

pub fn encode_to_json(user: User) -> json.Json {
  object([
    #("id", int(user.id.value)),
    #("full_name", string(user.full_name)),
    #("email", string(user.email.value)),
  ])
}
