# Barpay

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `barpay` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:barpay, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/barpay](https://hexdocs.pm/barpay).

# Logging Utils for app as linux service

journalctl -f -u barpay.service

Si el log no se encuntra ahí otra alternativa es buscarlo
día actual /var/log/syslog
día anterior /var/log/syslog.1

especifico para elixir apps
cat /var/log/syslog.1 | grep mix
