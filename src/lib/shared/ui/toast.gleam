import app/web
import gleam/option
import lustre/attribute as a
import lustre/element
import lustre/element/html as h
import lustre_hx as hx

pub type Toast {
  Success
  Error
}

// a.att("hx-swap-oob", "beforeend")
pub fn create(variant: Toast, msg: String) -> web.Element {
  h.div(
    [
      a.id("toast-container"),
      hx.swap(hx.Beforeend, option.None),
      a.class("border border-surface-200 rounded-lg shadow p-4"),
      case variant {
        Success -> a.class("bg-success")
        Error -> a.class("bg-error")
      },
    ],
    [
      h.div([a.class("text-xl")], [
        case variant {
          Success -> element.text("Success")
          Error -> element.text("Error")
        },
      ]),
      element.text(msg),
    ],
  )
}
