defmodule Ladder.Services.Manager do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Ladder.Services.Binanace.Binance,
      Ladder.Services.Bitfinex.Bitfinex
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
