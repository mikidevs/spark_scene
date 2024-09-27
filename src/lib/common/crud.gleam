import app/web.{type Context}
import gleam/http.{Delete, Get, Post, Put}
import lib/common/accessor.{type Accessor, type Create, type Read}
import lib/common/json_util
import wisp.{type Request, type Response}

pub fn entity_handler(
  path_segments: List(String),
  req: Request,
  ctx: Context,
  accessor: Accessor(data, entity),
) -> Response {
  case req.method {
    Get ->
      case path_segments {
        [] -> all(ctx, accessor.read)
        // [id] -> one(ctx, id, accessor.read)
        _ -> wisp.not_found()
      }
    Post -> create(req, ctx, accessor.create)
    Put -> wisp.ok()
    Delete -> wisp.ok()
    _ -> wisp.method_not_allowed([Get, Post, Put, Delete])
  }
}

fn all(ctx: Context, read: Read(entity)) -> Response {
  let entities = read.fetch(ctx.db)
  let body = read.many_serialiser(entities)
  wisp.ok()
  |> web.to_json_body(body)
}

fn create(req: Request, ctx: Context, create: Create(data, entity)) -> Response {
  use entity <- web.json_guard(req, create.decoder)
  case create.persist(ctx.db, entity) {
    Ok(entity) -> {
      let json = create.one_serialiser(entity)
      wisp.created()
      |> web.to_json_body(json)
    }
    Error(msg) -> {
      let error = json_util.message(msg)
      wisp.unprocessable_entity()
      |> wisp.json_body(error)
    }
  }
}
