defmodule Ladder.Services.Binanace.Binance do
  use Supervisor

  @endpoint "wss://stream.binance.com:9443"
  @streams ["/ws/btcusdt@trade", "/ws/ltcbtc@trade"]

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    IO.puts("riki in init Binance supervisor")
    children = Enum.map(@streams, &worker_spec/1)
    Supervisor.init(children, strategy: :one_for_one)
  end

  defp worker_spec(stream) do
    default_worker_spec = {Ladder.Services.Binanace.Worker, {@endpoint, stream}}
    Supervisor.child_spec(default_worker_spec, id: stream)
  end

#  def handle_info({:EXIT, pid, reason}, state) do
#    IO.puts("A child process died: #{reason}")
#    {:noreply, state}
#  end
#
#  def handle_info(msg, state) do
#    IO.puts("Supervisor received unexpected message: #{inspect(msg)}")
#    {:noreply, state}
#  end
end
