import app/web.{type Context}
import gleam/http.{Delete, Get, Post, Put}
import gleam/int
import gleam/io
import gleam/result
import lib/user/model/create_user
import lib/user/model/update_user
import lib/user/model/user
import lib/user/user_data_access as user_da
import wisp.{type Request, type Response}

// /users
pub fn handle_request(
  ctx: Context,
  req: Request,
  path_segments: List(String),
) -> Response {
  case path_segments {
    [] ->
      case req.method {
        Get -> all(ctx, req)
        Post -> create(ctx, req)
        Put -> update(ctx, req)
        Delete -> wisp.not_found()
        _ -> wisp.method_not_allowed([Get, Post, Put, Delete])
      }
    [id] -> one(ctx, req, id)
    _ -> wisp.not_found()
  }
}

fn all(ctx: Context, req: Request) -> Response {
  use <- web.requires_auth(ctx, req)
  let users = user_da.all(ctx.db)
  wisp.ok()
  |> web.json_body(user.serialise_many(users))
}

fn one(ctx: Context, req: Request, id: String) -> Response {
  use <- web.requires_auth(ctx, req)
  let user_ =
    result.replace_error(int.parse(id), "Invalid Id")
    |> result.try(user_da.one(ctx.db, _))

  case user_ {
    Ok(user) ->
      wisp.created()
      |> web.json_body(user.serialise(user))
    Error(msg) ->
      wisp.unprocessable_entity()
      |> web.json_body(web.json_message(msg))
  }
}

fn create(ctx: Context, req: Request) -> Response {
  use create_user <- web.json_guard(req, create_user.from_json)
  io.debug(create_user)

  let user_ = create_user.validate(create_user)
  // |> result.try(user_db.save(ctx.db, _))

  case user_ {
    Ok(user) -> wisp.created()
    // |> web.json_body(user.serialise(user))
    Error(msg) ->
      wisp.unprocessable_entity()
      |> web.json_body(web.json_message(msg))
  }
}

fn update(ctx: Context, req: Request) -> Response {
  use <- web.requires_auth(ctx, req)
  use update_user <- web.json_guard(req, update_user.from_json)

  let msg_ =
    update_user.validate(update_user)
    |> result.try(user_da.update(ctx.db, _))
    |> result.replace("Updated Resource")

  case msg_ {
    Ok(msg) ->
      wisp.ok()
      |> web.json_body(web.json_message(msg))
    Error(msg) ->
      wisp.unprocessable_entity()
      |> web.json_body(web.json_message(msg))
  }
}
