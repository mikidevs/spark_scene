//// Includes password to validate user, assumes valid email since db will only contain valid data

import lib/common/id.{type Id}

pub type ValidationUser {
  ValidationUser(
    id: Id(ValidationUser),
    full_name: String,
    email: String,
    password_hash: String,
  )
}
