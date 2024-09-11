import app/web.{type Context}
import gleam/http.{Get, Post}
import gleam/json
import gleam/list
import gleam/string_builder
import lib/common/json_util
import lib/user/domain/email
import lib/user/domain/user
import lib/user/service as user_service
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
    _ -> wisp.not_found()
  }
}

fn register(req: Request, ctx: Context) -> Response {
  use user_json <- wisp.require_json(req)
  case user_service.registration_from_json(user_json) {
    Ok(reg) -> {
      case email.is_valid(reg.email) {
        True -> {
          let error = json_util.error_message("Invalid email address")
          wisp.unprocessable_entity()
          |> wisp.json_body(error)
        }
        False ->
          case user_service.save_user(ctx.db, reg) {
            Ok(_) -> wisp.ok()
            Error(msg) -> {
              let error = json_util.error_message(msg)
              wisp.unprocessable_entity()
              |> wisp.json_body(error)
            }
          }
      }
    }
    Error(_) -> {
      let error = json_util.error_message("Invalid user submission")
      wisp.bad_request()
      |> wisp.json_body(error)
    }
  }
}

fn all(_: Request, ctx: Context) -> Response {
  let users = user_service.all_users(ctx.db)
  let users_json =
    users
    |> list.map(user.to_json)

  let body =
    json.object([#("users", json.preprocessed_array(users_json))])
    |> json.to_string
    |> string_builder.from_string

  wisp.ok()
  |> wisp.json_body(body)
}
