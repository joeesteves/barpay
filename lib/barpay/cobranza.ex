defmodule Barpay.Cobranza do
  use GenServer
  alias Teamplace.Cobranza
  alias Teamplace.Cobranza.{Banco, Otros, CtaCte, Cotizacion}

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(args) do
    {:ok, args, {:continue, :start_checking_queue}}
  end

  def direct_check_queue do
    schedule(0)
  end

  def handle_continue(:start_checking_queue, state) do
    schedule(3_000)
    {:noreply, state}
  end

  def handle_info(:check_queue, state) do
    check_queue
    {:noreply, state}
  end

  defp schedule(time) do
    Process.send_after(__MODULE__, :check_queue, time)
  end

  defp check_queue do
    IO.puts("Chequeando pagos aprobados para enviar a Teamplace...")

    case Barpay.Queue.get() do
      nil ->
        IO.puts "No hay pagos pendientes de carga"
        false
      id ->
        IO.puts "Cargando pago #{id} en teamplace"
        post_pipeline(id)
    end
  end

  defp post_pipeline(id) do
    post_result =
      MercadoPago.get_payment(id)
      |> parse_payment
      |> build_teamplace_payment(id)
      |> post_payment_to_teamplace

    case post_result do
      {:error, _} ->
        Barpay.Queue.put(id)

      x ->
        x
    end
  end

  defp parse_payment(payment_json) do
    payment_decoded = Poison.decode!(payment_json)

    total = payment_decoded["transaction_details"]["total_paid_amount"]
    importe_neto = payment_decoded["transaction_details"]["net_received_amount"]

    [
      extract_cliente_codigo(payment_decoded["description"]),
      total,
      importe_neto
    ]
  end

  defp build_teamplace_payment([cliente_codigo, total, importe_neto], id) do
    comision = total - importe_neto

    comision =
      case comision do
        x when is_float(x) ->
          Float.round(comision, 2)

        x ->
          x
      end

    %Cobranza{
      EmpresaCodigo: Application.get_env(:barpay, :sucursal),
      Proveedor: cliente_codigo,
      Descripcion: build_description(id)
    }
    |> Cobranza.add_banco(%Banco{
      CuentaCodigo: "MERCADO_PAGO",
      ImporteMonTransaccion: "#{importe_neto}"
    })
    |> Cobranza.add_otros(%Otros{
      CuentaCodigo: "GASBAN",
      ImporteMonTransaccion: "#{comision}"
    })
    |> Cobranza.add_cta_cte(%CtaCte{
      CuentaCodigo: "CLIENTES",
      ImporteMonTransaccion: "#{total}",
      ImporteMonPrincipal: "#{total}"
    })
    |> Cobranza.add_dolar_price()
  end

  defp build_description(id) do
    "** MP_ID: #{id} **"
  end

  defp post_payment_to_teamplace(cobranza) do
    case Poison.encode(cobranza) do
      {:ok, cobranza_json} ->
        Application.get_env(:teamplace, :credentials)
        |> Teamplace.post_data("cobranza", cobranza_json)

      x ->
        IO.inspect(x)
        msg = "Error en la creación o envío de la cobranza"
        IO.puts(msg)

        {:error, msg}
    end
  end

  defp extract_cliente_codigo(description) do
    Regex.named_captures(~r/\*\*\s(?<value>[^\-]*)\s\-/, description)["value"]
  end
end
