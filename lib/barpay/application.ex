defmodule Barpay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    IO.puts("Comenzando...")
    # # List all child processes to be supervised
    children = [
      # Starts a worker by calling: MercadoPago.Worker.start_link(arg)
      {Barpay.Preferences, []},
      {Barpay.Queue, []},
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Barpay.Endpoint,
        options: [port: Application.get_env(:barpay, :port) || 4201]
        ),
      {Barpay.Cobranza, []},
    ]

    # # # See https://hexdocs.pm/elixir/Supervisor.html
    # # # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Barpay.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
