import birl
import birl/duration
import deps/cors_builder as cors
import gleam/http.{Get, Post}
import gleam/order
import gleam/string_builder
import lib/common/db.{type Db}
import lib/session/data_access as session_db
import lib/session/session
import wisp.{type Request, type Response}

pub type Context {
  Context(db: Db)
}

fn cors() {
  cors.new()
  |> cors.allow_origin("http://localhost:1234")
  |> cors.allow_method(Get)
  |> cors.allow_method(Post)
  |> cors.allow_header("content-type")
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

  use req <- cors.wisp_middleware(req, cors())

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

fn unauthorized() {
  wisp.html_response(string_builder.new(), 401)
}

type SessionError {
  SessionExpired
  SessionDoesNotExist
}

/// If session expires in 10 minutes, add 20 minutes to the session expiration
fn validate_cookie(db: Db, session_id: String) -> Result(Nil, SessionError) {
  case session_db.session_by_id(db, session_id) {
    Ok(session) -> {
      let session.Session(session_id, _, expiration_time) = session
      case birl.compare(expiration_time, birl.now()) {
        order.Gt | order.Eq -> {
          case
            birl.difference(expiration_time, birl.now())
            |> duration.compare(duration.minutes(10))
          {
            order.Lt | order.Eq -> {
              birl.now()
              |> birl.add(duration.minutes(20))
              |> session.update(db, session_id, _)
              Ok(Nil)
            }
            _ -> Ok(Nil)
          }
        }
        _ -> Error(SessionExpired)
      }
    }
    _ -> Error(SessionDoesNotExist)
  }
}

pub fn requires_auth(
  request: Request,
  context: Context,
  handler: fn(Request, Context) -> Response,
) -> Response {
  case wisp.get_cookie(request, "AUTH_COOKIE", wisp.Signed) {
    Ok(session_id) -> {
      case validate_cookie(context.db, session_id) {
        Ok(_) -> handler(request, context)
        Error(SessionExpired) -> {
          let _ = session.destroy(context.db, session_id)
          unauthorized()
        }
        Error(SessionDoesNotExist) -> unauthorized()
      }
      handler(request, context)
    }
    Error(_) -> unauthorized()
  }
}
