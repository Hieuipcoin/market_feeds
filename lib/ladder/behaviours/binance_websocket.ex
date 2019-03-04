defmodule Ladder.Behaviours.BinanceWebsocket do

  defmacro __using__(_) do
    quote do
      use WebSockex
      alias Ladder.Database.LadderSeries

      def start_link({endpoint, stream_name}) do
        WebSockex.start_link(
          endpoint<>stream_name,
          __MODULE__,
          %{exchange: get_exchange_name(endpoint), symbol: get_symbol(stream_name)},
          name: process_name(stream_name)
        )
      end

      def handle_frame({:text, msg}, state) do
#        IO.puts(__MODULE__)

        msg
        |> Poison.decode!()
        |> IO.inspect
        |> handle_decoded_msg
        |> write_data(state)

        {:ok, state}
      end

      defp process_name(stream_name) do
        String.to_atom("#{__MODULE__}#{stream_name}")
      end

      defp write_data(value, state) do
        data = %LadderSeries{}
        data = %{data | tags: %{data.tags | exchange: state[:exchange], symbol: state[:symbol]}}
        data = %{data | fields: %{data.fields | value: value}}


        Ladder.Database.Database.write(data)
        |> IO.inspect
      end

    end
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
#    msg
#    |> Poison.decode!()
#    |> filter()
#    |> IO.inspect()
#    |> write_data
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
#end
