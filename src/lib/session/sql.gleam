import decode
import gleam/pgo

/// Runs the `update_session` query
/// defined in `./src/lib/session/sql/update_session.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn update_session(db, arg_1, arg_2) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "update sessions
  set expiration_time = $2
  where session_id = $1;
"
  |> pgo.execute(
    db,
    [pgo.text(arg_1), pgo.timestamp(arg_2)],
    decode.from(decoder, _),
  )
}


/// Runs the `insert_session` query
/// defined in `./src/lib/session/sql/insert_session.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_session(db, arg_1, arg_2, arg_3) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "insert into sessions (session_id, user_id, expiration_time)
values ($1, $2, $3);"
  |> pgo.execute(
    db,
    [pgo.text(arg_1), pgo.int(arg_2), pgo.timestamp(arg_3)],
    decode.from(decoder, _),
  )
}


/// Runs the `destroy_session` query
/// defined in `./src/lib/session/sql/destroy_session.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn destroy_session(db, arg_1) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "delete from sessions where session_id = $1;
"
  |> pgo.execute(db, [pgo.text(arg_1)], decode.from(decoder, _))
}
