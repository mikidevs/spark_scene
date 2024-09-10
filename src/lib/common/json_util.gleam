import gleam/json
import gleam/string_builder

pub fn error_message(message: String) -> string_builder.StringBuilder {
  json.object([#("message", json.string(message))])
  |> json.to_string_builder
}
