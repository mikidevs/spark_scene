import app/web.{type Context}
import birl
import birl/duration
import gleam/result
import lib/session/model/login_user
import lib/session/model/session
import lib/shared/types/email
import lib/shared/types/password
import lib/user/user_data_access as user_db
import wisp.{type Request, type Response}

const session_time = 30

pub fn handle_request(
  ctx: Context,
  req: Request,
  path_segments: List(String),
) -> Response {
  case path_segments {
    ["login"] -> web.post(ctx, req, login)
    _ -> wisp.not_found()
  }
}

fn login(ctx: Context, req: Request) -> Response {
  use login_user <- web.json_guard(req, login_user.from_json)
  let login_user.LoginUser(email, password) = login_user
  let response_ = {
    use email <- result.try(email.validate_format(email))
    use valid_user <- result.try(user_db.login_user_by_email(ctx.db, email))
    use _ <- result.try(password.verify_password(
      password,
      valid_user.password_hash,
    ))

    let session_id =
      session.create(
        ctx.db,
        valid_user.id,
        birl.now() |> birl.add(duration.minutes(session_time)),
      )

    let success = web.json_message("User login successful")
    wisp.ok()
    |> wisp.set_cookie(
      req,
      "AUTH_COOKIE",
      session_id,
      wisp.Signed,
      session_time * 60,
    )
    |> web.json_body(success)
    |> Ok
  }

  case response_ {
    Ok(resp) -> resp
    Error(msg) -> {
      wisp.unprocessable_entity()
      |> web.json_body(web.json_message(msg))
    }
  }
}
