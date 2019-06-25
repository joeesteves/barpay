# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config
# PRUEBA39 es la sucursal para pruebas
# config :barpay, sucursal: "PRUEBA39"
# config :barpay, sucursal: "BAR41"

config :barpay, sucursal: System.get_env("BAR_SUCURSAL")
config :barpay, despachos_desde: "2019-06-24"

config :mercado_pago, client_id: System.get_env("MP_BAR_CLIENT_ID")
config :mercado_pago, client_secret: System.get_env("MP_BAR_CLIENT_SECRET")
config :mercado_pago, payment_methods: ["rapipago", "pagofacil"]
config :mercado_pago, no_reply_mail: "no-reply@barosario.org.ar"

config :teamplace,
  bcra_token: System.get_env("TEAMPLACE_BCRA_TOKEN")

config :teamplace,
  credentials: %{
    client_id: System.get_env("TEAMPLACE_CLIENT_ID"),
    client_secret: System.get_env("TEAMPLACE_CLIENT_SECRET")
  }

config :teamplace, api_base: "https://8.teamplace.finneg.com/BSA/api/"

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :barpay, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:barpay, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
###### USAR#####ADMINISTRADOR
# TODO: activar claves
## teamplace client_id :85f48e322f4f6e089b5e4de00705d47e
## teamplace secret :0afb88c1417d1d49b76361e1ccd7695f
