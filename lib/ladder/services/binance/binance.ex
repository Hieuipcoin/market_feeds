defmodule Ladder.Services.Binanace.Binance do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      {Ladder.Services.Binanace.Worker, [{"wss://stream.binance.com:9443", "/ws/btcusdt@trade"}]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
