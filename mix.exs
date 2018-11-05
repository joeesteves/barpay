defmodule Barpay.MixProject do
  use Mix.Project

  def project do
    [
      app: :barpay,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Barpay.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    case  Mix.env do
      "prod" ->
        [
          {:mercado_pago, git: "https://github.com/ponyesteves/mercado_pago.git", tag: "v0.2.2"},
          {:teamplace, git: "https://github.com/ponyesteves/teamplace.git", tag: "v0.1.0"},
          {:poison, "~> 3.1"}
          # {:dep_from_hexpm, "~> 0.3.0"},
          # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
        ]

      _ ->
        [
          {:mercado_pago, path: "../mercado_pago"},
          {:teamplace, path: "../teamplace"},
          {:poison, "~> 3.1"}
        ]
    end
  end
end
