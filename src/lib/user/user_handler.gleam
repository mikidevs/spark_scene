import app/web.{type Context}
import birl
import birl/duration
import gleam/bool
import gleam/http.{Get, Post}
import lib/common/json_util
import lib/entity/handler.{Accessor}
import lib/session/session
import lib/user/model/register_user
import lib/user/user_repository as user_repo
import lib/user/validations
import wisp.{type Request, type Response}

pub fn handle_request(
  path_segments: List(String),
  req: Request,
  ctx: Context,
) -> Response {
  let user_accessor = Accessor(user_repo.save, user_repo.all)

  case path_segments {
    [] -> crud_handler(req, ctx)
    ["login"] -> web.post(req, ctx, login)
    _ -> wisp.not_found()
  }
}

fn register(req: Request, ctx: Context) -> Response {
  use user_json <- wisp.require_json(req)
  use reg_user <- web.json_guard(user_json, register_user.decode_from_json)
  case user_repo.save(ctx.db, reg_user) {
    Ok(_) -> {
      let success = json_util.message("User was successfully registered")
      wisp.created()
      |> wisp.json_body(success)
    }
    Error(msg) -> {
      let error = json_util.message(msg)
      wisp.unprocessable_entity()
      |> wisp.json_body(error)
    }
  }
}

fn login(req: Request, ctx: Context) -> Response {
  use user_json <- wisp.require_json(req)
  use login_user <- web.json_guard(user_json, login_user.decode_from_json)
  use <- bool.guard(!validations.is_valid_email_string(login_user.email), {
    let error = json_util.message("Invalid email address")
    wisp.unprocessable_entity()
    |> wisp.json_body(error)
  })

  case user_db.user_by_email(ctx.db, login_user.email) {
    Ok(db_user) -> {
      use user <- web.validation_guard(
        login_user,
        db_user,
        validations.validate_login_user,
      )
      let session_time = 30
      let session_id =
        session.create(
          ctx.db,
          user.id,
          birl.now() |> birl.add(duration.minutes(session_time)),
        )
      let success = json_util.message("User login successful")
      wisp.ok()
      |> wisp.set_cookie(
        req,
        "AUTH_COOKIE",
        session_id,
        wisp.Signed,
        session_time * 60,
      )
      |> wisp.json_body(success)
    }
    Error(msg) -> {
      let error = json_util.message(msg)
      wisp.unprocessable_entity()
      |> wisp.json_body(error)
    }
  }
}
