import birl.{type Time}
import gluid
import lib/common/db.{type Db}
import lib/session/sql
import lib/user/types/id

pub type Session {
  Session(session_id: String, user_email: String, expiration_time: birl.Time)
}

pub fn create(db: Db, user_id: id.Id, expiration_time: birl.Time) -> String {
  let session_id = gluid.guidv4()
  let assert Ok(_) =
    sql.insert_session(
      db,
      session_id,
      user_id.value,
      birl.to_erlang_datetime(expiration_time),
    )
  session_id
}

pub fn update(db: Db, session_id: String, expiration_time: Time) -> String {
  let assert Ok(_) =
    sql.update_session(db, session_id, birl.to_erlang_datetime(expiration_time))

  session_id
}

pub fn destroy(db: Db, session_id: String) -> Nil {
  let assert Ok(_) = sql.destroy_session(db, session_id)
  Nil
}
