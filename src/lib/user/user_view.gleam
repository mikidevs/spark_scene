import app/web.{type Context}
import lib/shared/htmx
import lustre/attribute as a
import lustre/element
import lustre/element/html as h
import lustre_hx as hx
import wisp.{type Request, type Response}

pub fn handle_request(
  ctx: Context,
  req: Request,
  path_segments: List(String),
) -> Response {
  case path_segments {
    ["register"] -> web.get(ctx, req, register)
    ["login"] -> web.get(ctx, req, login)
    _ -> wisp.not_found()
  }
}

fn register_page() -> web.Element {
  htmx.index([
    h.div([a.class("bg-ground h-screen flex items-center justify-center")], [
      h.div([a.class("bg-surface-100 w-1/4 p-5 rounded")], [
        h.div([a.class("font-bold text-4xl mb-5")], [
          element.text("Create an account"),
        ]),
        h.div([a.class("mb-5 text-grey")], [
          element.text("Already have an account? "),
          h.a([a.class("spark-link"), hx.get("/login")], [
            element.text("Log in"),
          ]),
        ]),
      ]),
    ]),
  ])
}

fn register(_: Context, _: Request) -> Response {
  wisp.ok()
  |> web.html_body(register_page())
}

fn login(ctx: Context, req: Request) -> Response {
  todo
}
