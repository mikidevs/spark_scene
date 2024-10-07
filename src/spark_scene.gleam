import app/router
import app/web.{Context}
import dot_env/env
import filespy
import gleam/erlang/process
import gleam/io
import gleam/option
import gleam/pgo
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  let _res =
    filespy.new()
    |> filespy.add_dir(".")
    |> filespy.add_dir("/mnt")
    |> filespy.set_handler(fn(path, event) {
      io.debug(#(path, event))
      Nil
    })
    |> filespy.start()

  let db =
    pgo.connect(
      pgo.Config(
        ..pgo.default_config(),
        host: "localhost",
        user: "postgres",
        port: 5555,
        password: option.Some("postgres"),
        database: "spark_scene",
        pool_size: 15,
      ),
    )

  let assert Ok(priv_directory) = wisp.priv_directory("spark_scene")

  let ctx = Context(db: db, static_directory: priv_directory <> "/static")

  let secret_key = env.get_string_or("SPARK_SECRET_KEY", wisp.random_string(64))

  let assert Ok(_) =
    router.handle_request(ctx, _)
    |> wisp_mist.handler(secret_key)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  // TODO: Create a process that will clean up the tokens and sessions
  // https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#start and https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#sleep

  process.sleep_forever()
}
