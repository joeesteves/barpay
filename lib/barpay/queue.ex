defmodule Barpay.Queue do
  use GenServer

  @moduledoc """
    SIMPLE FIFO Queue for storing payments ids
  """
  @queue "payment.queue"
  @separata "\n"

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def put(id) do
    GenServer.call(__MODULE__, {:put, id})
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:get, _from, _state) do
    head =
      case File.read!(@queue) |> String.split(@separata) do
        ["" | _] ->
          nil

        [head | tail] ->
          File.write!(@queue, Enum.join(tail, @separata))
          head
      end

    {:reply, head, nil}
  end

  def handle_call({:put, id}, _from, _state) do
    File.write!(@queue, id <> @separata, [:append])
    {:reply, :ok, nil}
  end
end
