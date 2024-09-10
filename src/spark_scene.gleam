import app/router
import app/web.{Context}
import dot_env/env
import gleam/erlang/process
import gleam/io
import gleam/option
import gleam/pgo
import mist
import radiate
import wisp
import wisp/wisp_mist

pub fn main() {
  let _ =
    radiate.new()
    |> radiate.add_dir("/mnt/c/Users/Miki/Dev/gleam/spark_scene")
    |> radiate.on_reload(fn(_state, path) {
      io.println("Change in " <> path <> ", reloading")
    })
    |> radiate.start()

  let db =
    pgo.connect(
      pgo.Config(
        ..pgo.default_config(),
        host: "localhost",
        user: "postgres",
        password: option.Some("postgres"),
        database: "spark_scene",
        pool_size: 15,
      ),
    )

  let secret_key = env.get_string_or("SPARK_SECRET_KEY", wisp.random_string(64))

  let ctx = Context(db: db)

  let assert Ok(_) =
    router.handle_request(_, ctx)
    |> wisp_mist.handler(secret_key)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  // TODO: Create a process that will clean up the tokens and sessions
  // https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#start and https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#sleep

  process.sleep_forever()
}
