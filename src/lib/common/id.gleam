pub opaque type Id(kind) {
  IntId(value: Int)
  StringId(value: String)
}

pub fn from_int(value: Int) {
  IntId(value)
}

pub fn from_string(value: Int) {
  StringId(value)
}

pub fn show(id: Id(kind)) -> String {
  case id {
    IntId(val) -> int.to_string(val)
    StringId(val) -> val
  }
}
