defmodule Ladder.Services.Binanace.Worker do
  alias Ladder.Behaviours.BinanceWebsocket
  use BinanceWebsocket

#  def start_link({endpoint, stream_name}) do
#    IO.puts("start link in Binance Worker")
#    BinanceWebsocket.start_link({endpoint, stream_name})
#  end

  def handle_decoded_msg(msg) do
    %{"s" => symbol, "p" => price, "q" => quantity} = msg
    String.to_float(price)
  end

  # endpoint = "wss://stream.binance.com:9443"
  def get_exchange_name(endpoint) do
    endpoint
    |> String.split(".")
    |> IO.inspect
    |> Enum.at(1)
    |> IO.inspect
  end

  # stream "/ws/btcusdt@trade"
  def get_symbol(stream) do
    stream
    |> String.split("/")
    |> IO.inspect
    |> Enum.at(2)
    |> String.split("@")
    |> Enum.at(0)
    |> IO.inspect
  end
end







#defmodule Ladder.Services.Binanace.Worker do
#  use WebSockex
#
#  def start_link({endpoint, stream_name}) do
#    IO.puts("riki debug here : Ladder.BinanceBtcUsdt.start_link")
#    WebSockex.start_link(endpoint<>stream_name, __MODULE__, %{}, name: process_name(stream_name))
#  end
#
#  defp process_name(stream_name) do
#    String.to_atom("#{__MODULE__}#{stream_name}")
#  end
#
#  def handle_frame({:text, msg}, state) do
##    msg
##    |> Poison.decode!()
##    |> filter()
##    |> IO.inspect()
##    |> write_data
#    {:ok, state}
#  end
#
#  defp filter(decoded_msg) do
#    %{"s" => symbol, "p" => price, "q" => quantity} = decoded_msg
#    #    %{"s" => symbol, "p" => price, "q" => quantity}
#    String.to_float(price)
#  end
#
#  # Riki will move this function to other location later. just for testing now. ^^
#  defp write_data(value) do
#    data = %LadderSeries{}
#    data = %{data | fields: %{data.fields | value: value}}
#    data = %{data | tags: %{data.tags | exchange: "binance", symbol: "btcusdt"}}
#
#    Ladder.Database.Database.write(data)
#    |> IO.inspect
#  end
#
#
#  def test do
#    IO.puts("riki test module #{__MODULE__}")
##    IO.puts("riki test caller #{__CALLER__}")
##    IO.puts("riki test caller module #{__CALLER__.module}")
#
#  end
#end
