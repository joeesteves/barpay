defmodule Barpay.CobranzaTest do
  use ExUnit.Case

  test "retrieves cliente, total e neto from marcadoPago payment" do
    json_payment = ~s({
      "date_created": "2019-06-21T11:28:38.000-04:00",
      "description": "Link de pago despacho DDDON - 7045 ** 0072 - Casa de Restauracion - Jabes",
      "id": 4888529645,
      "transaction_details": {
        "net_received_amount": 74.69,
        "total_paid_amount": 80
      }
    })
    result = Barpay.Cobranza.parse_payment(json_payment)
    assert result.cliente_codigo == "0072"
    assert result.importe_neto == 74.69
    assert result.total == 80
  end

end
