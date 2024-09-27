import app/web.{type Context}
import lib/common/accessor.{Accessor, Create, Read}
import lib/common/crud
import lib/user/model/register_user
import lib/user/model/user
import lib/user/user_repository as user_repo
import wisp.{type Request, type Response}

pub fn handle_request(
  path_segments: List(String),
  req: Request,
  ctx: Context,
) -> Response {
  let user_accessor =
    Accessor(
      Create(
        decoder: register_user.from_json,
        persist: user_repo.save,
        one_serialiser: user.serialise,
      ),
      Read(
        fetch: user_repo.all,
        one_serialiser: user.serialise,
        many_serialiser: user.serialise_many,
      ),
    )

  case path_segments {
    [] -> crud.entity_handler(path_segments, req, ctx, user_accessor)
    _ -> wisp.not_found()
  }
}
