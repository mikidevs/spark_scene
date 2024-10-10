import app/web.{type Element}
import lustre/attribute as a
import lustre/element/html

fn head() -> Element {
  html.head([], [
    html.script(
      [
        a.src("https://unpkg.com/htmx.org@2.0.1"),
        a.attribute(
          "integrity",
          "sha384-QWGpdj554B4ETpJJC9z+ZHJcA/i59TyjxEPXiiUgN2WmTyV5OEZWCD6gQhgkdpB/",
        ),
        a.attribute("crossorigin", "anonymous"),
      ],
      "",
    ),
    html.link([a.rel("stylesheet"), a.href("/static/tailwind_out.css")]),
    html.title([], "HTMX Testing in Gleam"),
  ])
}

pub fn with_content(children: List(Element)) -> Element {
  html.html([a.attribute("lang", "en-US")], [
    head(),
    html.body([], [
      html.div(
        [
          a.id("toast-container"),
          a.class("absolute top-6 right-6 items-center flex flex-col gap-4"),
        ],
        [],
      ),
      ..children
    ]),
  ])
}
