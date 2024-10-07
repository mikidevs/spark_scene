import app/web
import lib/shared/htmx
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import wisp.{type Response}

fn page() -> web.Element {
  htmx.index([html.div([attr.class("text-red-500")], [element.text("Hello")])])
}

pub fn handle_request() -> Response {
  wisp.ok()
  |> web.html_body(page())
}
