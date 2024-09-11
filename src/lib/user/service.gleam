//// All data services will crash the server if the database fails on a query!

import gleam/dynamic.{type Dynamic, field, string}
import gleam/int
import gleam/list
import gleam/pgo.{Returned}
import lib/common/db.{type Db}
import lib/common/id
import lib/user/domain/email
import lib/user/domain/user.{type User}
import lib/user/sql

pub fn registration_from_json(
  json: Dynamic,
) -> Result(user.UserRegistration, dynamic.DecodeErrors) {
  let decoder =
    dynamic.decode3(
      user.UserRegistration,
      field("full_name", of: string),
      field("email", of: string),
      field("password_hash", of: string),
    )

  decoder(json)
}

pub fn save_user(db: Db, reg: user.UserRegistration) -> Result(Nil, String) {
  let assert Ok(Returned(count, _)) = sql.user_by_email(db, reg.email)

  case count > 0 {
    True -> Error("Email already exists")
    _ -> {
      let assert Ok(_) =
        sql.insert_user(db, reg.full_name, reg.email, reg.password_hash)
      Ok(Nil)
    }
  }
}

pub fn all_users(db: Db) -> List(User) {
  let assert Ok(Returned(_, rows)) = sql.all_users(db)
  list.map(rows, fn(row) {
    let sql.AllUsersRow(id, full_name, email) = row
    user.User(id |> int.to_string |> id.wrap, full_name, email.Email(email))
  })
}
