defmodule Ladder.Services.Binanace.Binance do
  use Supervisor

  @endpoint "wss://stream.binance.com:9443"
  @streams ["/ws/btcusdt@trade", "/ws/ltcbtc@trade"]

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    IO.puts("riki in init Binance supervisor")
    connection_children = Enum.map(@streams, &con_worker_spec/1)
    parser_children = Enum.map(@streams, &par_worker_spec/1)

    parser_children ++ connection_children
    |> Supervisor.init(strategy: :one_for_one)
  end

  defp con_worker_spec(stream) do
    default_worker_spec = {Ladder.Services.Binanace.ConnectionWorker, {@endpoint, stream}}
    Supervisor.child_spec(default_worker_spec, id: stream<>"con")
  end

  defp par_worker_spec(stream) do
    default_worker_spec = {Ladder.Services.Binanace.ParserWorker, {@endpoint, stream}}
    Supervisor.child_spec(default_worker_spec, id: stream<>"par")
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
