import lib/common/email.{type Email}
import lib/common/id.{type Id}
import lib/user/password.{type Password}

pub type User {
  User(id: Id, full_name: String, email: Email, password_hash: Password)
}
