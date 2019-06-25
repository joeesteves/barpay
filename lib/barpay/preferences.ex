defmodule Barpay.Preferences do
  use GenServer
  @sucursal Application.get_env(:barpay, :sucursal)
  @despachos_desde Application.get_env(:barpay, :despachos_desde)

  # Init method
  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(args) do
    {:ok, args, {:continue, :start_process}}
  end

  def next_process(time \\ 0) do
    Process.send_after(__MODULE__, :process_pending_docs, time)
  end

  def schedule do
    next_process(10_000)
    IO.puts("No hay despachos pendientes para procesar.. ")
    IO.puts("Próximo chequeo en 10 segundos... ")
  end

  def handle_continue(:start_process, state) do
    next_process
    {:noreply, state}
  end

  # due to bug on systemctl inistance.. :()
  def handle_info({:ssl_closed, _msg}, state), do: {:noreply, state}

  def handle_info(:process_pending_docs, state) do
    process_pending_docs()
    schedule()
    {:noreply, state}
  end

  defp process_pending_docs do
    get_pending_docs()
    |> Enum.each(&process_doc/1)
  end

  defp get_pending_docs do
    IO.puts("Buscando nuevos pedidos...")

    Application.get_env(:teamplace, :credentials)
    |> Teamplace.get_data("reports", "despachos", %{
      Empresa: @sucursal,
      FechaDesde: @despachos_desde,
      SoloPendientes: 1
    })
    |> Enum.take(10)
  end

  defp process_doc(%{
         "TOTAL" => total,
         "TRANSACCIONID" => id,
         "DOCUMENTO" => doc,
         "CLIENTE" => cliente,
         "CLIENTECODIGO" => cliente_codigo
       }) do
    title = "Link de pago despacho #{doc} ** #{cliente_codigo} - #{cliente}"

    create_link_and_code(title, "", total)
    |> post_link(id)

    IO.puts("Se genero el link de pago para #{doc}")

    :timer.seconds(5)
    |> :timer.sleep()
  end

  defp process_doc(error) do
    IO.puts("Hubo un error con Teamplace... esperando 5 minutos para reintentar...")
    IO.inspect(error)

    :timer.minutes(5)
    |> :timer.sleep()

    next_process()
  end

  defp create_link_and_code(title, description, amount) do
    IO.puts("Creando Link y código de pago...")

    case MercadoPago.get_link_and_rapipago_code(title, description, amount) do
      {:ok, link, code} -> {link, code}
      {:error, link} -> {link, "Error al generar código rapipago"}
      _ -> {"Error al generar el link", "Error al generar código rapipago"}
    end
  end

  defp post_link(data, transaccionid) do
    Application.get_env(:teamplace, :credentials)
    |> Teamplace.post_data("caso", create_caso(transaccionid, data))
  end

  defp create_caso(transaccionid, {link, code}) do
    %{
      Prioridad: "1",
      Titulo: transaccionid,
      Descripcion: link,
      Rapipago: code,
      FechaComprobante: today(),
      Fecha: today(),
      PersonaIDPropietario: "15",
      TransaccionTipoID: "CASOTEAMPLACE",
      TransaccionSubtipoID: "CB_ASIGN_LINK"
    }
    |> Poison.encode!()
  end

  defp today do
    Date.utc_today() |> Date.to_iso8601()
  end
end
