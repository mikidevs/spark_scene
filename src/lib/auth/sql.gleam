import decode
import gleam/pgo

/// Runs the `update_session` query
/// defined in `./src/lib/auth/sql/update_session.sql`.
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


/// A row you get from running the `session_by_id` query
/// defined in `./src/lib/auth/sql/session_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v1.7.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SessionByIdRow {
  SessionByIdRow(
    session_id: String,
    user_id: Int,
    expiration_time: #(#(Int, Int, Int), #(Int, Int, Int)),
  )
}

/// Runs the `session_by_id` query
/// defined in `./src/lib/auth/sql/session_by_id.sql`.
///
/// > 🐿️ This function was generated automatically using v1.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn session_by_id(db, arg_1) {
  let decoder =
    decode.into({
      use session_id <- decode.parameter
      use user_id <- decode.parameter
      use expiration_time <- decode.parameter
      SessionByIdRow(
        session_id: session_id,
        user_id: user_id,
        expiration_time: expiration_time,
      )
    })
    |> decode.field(0, decode.string)
    |> decode.field(1, decode.int)
    |> decode.field(2, timestamp_decoder())

  "select session_id, user_id, expiration_time
from sessions
where session_id = $1;"
  |> pgo.execute(db, [pgo.text(arg_1)], decode.from(decoder, _))
}


/// Runs the `insert_session` query
/// defined in `./src/lib/auth/sql/insert_session.sql`.
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
/// defined in `./src/lib/auth/sql/destroy_session.sql`.
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


// --- UTILS -------------------------------------------------------------------

/// A decoder to decode `timestamp`s coming from a Postgres query.
///
fn timestamp_decoder() {
  use dynamic <- decode.then(decode.dynamic)
  case pgo.decode_timestamp(dynamic) {
    Ok(timestamp) -> decode.into(timestamp)
    Error(_) -> decode.fail("timestamp")
  }
}
