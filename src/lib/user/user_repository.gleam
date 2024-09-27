//// All data services will crash the server if the database fails on a query!

import gleam/list
import gleam/pgo.{Returned}
import lib/common/db.{type Db}
import lib/user/model/email
import lib/user/model/password_hash
import lib/user/sql
import lib/user/types/register_user.{type RegisterUser}
import lib/user/types/user.{type User, User}

pub fn all(db: Db) -> List(User) {
  let assert Ok(Returned(_, rows)) = sql.all_users(db)
  list.map(rows, fn(row) {
    let sql.AllUsersRow(id, full_name, email, password_hash) = row
    User(id.Id(id), full_name, email.Email(email), password_hash)
  })
}

pub fn save(db: Db, reg: RegisterUser) -> Result(User, String) {
  let assert Ok(Returned(count, _)) = sql.user_by_email(db, reg.email)

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
      Ok(User(id.Id(0), reg.full_name, email.Email(reg.email), ""))
    }
  }
}

pub fn one_by_email(db: Db, email: email.Email) -> Result(User, String) {
  let assert Ok(Returned(_, rows)) = sql.user_by_email(db, email.value)
  case rows {
    [] -> Error("This email does not exist")
    _ -> {
      let assert [sql.UserByEmailRow(id, full_name, email, password_hash)] =
        rows
      Ok(User(id.Id(id), full_name, email.Email(email), password_hash))
    }
  }
}
