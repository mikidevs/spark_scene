import app/web.{type Context}
import lib/public/landing_view
import lib/session/session_handler
import lib/user/user_crud
import wisp.{type Request, type Response}

pub fn handle_request(ctx: Context, req: Request) -> Response {
  use ctx, req <- web.middleware(ctx, req)
  let path_segments = wisp.path_segments(req)

  case path_segments {
    [] -> landing_view.handle_request()
    ["session", ..rest] -> session_handler.handle_request(ctx, req, rest)
    ["users", ..rest] -> user_crud.handle_request(ctx, req, rest)
    _ -> wisp.not_found()
  }
}
