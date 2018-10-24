defmodule Barpay do
  @moduledoc """
  Documentation for Barpay.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Barpay.hello
      :world

  """
  def hello do
    #Implement worker login
    # check teamplace every 5 minutes and find ordenes de pago
    IO.puts "CALLING MP"
    |> IO.puts
    :timer.sleep(20000)
    hello
  end

  def get_pending_docs do
    Application.get_env(:teamplace, :credentials)
    |> IO.inspect
    |> Teamplace.get_data("reports", "despachos", %{Empresa: "PRUEBA39", FechaDesde: "2018-01-01"})
  end

  def create_link(title, description, amount) do
    MercadoPago.get_payment_link("TEST", "TEST", 1)

  end
end


# %{
#   Prioridad:1,
#   Descripcion: build_description(order.desc, order.user, order.machine.name),
#   Titulo: order.title,
#   FechaComprobante: order.date,
#   Fecha: order.date,
#   PersonaIDPropietario:"413",
#   TransaccionTipoID: "CASOTEAMPLACE",  #IMPORTANTE
#   TransaccionSubtipoID:"CB_ASIGN_LINK",  # CODIGO DEL BPM
#   MaquinaCodigo: order.machine_id
#   }
#   |>Poison.encode!()

# WORKING VERSION FROM POSTMAN
# {
#   "Prioridad": "1",
#   "Descripcion": "prueba - prueba",
#   "Titulo": "6250",
#   "FechaComprobante": "2018-10-18",
#   "Fecha": "2018-10-18",
#   "PersonaIDPropietario":"15",
#   "TransaccionTipoID": "CASOTEAMPLACE",
#   "TransaccionSubtipoID":"CB_ASIGN_LINK"
# }
