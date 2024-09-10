import gleam/http.{Get, Post}
import lib/common/db.{type Db}
import wisp.{type Request, type Response}

pub type Context {
  Context(db: Db)
}

pub fn middleware(
  req: Request,
  ctx: Context,
  handle_request: fn(Request, Context) -> Response,
) {
  let req = wisp.method_override(req)

  use <- wisp.log_request(req)

  use <- wisp.rescue_crashes()

  use req <- wisp.handle_head(req)

  handle_request(req, ctx)
}

pub fn get(
  req: Request,
  context: Context,
  handler: fn(Request, Context) -> Response,
) {
  case req.method {
    http.Get -> handler(req, context)
    _ -> wisp.method_not_allowed([Get])
  }
}

pub fn post(
  req: Request,
  context: Context,
  handler: fn(Request, Context) -> Response,
) {
  case req.method {
    http.Post -> handler(req, context)
    _ -> wisp.method_not_allowed([Post])
  }
}
