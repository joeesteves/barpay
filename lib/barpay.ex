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
  def start do
    # Implement worker login
    # check teamplace every 5 minutes and find ordenes de pago
    IO.puts(
      "CALLING MP"
      |> IO.puts()
    )

    :timer.sleep(20000)
    start
  end

  def get_pending_docs do
    Application.get_env(:teamplace, :credentials)
    |> Teamplace.get_data("reports", "despachos", %{Empresa: "PRUEBA39", FechaDesde: "2018-01-01"})
  end

  def create_link(title, description, amount) do
    MercadoPago.get_payment_link("TEST", "TEST", 1)
  end

  def post_link(transaccionid, link) do
    Application.get_env(:teamplace, :credentials)
    |> Teamplace.post_data("caso", create_caso(transaccionid, link))
  end

  defp create_caso(transaccionid, link) do
    %{
      Prioridad: "1",
      Titulo: transaccionid,
      Descripcion: link,
      FechaComprobante: "2018-10-18",
      Fecha: "2018-10-18",
      PersonaIDPropietario: "15",
      TransaccionTipoID: "CASOTEAMPLACE",
      TransaccionSubtipoID: "CB_ASIGN_LINK"
    }
    |> Poison.encode!()
  end
end
