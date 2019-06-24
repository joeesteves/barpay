defmodule Barpay.Queue do
  @moduledoc """
    SIMPLE FIFO Queue for storing payments ids
  """
  @queue "payment.queue"
  @separata "\n"

  def get() do
    send(__MODULE__, {:get, self()})

    receive do
      {:id, value} ->
        value
    end
  end

  def put(id) do
    send(__MODULE__, {:put, id})
  end

  def start do
    File.touch(@queue)

    proc = spawn(fn -> loop() end)
    Process.register(proc, __MODULE__)
  end

  defp loop do
    receive do
      {:get, caller} ->
        [head | tail] = File.read!(@queue) |> String.split(@separata)
        File.write!(@queue, Enum.join(tail, @separata))
        send(caller, {:id, head})
        loop()
      {:put, id} ->
        File.write!(@queue, id <> @separata, [:append])
        loop()
    end
  end
end
