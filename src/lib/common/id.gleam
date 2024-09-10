import gluid

pub opaque type Id {
  Id(val: String)
}

pub fn new_id() -> Id {
  Id(gluid.guidv4())
}

pub fn unwrap(id: Id) -> String {
  id.val
}

pub fn wrap(val: String) -> Id {
  Id(val)
}
