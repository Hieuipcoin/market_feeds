defmodule Ladder.Services.Binanace.Binance do
  use Supervisor

  @endpoint "wss://stream.binance.com:9443"
  @streams ["/ws/btcusdt@trade", "/ws/ltcbtc@trade"]

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = Enum.map(@streams, &worker_spec/1)
    |> IO.inspect
    Supervisor.init(children, strategy: :one_for_one)
  end

  defp worker_spec(stream) do
    default_worker_spec = {Ladder.Services.Binanace.Worker, {@endpoint, stream}}
    Supervisor.child_spec(default_worker_spec, id: stream)
  end
end
