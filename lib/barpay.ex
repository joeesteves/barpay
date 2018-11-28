defmodule Barpay do
  use Agent
  @sucursal Application.get_env(:barpay, :sucursal)
  @despachos_desde Application.get_env(:barpay, :despachos_desde)

  # Init method
  def start_link(_args) do
    loop()
  end

  def loop do
    get_pending_docs()
    |> Enum.each(fn %{"TOTAL" => total, "TRANSACCIONID" => id, "DOCUMENTO" => doc} ->
      create_link_and_code("Link de pago despacho #{doc}", "", total)
      |> post_link(id)

      IO.puts("Se genero el link de pago para #{doc}")

      :timer.seconds(5)
      |> :timer.sleep()
    end)

    IO.puts("No hay despachos pendientes para procesar.. ")
    IO.puts("Próximo chequeo en 10 segundos... ")

    :timer.seconds(10)
    |> :timer.sleep()

    loop()
  end

  def get_pending_docs do
    IO.puts("Buscando nuevos pedidos...")

    Application.get_env(:teamplace, :credentials)
    |> Teamplace.get_data("reports", "despachos", %{
      Empresa: @sucursal,
      FechaDesde: @despachos_desde,
      SoloPendientes: 1
    })
    |> Enum.take(10)
  end

  def create_link_and_code(title, description, amount) do
    IO.puts("Creando Link y código de pago...")

    case MercadoPago.get_link_and_rapipago_code(title, description, amount) do
      {:ok, link, code} -> {link, code}
      {:error, link} -> {link, "Error al generar código rapipago"}
      _ -> {"Error al generar el link", "Error al generar código rapipago"}
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
      FechaComprobante: today,
      Fecha: today,
      PersonaIDPropietario: "15",
      TransaccionTipoID: "CASOTEAMPLACE",
      TransaccionSubtipoID: "CB_ASIGN_LINK"
    }
    |> Poison.encode!()
  end

  defp today do
    Date.utc_today |> Date.to_iso8601
  end
end
