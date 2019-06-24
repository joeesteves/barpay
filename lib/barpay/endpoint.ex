defmodule Barpay.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get("/ping") do
    send_resp(conn, 200, "Pong! ;)")
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
