import birl
import birl/duration
import deps/cors_builder as cors
import gleam/dynamic.{type Dynamic}
import gleam/http.{Get, Post}
import gleam/json
import gleam/order
import gleam/result
import gleam/string_builder
import lib/auth/model/session.{type SessionError, Session}
import lib/auth/session_data_access as session_db
import lib/common/db.{type Db}
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

fn get_session_cookie(request: Request) {
  wisp.get_cookie(request, "AUTH_COOKIE", wisp.Signed)
  |> result.replace_error(session.SessionDoesNotExist)
}

/// If session expires in 10 minutes, add 20 minutes to the session expiration
fn validate_cookie(db: Db, session_id: String) -> Result(Nil, SessionError) {
  use session <- result.try(session_db.session_by_id(db, session_id))
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
    _ -> Error(session.SessionExpired)
  }
}

pub fn json_message(message: String) -> json.Json {
  json.object([#("message", json.string(message))])
}

pub fn json_body(response: Response, json: json.Json) {
  json
  |> json.to_string_builder()
  |> wisp.json_body(response, _)
}

/// Checks the request session cookie and validates it
pub fn requires_auth(
  request: Request,
  context: Context,
  handler: fn(Request, Context) -> Response,
) -> Response {
  {
    use session_id <- result.try(get_session_cookie(request))
    use _ <- result.try(validate_cookie(context.db, session_id))
    use _ <- result.try(session.destroy(context.db, session_id))
    Ok(handler(request, context))
  }
  |> result.map_error(fn(session_error) {
    let msg = case session_error {
      session.SessionExpired ->
        json_message("Your session has expired, please login again")
      _ -> json_message("You are not logged in")
    }

    unauthorized()
    |> json_body(msg)
  })
  |> result.unwrap_both
}

/// Tries to decode json and returns a bad request when the json is invalid
pub fn json_guard(
  req: Request,
  decoder: fn(Dynamic) -> Result(a, String),
  handler: fn(a) -> Response,
) -> Response {
  use json <- wisp.require_json(req)
  case decoder(json) {
    Ok(t) -> handler(t)
    Error(msg) ->
      wisp.bad_request()
      |> json_body(json_message(msg))
  }
}
