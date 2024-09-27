import lib/common/id.{type Id}
import lib/user/model/email.{type Email}

pub type ValidationUser {
  ValidationUser(
    id: Id(ValidationUser),
    full_name: String,
    email: Email,
    password_hash: String,
  )
}
