defmodule Barpay.Queue do
  use GenServer

  @moduledoc """
    SIMPLE FIFO Queue for storing payments ids
  """
  @queue "payment.queue"
  @separata "\n"

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def put(id) do
    GenServer.cast(__MODULE__, {:put, id})
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:get, _from, _state) do
    [head | tail] = File.read!(@queue) |> String.split(@separata)
    File.write!(@queue, Enum.join(tail, @separata))
    {:reply, head, nil}
  end

  def handle_cast({:put, id}, _state) do
    File.write!(@queue, id <> @separata, [:append])
    {:noreply, nil}
  end
end
