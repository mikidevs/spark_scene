import app/web.{type Element}
import lustre/attribute as attr
import lustre/element/html

fn head() -> Element {
  html.head([], [
    html.script(
      [
        attr.src("https://unpkg.com/htmx.org@2.0.1"),
        attr.attribute(
          "integrity",
          "sha384-QWGpdj554B4ETpJJC9z+ZHJcA/i59TyjxEPXiiUgN2WmTyV5OEZWCD6gQhgkdpB/",
        ),
        attr.attribute("crossorigin", "anonymous"),
      ],
      "",
    ),
    html.link([attr.rel("stylesheet"), attr.href("/static/tailwind_out.css")]),
    html.title([], "HTMX Testing in Gleam"),
  ])
}

pub fn index(children: List(Element)) -> Element {
  html.html([attr.attribute("lang", "en-US")], [head(), html.body([], children)])
}
