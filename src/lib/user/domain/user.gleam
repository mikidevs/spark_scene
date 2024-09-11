import gleam/json.{object, string}
import lib/common/id.{type Id}
import lib/user/domain/email.{type Email}

pub type User {
  User(id: Id, full_name: String, email: Email)
}

pub type UserRegistration {
  UserRegistration(full_name: String, email: String, password_hash: String)
}

pub fn to_json(user: User) -> json.Json {
  object([
    #("id", string(id.unwrap(user.id))),
    #("full_name", string(user.full_name)),
    #("email", string(email.unwrap(user.email))),
  ])
}
