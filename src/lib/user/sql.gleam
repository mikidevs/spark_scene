import decode
import gleam/pgo

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


/// Runs the `insert_user` query
/// defined in `./src/lib/user/sql/insert_user.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_user(db, arg_1, arg_2, arg_3) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "insert into users (full_name, email, password_hash)
values ($1, $2, $3);"
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
  AllUsersRow(id: Int, full_name: String, email: String, password_hash: String)
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
      use password_hash <- decode.parameter
      AllUsersRow(
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
from users;"
  |> pgo.execute(db, [], decode.from(decoder, _))
}
