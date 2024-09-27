import gleam/int
import gleam/result

pub opaque type Id(kind) {
  IntId(value: Int)
  StringId(value: String)
}

pub fn from_int(value: Int) {
  IntId(value)
}

pub fn from_string(value: String) {
  StringId(value)
}

pub fn show(id: Id(kind)) -> String {
  case id {
    IntId(val) -> int.to_string(val)
    StringId(val) -> val
  }
}

pub fn to_int(id: Id(kind)) -> Int {
  case id {
    IntId(val) -> val
    StringId(val) -> result.unwrap(int.parse(val), 0)
  }
}
