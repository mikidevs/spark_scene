import gleam/dynamic.{type Dynamic, field, string}
import gleam/pgo
import gleam/result
import lib/common/db
import lib/user/sql

pub type UserRegistration {
  UserRegistration(full_name: String, email: String, password_hash: String)
}

pub fn registration_from_json(
  json: Dynamic,
) -> Result(UserRegistration, dynamic.DecodeErrors) {
  let decoder =
    dynamic.decode3(
      UserRegistration,
      field("full_name", of: string),
      field("email", of: string),
      field("password_hash", of: string),
    )

  decoder(json)
}

pub fn save_user(db: db.Db, reg: UserRegistration) -> Result(Nil, String) {
  let db_error_msg = "Database error: Could not save user"
  case sql.user_by_email(db, reg.email) {
    Ok(pgo.Returned(count, _)) if count > 0 -> Error("Email already exists")
    Ok(_) ->
      {
        use _ <- result.try(sql.insert_user(
          db,
          reg.full_name,
          reg.email,
          reg.password_hash,
        ))

        Ok(Nil)
      }
      |> result.map_error(fn(_) { db_error_msg })
    Error(_) -> Error(db_error_msg)
  }
}
