defmodule Barpay.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get("/ipn") do
    case conn.query_params do
      %{"id" => id} ->
        Barpay.Queue.put(id)
      _ ->
        IO.puts("IPN from mercado pago missing id")
    end

    send_resp(conn, 200, "Pong! ;)")
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
