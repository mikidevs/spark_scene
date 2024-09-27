import app/web.{type Context}
import gleam/dynamic
import gleam/http.{Delete, Get, Post, Put}
import gleam/json
import lib/common/db.{type Db}

import wisp.{type Request, type Response}

pub type Create(data, entity) {
  Create(
    db: Db,
    decoder: fn(dynamic.Dynamic) -> Result(data, string),
    persist: fn(Db, data) -> Result(entity, String),
    one_serialiser: fn(entity) -> json.Json,
  )
}

pub type Read(data, entity) {
  Read(
    db: Db,
    one_serialiser: fn(data) -> json.Json,
    many_serialiser: fn(List(data)) -> json.Json,
    fetch: fn(Db) -> List(entity),
  )
}

pub type Accessor(data, entity) {
  Accessor(
    create: Create,
    read: Read,
    // update: fn(db.Db, a) -> a,
    // delete: fn(db.Db, i) -> Nil
  )
}

pub fn crud_handler(
  path_segments: List(String),
  req: Request,
  ctx: Context,
  accessor: Accessor(data, entity),
) -> Response {
  case req.method {
    Get ->
      case path_segments {
        [] -> all(ctx, accessor.read)
        [id] -> one(ctx, id, accessor.read)
        _ -> wisp.not_found()
      }
    Post -> create(req, ctx, accessor: Create)
    Put -> wisp.ok()
    Delete -> wisp.ok()
    _ -> wisp.method_not_allowed([Get, Post, Put, Delete])
  }
}

fn all(ctx: Context, accessor: Read) -> Response {
  let entity = get_entity(ctx.db)
  let body = serialiser(entity)
  wisp.ok()
  |> web.to_json_body(body)
}

fn create(req: Request, ctx: Context, accessor: Create) -> Response {
  use request_body <- wisp.require_json(req)
  use entity <- web.json_guard(request_body, accessor.decoder)
  case accessor.persist(ctx.db) {
    Ok(entity) -> {
      let json = accessor.one_serialiser(entity)

      wisp.created()
      |> web.to_json_body(json)
    }
  }
}
