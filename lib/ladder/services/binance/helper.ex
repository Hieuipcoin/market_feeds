defmodule Ladder.Services.Binanace.Helper do
  alias Ladder.Helper.ProcessRegistry

  # endpoint = "wss://stream.binance.com:9443"
  def exchange(endpoint) do
    endpoint
    |> String.split(".")
    |> Enum.at(1)
  end

  # stream "/ws/btcusdt@depth10"
  def symbol(stream) do
    stream
    |> String.split("/")
    |> Enum.at(2)
    |> String.split("@")
    |> Enum.at(0)
  end
end
