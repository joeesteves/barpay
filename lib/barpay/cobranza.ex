defmodule Barpay.Cobranza do
  alias Teamplace.Cobranza
  alias Teamplace.Cobranza.{Banco, Otros, CtaCte, Cotizacion}

  def create(cliente_codigo, total, importe_neto) do
    comision = Float.round(total - importe_neto, 2)

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

  def post_cobranza(cobranza) do
    case Poison.encode(cobranza) do
      {:ok, cobranza_json} ->
        Application.get_env(:teamplace, :credentials)
        |> Teamplace.post_data("cobranza", cobranza_json)

      _ ->
        IO.puts("Error en la creción o envío de la cobranza")
    end
  end
end
