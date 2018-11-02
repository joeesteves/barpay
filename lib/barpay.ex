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
    get_pending_docs
    |> Enum.each(fn %{"TOTAL" => total, "TRANSACCIONID" => id, "DOCUMENTO" => doc} ->
      create_link_and_code("Link de pago despacho #{doc}", "", total)
      |> post_link(id)

      IO.puts("Se genero el link de pago para #{doc}")

      :timer.seconds(5)
      |> :timer.sleep
    end)
    IO.puts("No hay despachos pendientes para procesar.. ")
    IO.puts("Proximo chequeo en 15 segundos... ")

    :timer.seconds(15)
    |> :timer.sleep

  end

  def get_pending_docs do
    Application.get_env(:teamplace, :credentials)
    |> Teamplace.get_data("reports", "despachos", %{Empresa: "PRUEBA39", FechaDesde: "2018-11-01", SoloPendientes: 1})
  end

  def create_link_and_code(title, description, amount) do
    case MercadoPago.get_link_and_rapipago_code(title, description, amount) do
      {:ok, link, code} -> {link, code}
      {:error, link } -> {link, "Error al generar código rapipago"}
    end
  end

  def post_link(data, transaccionid) do
    Application.get_env(:teamplace, :credentials)
    |> Teamplace.post_data("caso", create_caso(transaccionid, data))

  end

  defp create_caso(transaccionid, {link, code}) do
    %{
      Prioridad: "1",
      Titulo: transaccionid,
      Descripcion: link,
      Rapipago: code,
      FechaComprobante: "2018-10-18",
      Fecha: "2018-10-18",
      PersonaIDPropietario: "15",
      TransaccionTipoID: "CASOTEAMPLACE",
      TransaccionSubtipoID: "CB_ASIGN_LINK"
    }
    |> Poison.encode!()
  end
end
