import birl.{type Time}
import gleam/result
import gluid
import lib/session/model/login_user
import lib/session/sql
import lib/shared/types/db.{type Db}
import lib/shared/types/id.{type Id}

pub type Session {
  Session(session_id: String, user_id: Int, expiration_time: birl.Time)
}

pub type SessionError {
  SessionExpired
  SessionDoesNotExist
}

pub fn create(
  db: Db,
  user_id: Id(login_user.ValidLoginUser),
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
