//// Represents the User type sent out 

import gleam/json.{object, string}

pub type User {
  User(id: String, full_name: String, email: String)
}

pub fn encode_to_json(user: User) -> json.Json {
  object([
    #("id", string(user.id)),
    #("full_name", string(user.full_name)),
    #("email", string(user.email)),
  ])
}
