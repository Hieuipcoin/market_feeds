defmodule Ladder.Services.Binanace.ConnectionWorker do
  use Ladder.Behaviours.BinanceWebsocket
  alias Ladder.Services.Binanace.ParserWorker
  alias Ladder.Services.Binanace.ConnectionState

  defp handle_decoded_msg(msg, symbol) do
    ParserWorker.send(msg, symbol)
  end

  defp create_state({endpoint, stream}) do
    ConnectionState.new(%{
      exchange: Helper.exchange(endpoint),
      symbol: Helper.symbol(stream)
    })
  end
end

defmodule Ladder.Services.Binanace.ConnectionState do
  defstruct [:exchange, :symbol]
  use ExConstructor
end
