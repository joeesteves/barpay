defmodule Barpay.MixProject do
  use Mix.Project

  def project do
    [
      app: :barpay,
      version: "0.2.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {Barpay.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:plug_cowboy, "~> 2.0"}, {:poison, "~> 3.1"} | deps_env()]
  end

  defp deps_env do
    case Mix.env() do
      :prod ->
        [
          {:mercado_pago, git: "https://github.com/ponyesteves/mercado_pago.git", tag: "v0.3.1"},
          {:teamplace, git: "https://github.com/ponyesteves/teamplace.git", tag: "v0.3.1"}
        ]

      _ ->
        [
          {:mercado_pago, path: "../mercado_pago"},
          {:teamplace, path: "../teamplace"}
        ]
    end
  end
end
