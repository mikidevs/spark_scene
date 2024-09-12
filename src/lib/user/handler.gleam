import app/web.{type Context}
import birl
import birl/duration
import gleam/dynamic
import gleam/http.{Get, Post}
import gleam/json
import gleam/list
import gleam/string_builder
import lib/common/json_util
import lib/session/session
import lib/user/data_access as user_db
import lib/user/types/login_user
import lib/user/types/register_user
import lib/user/types/user
import lib/user/validations
import wisp.{type Request, type Response}

pub fn handle_request(
  path_segments: List(String),
  req: Request,
  ctx: Context,
) -> Response {
  case path_segments {
    [] ->
      case req.method {
        Post -> register(req, ctx)
        Get -> web.requires_auth(req, ctx, all)
        _ -> wisp.method_not_allowed([Get, Post])
      }
    ["login"] -> web.post(req, ctx, login)
    _ -> wisp.not_found()
  }
}

fn register(req: Request, ctx: Context) -> Response {
  use user_json <- wisp.require_json(req)
  use user <- require_json_register_user(user_json)
  case user_db.save_user_registration(ctx.db, user) {
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
  use user <- require_json_login_user(user_json)
  case user_db.user_by_email(ctx.db, user.email) {
    Ok(db_user) -> {
      case validations.validate_login_user(user, db_user) {
        Ok(_) -> {
          let session_time = 30
          let session_id =
            session.create(
              ctx.db,
              db_user.id,
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
    Error(msg) -> {
      let error = json_util.message(msg)
      wisp.bad_request()
      |> wisp.json_body(error)
    }
  }
}

fn all(_: Request, ctx: Context) -> Response {
  let users = user_db.all_users(ctx.db)
  let users_json =
    users
    |> list.map(user.encode_to_json)

  let body =
    json.object([#("users", json.preprocessed_array(users_json))])
    |> json.to_string
    |> string_builder.from_string

  wisp.ok()
  |> wisp.json_body(body)
}

fn require_json_register_user(
  user_json: dynamic.Dynamic,
  next: fn(register_user.RegisterUser) -> Response,
) -> Response {
  case register_user.decode_from_json(user_json) {
    Ok(user) -> {
      use <- require_valid_email_string(user.email)
      next(user)
    }
    Error(_) -> {
      let error = json_util.message("Invalid registration submission")
      wisp.bad_request()
      |> wisp.json_body(error)
    }
  }
}

fn require_json_login_user(
  user_json: dynamic.Dynamic,
  next: fn(login_user.LoginUser) -> Response,
) -> Response {
  case login_user.decode_from_json(user_json) {
    Ok(user) -> {
      use <- require_valid_email_string(user.email.value)
      next(user)
    }
    Error(_) -> {
      let error = json_util.message("Invalid login submission")
      wisp.bad_request()
      |> wisp.json_body(error)
    }
  }
}

fn require_valid_email_string(email: String, next: fn() -> Response) -> Response {
  case validations.is_valid_email_string(email) {
    True -> next()
    False -> {
      let error = json_util.message("Invalid email address")
      wisp.unprocessable_entity()
      |> wisp.json_body(error)
    }
  }
}
