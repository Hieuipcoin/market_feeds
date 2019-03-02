defmodule Ladder.Services.Binanace.Worker do
  use WebSockex

  def start_link({endpoint, stream_name}) do
    IO.puts("riki debug here : Ladder.BinanceBtcUsdt.start_link")
    WebSockex.start_link(endpoint<>stream_name, __MODULE__, %{}, name: process_name(stream_name))
  end

  defp process_name(stream_name) do
    String.to_atom("#{__MODULE__}#{stream_name}")
  end

  def handle_frame({:text, msg}, state) do
    msg
    |> Poison.decode!()
    |> filter()
    |> IO.inspect()
    |> write_data
    {:ok, state}
  end

  defp filter(decoded_msg) do
    %{"s" => symbol, "p" => price, "q" => quantity} = decoded_msg
    #    %{"s" => symbol, "p" => price, "q" => quantity}
    String.to_float(price)
  end

  # Riki will move this function to other location later. just for testing now. ^^
  defp write_data(value) do
    data = %LadderSeries{}
    data = %{data | fields: %{data.fields | value: value}}
    data = %{data | tags: %{data.tags | exchange: "binance", symbol: "btcusdt"}}

    Ladder.Database.Database.write(data)
    |> IO.inspect
  end
end
