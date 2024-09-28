import decode
import gleam/pgo

/// A row you get from running the `user_by_id` query
/// defined in `./src/lib/user/sql/user_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v1.7.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type UserByIdRow {
  UserByIdRow(id: Int, full_name: String, email: String, password_hash: String)
}

/// Runs the `user_by_id` query
/// defined in `./src/lib/user/sql/user_by_id.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn user_by_id(db, arg_1) {
  let decoder =
    decode.into({
      use id <- decode.parameter
      use full_name <- decode.parameter
      use email <- decode.parameter
      use password_hash <- decode.parameter
      UserByIdRow(
        id: id,
        full_name: full_name,
        email: email,
        password_hash: password_hash,
      )
    })
    |> decode.field(0, decode.int)
    |> decode.field(1, decode.string)
    |> decode.field(2, decode.string)
    |> decode.field(3, decode.string)

  "select id, full_name, email, password_hash
from users
where id = $1;"
  |> pgo.execute(db, [pgo.int(arg_1)], decode.from(decoder, _))
}


/// A row you get from running the `user_by_email` query
/// defined in `./src/lib/user/sql/user_by_email.sql`.
///
/// > 🐿️ This type definition was generated automatically using v1.7.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type UserByEmailRow {
  UserByEmailRow(
    id: Int,
    full_name: String,
    email: String,
    password_hash: String,
  )
}

/// Runs the `user_by_email` query
/// defined in `./src/lib/user/sql/user_by_email.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn user_by_email(db, arg_1) {
  let decoder =
    decode.into({
      use id <- decode.parameter
      use full_name <- decode.parameter
      use email <- decode.parameter
      use password_hash <- decode.parameter
      UserByEmailRow(
        id: id,
        full_name: full_name,
        email: email,
        password_hash: password_hash,
      )
    })
    |> decode.field(0, decode.int)
    |> decode.field(1, decode.string)
    |> decode.field(2, decode.string)
    |> decode.field(3, decode.string)

  "select id, full_name, email, password_hash
from users
where email = $1;"
  |> pgo.execute(db, [pgo.text(arg_1)], decode.from(decoder, _))
}


/// Runs the `update_user` query
/// defined in `./src/lib/user/sql/update_user.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn update_user(db, arg_1, arg_2, arg_3, arg_4) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "update users
set full_name = $2, email = $3, password_hash = $4
where id = $1;"
  |> pgo.execute(
    db,
    [pgo.int(arg_1), pgo.text(arg_2), pgo.text(arg_3), pgo.text(arg_4)],
    decode.from(decoder, _),
  )
}


/// A row you get from running the `insert_user` query
/// defined in `./src/lib/user/sql/insert_user.sql`.
///
/// > 🐿️ This type definition was generated automatically using v1.7.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type InsertUserRow {
  InsertUserRow(id: Int, full_name: String, email: String)
}

/// Runs the `insert_user` query
/// defined in `./src/lib/user/sql/insert_user.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_user(db, arg_1, arg_2, arg_3) {
  let decoder =
    decode.into({
      use id <- decode.parameter
      use full_name <- decode.parameter
      use email <- decode.parameter
      InsertUserRow(id: id, full_name: full_name, email: email)
    })
    |> decode.field(0, decode.int)
    |> decode.field(1, decode.string)
    |> decode.field(2, decode.string)

  "insert into users (full_name, email, password_hash)
values ($1, $2, $3)
returning id, full_name, email;"
  |> pgo.execute(
    db,
    [pgo.text(arg_1), pgo.text(arg_2), pgo.text(arg_3)],
    decode.from(decoder, _),
  )
}


/// A row you get from running the `all_users` query
/// defined in `./src/lib/user/sql/all_users.sql`.
///
/// > 🐿️ This type definition was generated automatically using v1.7.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type AllUsersRow {
  AllUsersRow(id: Int, full_name: String, email: String)
}

/// Runs the `all_users` query
/// defined in `./src/lib/user/sql/all_users.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn all_users(db) {
  let decoder =
    decode.into({
      use id <- decode.parameter
      use full_name <- decode.parameter
      use email <- decode.parameter
      AllUsersRow(id: id, full_name: full_name, email: email)
    })
    |> decode.field(0, decode.int)
    |> decode.field(1, decode.string)
    |> decode.field(2, decode.string)

  "select id, full_name, email
from users;"
  |> pgo.execute(db, [], decode.from(decoder, _))
}
