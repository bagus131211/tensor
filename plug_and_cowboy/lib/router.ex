defmodule PlugAndCowboy.Router do
  use Plug.Router

  plug :match
  plug :dispatch
  plug Plug.Static, at: "/home", from: :server

  get "/", do: send_resp(conn, 200, "Hello there!")

  get "/home", do:
    conn |> put_resp_content_type("text/html") |> send_file(200, "lib/index.html")

  get "/about/:username", do: send_resp(conn, 200, "Hello #{username}")

  match _, do: send_resp(conn, 404, "404 error not found!")
end
