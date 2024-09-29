import app/web.{type Context}
import lib/auth/auth_handler
import lib/user/user_handler
import wisp.{type Request, type Response}

pub fn handle_request(ctx: Context, req: Request) -> Response {
  use ctx, req <- web.middleware(ctx, req)
  let path_segments = wisp.path_segments(req)

  case path_segments {
    ["api", "users", ..rest] -> user_handler.handle_request(ctx, req, rest)
    ["api", "auth", ..rest] -> auth_handler.handle_request(ctx, req, rest)
    _ -> wisp.not_found()
  }
}
