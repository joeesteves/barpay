defmodule Barpay.Queue do
  @moduledoc """
    SIMPLE FIFO Queue for storing payments ids
  """
  @queue "payment.queue"
  @separata "\n"

  def get do

  end

  def put do

  end

  def start do
    File.touch(@queue)

    receive do
      {:get, id, caller} ->
        [head | tail] = File.read!(@queue) |> String.split(@separata)
        File.write!(@queue, Enum.join(tail, @separata))
        send(caller, head)

      {:put, id} ->
        File.write!(@queue, id <> @separata, [:append])
    end
  end
end
