import gluid

pub opaque type Id {
  Id(value: String)
}

pub fn new_id() -> Id {
  Id(gluid.guidv4())
}

pub fn unwrap(id: Id) -> String {
  id.value
}

pub fn wrap(value: String) -> Id {
  Id(value)
}
