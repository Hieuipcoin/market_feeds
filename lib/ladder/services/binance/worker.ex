defmodule Ladder.Services.Binanace.Worker do
  use Ladder.Behaviours.BinanceWebsocket

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
