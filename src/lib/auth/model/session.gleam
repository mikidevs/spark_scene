import birl.{type Time}
import gleam/result
import gluid
import lib/auth/model/validation_user
import lib/auth/sql
import lib/common/db.{type Db}
import lib/common/id.{type Id}

pub type Session {
  Session(session_id: String, user_id: Int, expiration_time: birl.Time)
}

pub type SessionError {
  SessionExpired
  SessionDoesNotExist
}

pub fn create(
  db: Db,
  user_id: Id(validation_user.ValidationUser),
  expiration_time: birl.Time,
) -> String {
  let session_id = gluid.guidv4()
  let assert Ok(_) =
    sql.insert_session(
      db,
      session_id,
      id.to_int(user_id),
      birl.to_erlang_datetime(expiration_time),
    )
  session_id
}

pub fn update(db: Db, session_id: String, expiration_time: Time) -> String {
  let assert Ok(_) =
    sql.update_session(db, session_id, birl.to_erlang_datetime(expiration_time))

  session_id
}

pub fn destroy(db: Db, session_id: String) -> Result(Nil, SessionError) {
  sql.destroy_session(db, session_id)
  |> result.replace(Nil)
  |> result.replace_error(SessionDoesNotExist)
}
