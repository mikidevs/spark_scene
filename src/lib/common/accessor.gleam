import gleam/dynamic
import gleam/json.{type Json}
import lib/common/db.{type Db}

pub type Create(data, entity) {
  Create(
    decoder: fn(dynamic.Dynamic) -> Result(data, String),
    persist: fn(Db, data) -> Result(entity, String),
    one_serialiser: fn(entity) -> Json,
  )
}

pub type Read(entity) {
  Read(
    fetch: fn(Db) -> List(entity),
    one_serialiser: fn(entity) -> Json,
    many_serialiser: fn(List(entity)) -> Json,
  )
}

pub type Accessor(data, entity) {
  Accessor(create: Create(data, entity), read: Read(entity))
}
