import app/web.{type Context}
import gleam/http.{Delete, Get, Post, Put}
import gleam/int
import gleam/io
import gleam/result
import lib/shared/ui/toast
import lib/user/model/create_user
import lib/user/model/update_user
import lib/user/model/user
import lib/user/user_data_access as user_da
import lib/user/user_view
import lustre/element
import wisp.{type Request, type Response}

// /users
pub fn handle_request(
  ctx: Context,
  req: Request,
  path_segments: List(String),
) -> Response {
  case path_segments {
    [] ->
      case req.method {
        Get -> all(ctx, req)
        Post -> create(ctx, req)
        Put -> update(ctx, req)
        Delete -> wisp.not_found()
        _ -> wisp.method_not_allowed([Get, Post, Put, Delete])
      }
    ["register"] -> web.get(ctx, req, register)
    ["login"] -> web.get(ctx, req, login)
    [id] -> one(ctx, req, id)
    _ -> wisp.not_found()
  }
}

fn register(_: Context, _: Request) -> Response {
  user_view.register()
  |> web.ok_html()
}

fn login(_: Context, _: Request) -> Response {
  user_view.register()
  |> web.ok_html()
}

fn all(ctx: Context, req: Request) -> Response {
  use <- web.requires_auth(ctx, req)
  let users = user_da.all(ctx.db)
  wisp.ok()
}

fn one(ctx: Context, req: Request, id: String) -> Response {
  use <- web.requires_auth(ctx, req)
  let user_ =
    result.replace_error(int.parse(id), "Invalid Id")
    |> result.try(user_da.one(ctx.db, _))

  case user_ {
    Ok(user) -> wisp.created()
    Error(msg) -> wisp.unprocessable_entity()
  }
}

fn create(ctx: Context, req: Request) -> Response {
  use user_ <- web.form_guard(req, create_user.from_form_data)
  io.debug(user_)
  let toast =
    toast.create(toast.Success, "User successfully registered!")
    |> element.to_document_string_builder()

  wisp.created()
  |> wisp.html_body(toast)
  |> wisp.set_header("hx-push-url", "login")
  // case user_da.save(ctx.db, user_) {
  //   Ok(user) -> wisp.created()
  //   Error(msg) -> wisp.unprocessable_entity()
  // }
}

fn update(ctx: Context, req: Request) -> Response {
  use <- web.requires_auth(ctx, req)
  // use update_user <- web.json_guard(req, update_user.from_json)

  // let msg_ =
  //   update_user.validate(update_user)
  //   |> result.try(user_da.update(ctx.db, _))
  //   |> result.replace("Updated Resource")

  // case msg_ {
  //   Ok(msg) -> wisp.ok()
  //   Error(msg) -> wisp.unprocessable_entity()
  // }
  wisp.ok()
}
