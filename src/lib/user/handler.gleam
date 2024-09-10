import app/web.{type Context}
import lib/common/json_util
import lib/user/service as user_service
import wisp.{type Request, type Response}

pub fn handle_request(
  path_segments: List(String),
  req: Request,
  ctx: Context,
) -> Response {
  case path_segments {
    ["register"] -> web.post(req, ctx, register)
    _ -> wisp.not_found()
  }
}

fn register(req: Request, ctx: Context) -> Response {
  use user_json <- wisp.require_json(req)
  case user_service.registration_from_json(user_json) {
    Ok(reg) -> {
      case user_service.save_user(ctx.db, reg) {
        Ok(_) -> wisp.ok()
        Error(msg) -> {
          let error = json_util.error_message(msg)
          wisp.internal_server_error()
          |> wisp.json_body(error)
        }
      }
    }
    Error(_) -> {
      let error = json_util.error_message("Invalid user submission")
      wisp.unprocessable_entity()
      |> wisp.json_body(error)
    }
  }
}
