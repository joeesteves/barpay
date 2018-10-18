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

  def create_link(title, description, amount) do
    MercadoPago.get_payment_link("TEST", "TEST", 1)

  end
end
