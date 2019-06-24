defmodule Barpay.Cobranza do
  alias Teamplace.Cobranza
  alias Teamplace.Cobranza.{Banco, Otros, CtaCte, Cotizacion}

  def start_process do
    case Barpay.Queue.get() do
      nil ->
        false

      id ->
        MercadoPago.get_payment(id)
        |> parse_payment
        |> IO.inspect()
        |> build_teamplace_payment
        |> post_payment_to_teamplace
    end
  end

  def parse_payment(payment_json) do
    payment_decoded = Poison.decode!(payment_json)

    total = payment_decoded["transaction_details"]["total_paid_amount"]
    importe_neto = payment_decoded["transaction_details"]["net_received_amount"]

    [
      extract_cliente_codigo(payment_decoded["description"]),
      total,
      importe_neto
    ]
  end

  def build_teamplace_payment([cliente_codigo, total, importe_neto]) do
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
      Proveedor: cliente_codigo
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

  def post_payment_to_teamplace(cobranza) do
    case Poison.encode(cobranza) do
      {:ok, cobranza_json} ->
        Application.get_env(:teamplace, :credentials)
        |> Teamplace.post_data("cobranza", cobranza_json)

      _ ->
        IO.puts("Error en la creción o envío de la cobranza")
    end
  end

  defp extract_cliente_codigo(description) do
    Regex.named_captures(~r/\*\*\s(?<value>[^\-]*)\s\-/, description)["value"]
  end
end
