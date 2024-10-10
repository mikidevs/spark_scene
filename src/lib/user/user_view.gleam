import app/web.{type Element}
import lib/shared/index_view
import lustre/attribute as a
import lustre/element
import lustre/element/html as h
import lustre_hx as hx

pub fn register() -> Element {
  index_view.with_content([
    h.div([a.class("bg-ground h-screen flex items-center justify-center")], [
      h.div([a.class("bg-surface-100 w-1/3 p-5 rounded")], [
        h.div([a.class("font-bold text-4xl mb-5")], [
          element.text("Create an account"),
        ]),
        h.div([a.class("mb-5 text-grey")], [
          element.text("Already have an account? "),
          h.a([a.class("spark-link"), hx.get("/login")], [
            element.text("Log in"),
          ]),
        ]),
        h.form([a.class("flex flex-col gap-6 pb-5"), hx.post("/users")], [
          h.div([], [
            h.label([a.for("full-name"), a.class("block pb-2")], [
              element.text("User name"),
            ]),
            h.input([
              a.id("full-name"),
              a.placeholder("Name Surname"),
              a.type_("text"),
              a.class("spark-input"),
            ]),
          ]),
          h.div([], [
            h.label([a.for("email"), a.class("block pb-2")], [
              element.text("Email"),
            ]),
            h.input([
              a.id("email"),
              a.placeholder("Email"),
              a.type_("email"),
              a.class("spark-input"),
            ]),
          ]),
          h.div([], [
            h.label([a.for("password"), a.class("block pb-2")], [
              element.text("Password"),
            ]),
            h.input([
              a.id("password"),
              a.placeholder("•••••••••"),
              a.type_("password"),
              a.class("spark-input"),
            ]),
          ]),
          h.div([], [
            h.label([a.for("confirm-password"), a.class("block pb-2")], [
              element.text("Confirm Password"),
            ]),
            h.input([
              a.id("confirm-password"),
              a.placeholder("•••••••••"),
              a.type_("password"),
              a.class("spark-input"),
            ]),
          ]),
          h.button([a.class("spark-btn"), a.type_("submit")], [
            element.text("Create Account"),
          ]),
        ]),
      ]),
    ]),
  ])
}

pub fn login() -> Element {
  index_view.with_content([h.div([], [element.text("login")])])
}
