import birl
import gleam/pgo
import lib/session/model/session.{type Session, type SessionError}
import lib/session/sql
import lib/shared/types/db.{type Db}

pub fn session_by_id(
  db: Db,
  session_id: String,
) -> Result(Session, SessionError) {
  let assert Ok(pgo.Returned(_, rows)) = sql.session_by_id(db, session_id)
  case rows {
    [row] ->
      case row {
        sql.SessionByIdRow(session_id, user_id, expiration_time) -> {
          Ok(session.Session(
            session_id,
            user_id,
            birl.from_erlang_local_datetime(expiration_time),
          ))
        }
      }
    _ -> Error(session.SessionDoesNotExist)
  }
}
