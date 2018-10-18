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
    IO.puts("this is it")
    :timer.sleep(1000)
    hello
  end
end
