defmodule Ladder.Services.Binanace.ConnectionWorker do
  require Logger
  use Ladder.Behaviours.Binance.Connection
  alias Ladder.Services.Binanace.ParserWorker
  alias Ladder.Services.Binanace.ConnectionState
  alias Ladder.Services.Binanace.Helper

  def handle_frame({:text, msg}, state) do
    msg
    |> Poison.decode!()
    |> handle_decoded_msg(state.symbol)
    {:ok, state}
  end

  # for handle the others
  def handle_frame({type, msg}, state) do
    Logger.error("[#{__MODULE__}][handle_frame] type=#{inspect type}, msg=#{inspect msg}, state=#{inspect state}")
    {:ok, state}
  end

  # stream "/ws/btcusdt@depth10"
  def get_symbol(stream) do
    Helper.symbol(stream)
  end

  # endpoint = "wss://stream.binance.com:9443"
  def get_exchange(endpoint) do
    Helper.exchange(endpoint)
  end

  defp handle_decoded_msg(msg, symbol) do
    ParserWorker.send(msg, symbol)
  end

  defp create_state({endpoint, stream}) do
    ConnectionState.new(%{
      exchange: get_exchange(endpoint),
      symbol: get_symbol(stream)
    })
  end
end
