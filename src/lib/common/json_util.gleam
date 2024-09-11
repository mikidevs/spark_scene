import gleam/json
import gleam/string_builder

pub fn message(message: String) -> string_builder.StringBuilder {
  json.object([#("message", json.string(message))])
  |> json.to_string_builder
}
