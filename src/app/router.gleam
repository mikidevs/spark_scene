import app/web.{type Context}
import lib/auth/auth_handler
import lib/user/user_handler
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req, ctx <- web.middleware(req, ctx)
  let path_segments = wisp.path_segments(req)

  case path_segments {
    ["api", "users", ..rest] -> user_handler.handle_request(rest, req, ctx)
    ["api", "auth", ..rest] -> auth_handler.handle_request(rest, req, ctx)
    _ -> wisp.not_found()
  }
}
