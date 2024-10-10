import app/web
import lib/shared/index_view
import lustre/attribute as a
import lustre/element
import lustre/element/html as h
import lustre_hx as hx
import wisp.{type Response}

fn page() -> web.Element {
  index_view.with_content([
    h.div([a.class("bg-ground h-screen")], [
      h.div([a.class("w-1/4 mx-auto pt-14")], [
        h.h1([a.class("text-2xl w-fit mx-auto mb-6")], [
          element.text("Welcome to Spark Scene"),
        ]),
        h.ul([a.class("flex flex-col gap-6")], [
          h.a(
            [
              a.href("/users/login"),
              a.class("spark-btn"),
              a.type_("button"),
              hx.target(hx.CssSelector("body")),
            ],
            [element.text("Login")],
          ),
          h.a(
            [
              a.href("/users/register"),
              a.class("spark-btn"),
              a.type_("button"),
              hx.target(hx.CssSelector("body")),
            ],
            [element.text("Register")],
          ),
        ]),
      ]),
    ]),
  ])
}

pub fn handle_request() -> Response {
  page() |> web.ok_html()
}
