import birl.{type Time}
import gluid
import lib/common/db.{type Db}
import lib/common/id.{type Id}
import lib/session/sql
import lib/user/types/email.{type Email}

pub type Session {
  Session(session_id: Id, user_email: Email, expiration_time: birl.Time)
}

pub fn create(db: Db, email: Email, expiration_time: Time) {
  let session_id = gluid.guidv4()
  sql.insert_session(
    db,
    session_id,
    email.value,
    birl.to_erlang_datetime(expiration_time),
  )
}

pub fn update(db: Db, session_id: Id, expiration_time: Time) {
  sql.update_session(
    db,
    id.unwrap(session_id),
    birl.to_erlang_datetime(expiration_time),
  )
}

pub fn destroy(db: Db, session_id: Id) {
  sql.destroy_session(db, id.unwrap(session_id))
}
