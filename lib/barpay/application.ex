defmodule Barpay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    IO.puts("Comenzando...")
    # # List all child processes to be supervised
    plug_cowboy =
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Barpay.Endpoint,
        options: [port: 4201]
      )

    children = [
      # Starts a worker by calling: MercadoPago.Worker.start_link(arg)
      Barpay.Preferences,
      Barpay.Queue,
      plug_cowboy,
      Barpay.Cobranza
    ]

    # # # See https://hexdocs.pm/elixir/Supervisor.html
    # # # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Barpay.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
