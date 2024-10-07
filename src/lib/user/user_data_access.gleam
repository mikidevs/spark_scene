//// All data services will crash the server if the database fails on a query!

import gleam/list
import gleam/pgo.{Returned}
import lib/session/model/login_user
import lib/shared/types/db.{type Db}
import lib/shared/types/email.{type Email, type Valid}
import lib/shared/types/id
import lib/shared/types/password
import lib/user/model/create_user.{type ValidCreateUser}
import lib/user/model/update_user.{type ValidUpdateUser}
import lib/user/model/user.{type User, User}
import lib/user/sql

pub fn all(db: Db) -> List(User) {
  let assert Ok(Returned(_, rows)) = sql.all_users(db)
  list.map(rows, fn(row) {
    let sql.AllUsersRow(id, full_name, email) = row
    User(id.from_int(id), full_name, email)
  })
}

pub fn one(db: Db, id: Int) -> Result(User, String) {
  let assert Ok(Returned(count, rows)) = sql.user_by_id(db, id)
  case count < 1 {
    True -> Error("The user with this id does not exist")
    False -> {
      let assert [sql.UserByIdRow(id, full_name, email, _)] = rows
      Ok(User(id.from_int(id), full_name, email))
    }
  }
}

pub fn save(db: Db, user: ValidCreateUser) -> Result(User, String) {
  let email = email.unwrap(user.email)
  let assert Ok(Returned(count, _)) = sql.user_by_email(db, email)

  case count > 0 {
    True -> Error("This email is already being used")
    _ -> {
      let assert Ok(Returned(_, rows)) =
        sql.insert_user(
          db,
          user.full_name,
          email,
          password.hash(password.unwrap(user.password)),
        )
      let assert [sql.InsertUserRow(id, full_name, email)] = rows
      Ok(User(id.from_int(id), full_name, email))
    }
  }
}

pub fn update(db: Db, user: ValidUpdateUser) -> Result(Nil, String) {
  let update_user.ValidUpdateUser(id, full_name, email, password) = user

  let assert Ok(Returned(count, _)) =
    sql.update_user(
      db,
      id.to_int(id),
      full_name,
      email.unwrap(email),
      password.unwrap(password),
    )

  case count < 1 {
    True -> Error("The user with this id does not exist")
    False -> Ok(Nil)
  }
}

pub fn login_user_by_email(
  db: Db,
  email: Email(Valid),
) -> Result(login_user.ValidLoginUser, String) {
  let email = email.unwrap(email)

  let assert Ok(Returned(_, rows)) = sql.user_by_email(db, email)
  case rows {
    [] -> Error("This email does not exist")
    _ -> {
      let assert [sql.UserByEmailRow(id, _, email, password_hash)] = rows

      Ok(login_user.ValidLoginUser(
        id.from_int(id),
        email.Email(email),
        password.ValidatedPassword(password_hash),
      ))
    }
  }
}
