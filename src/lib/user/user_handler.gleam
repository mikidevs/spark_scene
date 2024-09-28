import app/web.{type Context}
import gleam/http.{Delete, Get, Post, Put}
import gleam/int
import gleam/result
import lib/user/model/register_user
import lib/user/model/update_user
import lib/user/model/user
import lib/user/user_data_access as user_db
import wisp.{type Request, type Response}

pub fn handle_request(
  path_segments: List(String),
  req: Request,
  ctx: Context,
) -> Response {
  case path_segments {
    [] ->
      case req.method {
        Get -> all(ctx)
        Post -> create(req, ctx)
        Put -> update(req, ctx)
        Delete -> wisp.not_found()
        _ -> wisp.method_not_allowed([Get, Post, Put, Delete])
      }
    [id] -> one(id, ctx)
    _ -> wisp.not_found()
  }
}

fn all(ctx: Context) -> Response {
  let users = user_db.all(ctx.db)
  wisp.ok()
  |> web.json_body(user.serialise_many(users))
}

fn one(id: String, ctx: Context) -> Response {
  let user_ =
    result.replace_error(int.parse(id), "Invalid Id")
    |> result.try(user_db.one(_, ctx.db))

  case user_ {
    Ok(user) ->
      wisp.created()
      |> web.json_body(user.serialise(user))
    Error(msg) ->
      wisp.unprocessable_entity()
      |> web.json_body(web.json_message(msg))
  }
}

fn create(req: Request, ctx: Context) -> Response {
  use reg_user <- web.json_guard(req, register_user.from_json)

  let user_ =
    register_user.validate(reg_user)
    |> result.try(user_db.save(_, ctx.db))

  case user_ {
    Ok(user) ->
      wisp.created()
      |> web.json_body(user.serialise(user))
    Error(msg) ->
      wisp.unprocessable_entity()
      |> web.json_body(web.json_message(msg))
  }
}

fn update(req: Request, ctx: Context) -> Response {
  use update_user <- web.json_guard(req, update_user.from_json)

  let msg =
    update_user.validate(update_user)
    |> result.try(user_db.update(_, ctx.db))
    |> result.replace("Updated Resource")

  case msg {
    Ok(msg) ->
      wisp.ok()
      |> web.json_body(web.json_message(msg))
    Error(msg) ->
      wisp.unprocessable_entity()
      |> web.json_body(web.json_message(msg))
  }
}
