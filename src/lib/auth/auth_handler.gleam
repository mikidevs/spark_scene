import app/web.{type Context}
import birl
import birl/duration
import gleam/bool
import lib/auth/model/login_user
import lib/auth/model/session
import lib/auth/validations
import lib/common/json_util
import lib/user/user_data_access as user_db
import wisp.{type Request, type Response}

pub fn handle_request(
  path_segments: List(String),
  req: Request,
  ctx: Context,
) -> Response {
  case path_segments {
    ["login"] -> web.post(req, ctx, login)
    _ -> wisp.not_found()
  }
}

fn login(req: Request, ctx: Context) -> Response {
  use login_user <- web.json_guard(req, login_user.decode_from_json)
  wisp.ok()
  // use <- bool.lazy_guard(validations.is_valid_email_string(login_user.email), {
  //   let error = json_util.message("Invalid email address")
  //   wisp.unprocessable_entity()
  //   |> wisp.json_body(error)
  // })

  // case user_db.validation_user_by_email(ctx.db, login_user.email) {
  //   Ok(db_user) -> {
  //     use user <- web.validation_guard(
  //       login_user,
  //       db_user,
  //       validations.validate_login_user,
  //     )
  //     let session_time = 30
  //     let session_id =
  //       session.create(
  //         ctx.db,
  //         user.id,
  //         birl.now() |> birl.add(duration.minutes(session_time)),
  //       )
  //     let success = json_util.message("User login successful")
  //     wisp.ok()
  //     |> wisp.set_cookie(
  //       req,
  //       "AUTH_COOKIE",
  //       session_id,
  //       wisp.Signed,
  //       session_time * 60,
  //     )
  //     |> wisp.json_body(success)
  //   }
  //   Error(msg) -> {
  //     let error = json_util.message(msg)
  //     wisp.unprocessable_entity()
  //     |> wisp.json_body(error)
  //   }
  // }
}
