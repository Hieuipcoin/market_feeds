defmodule Ladder.Services.Binanace.ConnectionWorker do
  use Ladder.Behaviours.BinanceWebsocket
  alias Ladder.Services.Binanace.ParserWorker
  alias Ladder.Services.Binanace.ConnectionState

  def handle_frame({:text, msg}, state) do
    msg
    |> Poison.decode!()
    |> IO.inspect
    |> handle_decoded_msg(state.symbol)
    {:ok, state}
  end

  def handle_frame({type, msg}, state) do
    IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    {:ok, state}
  end

  defp handle_decoded_msg(msg, symbol) do
    ParserWorker.send(msg, symbol)
  end

  defp create_state({endpoint, stream}) do
    ConnectionState.new(%{
      exchange: Helper.exchange(endpoint),
      symbol: Helper.symbol(stream)
    })
  end

  def terminate(reason, state) do
    IO.puts("\nSocket Terminating:\n#{inspect reason}\n\n#{inspect state}\n")
    exit(:normal)
  end
end
