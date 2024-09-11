import app/web.{type Context}
import gleam/dynamic
import gleam/http.{Get, Post}
import gleam/json
import gleam/list
import gleam/string_builder
import lib/common/json_util
import lib/user/data_access as user_db
import lib/user/types/email
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
        Get -> all(req, ctx)
        Post -> register(req, ctx)
        _ -> wisp.method_not_allowed([Get, Post])
      }
    ["login"] -> web.post(req, ctx, login)
    _ -> wisp.not_found()
  }
}

fn register(req: Request, ctx: Context) -> Response {
  use user_json <- wisp.require_json(req)
  use user <- require_json_register_user(user_json)
  use <- require_valid_email(user.email)
  case user_db.save_user_registration(ctx.db, user) {
    Ok(_) -> wisp.created()
    Error(msg) -> {
      let error = json_util.error_message(msg)
      wisp.unprocessable_entity()
      |> wisp.json_body(error)
    }
  }
}

fn login(req: Request, ctx: Context) -> Response {
  use user_json <- wisp.require_json(req)
  use login_user <- require_json_login_user(user_json)
  use <- require_valid_email(login_user.email)
  case user_db.login_user_by_email(ctx.db, login_user.email) {
    Ok(db_user) -> {
      case validations.validate_login_user(login_user, db_user) {
        Ok(_) -> wisp.ok()
        Error(msg) -> {
          let error = json_util.error_message(msg)
          wisp.unprocessable_entity()
          |> wisp.json_body(error)
        }
      }
    }
    Error(msg) -> {
      let error = json_util.error_message(msg)
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
    Ok(user) -> next(user)
    Error(_) -> {
      let error = json_util.error_message("Invalid registration submission")
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
    Ok(user) -> next(user)
    Error(_) -> {
      let error = json_util.error_message("Invalid login submission")
      wisp.bad_request()
      |> wisp.json_body(error)
    }
  }
}

fn require_valid_email(email: String, next: fn() -> Response) -> Response {
  case email.is_valid(email) {
    True -> next()
    False -> {
      let error = json_util.error_message("Invalid email address")
      wisp.unprocessable_entity()
      |> wisp.json_body(error)
    }
  }
}
