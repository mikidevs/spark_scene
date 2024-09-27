//// All data services will crash the server if the database fails on a query!

import gleam/list
import gleam/pgo.{Returned}
import lib/auth/model/validation_user
import lib/auth/password
import lib/common/db.{type Db}
import lib/common/id
import lib/user/model/email
import lib/user/model/register_user.{type RegisterUser}
import lib/user/model/user.{type User, User}
import lib/user/sql

pub fn all(db: Db) -> List(User) {
  let assert Ok(Returned(_, rows)) = sql.all_users(db)
  list.map(rows, fn(row) {
    let sql.AllUsersRow(id, full_name, email) = row
    User(id.from_int(id), full_name, email.Email(email))
  })
}

pub fn save(db: Db, reg: RegisterUser) -> Result(User, String) {
  let assert Ok(Returned(count, _)) =
    sql.validation_user_by_email(db, reg.email)

  case count > 0 {
    True -> Error("This email is already being used")
    _ -> {
      let assert Ok(_) =
        sql.insert_user(
          db,
          reg.full_name,
          reg.email,
          password.hash(reg.password),
        )
      Ok(User(id.from_int(0), reg.full_name, email.Email(reg.email)))
    }
  }
}

pub fn validation_user_by_email(
  db: Db,
  email: email.Email,
) -> Result(validation_user.ValidationUser, String) {
  let assert Ok(Returned(_, rows)) =
    sql.validation_user_by_email(db, email.value)
  case rows {
    [] -> Error("This email does not exist")
    _ -> {
      let assert [
        sql.ValidationUserByEmailRow(id, full_name, email, password_hash),
      ] = rows
      Ok(validation_user.ValidationUser(
        id.from_int(id),
        full_name,
        email.Email(email),
        password_hash,
      ))
    }
  }
}
