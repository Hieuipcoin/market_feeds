defmodule Ladder.Services.Binanace.ParserWorker do
  use Ladder.Behaviours.Binance.Parser
  alias Ladder.Services.Binanace.Helper

  defp create_state({endpoint, stream}) do
    ParserState.new(%{
      exchange: get_exchange(endpoint),
      symbol: get_symbol(stream),
      update_id: -1
    })
  end

  defp parse(ladder = %{"lastUpdateId" => update_id, "bids" => bids, "asks" => asks}, state) do
    if is_valid({:input, {update_id, bids, asks}}, state) do
      new_state = %{state | update_id: update_id}
      {:ok, build_data(bids, asks), new_state}
    else
      Logger.error("[#{__MODULE__}][parse] ladder=#{inspect ladder}, state=#{inspect state}")
      {:error, nil, state}
    end
  end

  defp parse(ladder, state) do
    Logger.error("[#{__MODULE__}][parse] wrong format. ladder=#{inspect ladder}, state=#{inspect state}")
    {:error, nil, state}
  end

  # return {:ok, parsed_data, new_state}
  # parsed_data = %{bids: bids, asks: asks, market_bid: market_bid, market_ask}
  defp build_data(bids, asks) do
    bids = reformat(bids)
    asks = reformat(asks)
    market_bid = highest_bid(bids)
    market_ask = lowest_ask(asks)

    %{bids: bids, asks: asks, market_bid: market_bid, market_ask: market_ask }
  end

  # data = [["1.2", "0.5", []], ..., ["11.22", "0.55", []]]
  # return = [["1.2", "0.5"], ..., ["11.22", "0.55"]]
  defp reformat(data) do
    Enum.map(data, fn([x,y,_]) -> [x,y] end)
  end

  defp highest_bid(bids) do
    Enum.reduce(bids,
      Enum.at(bids, 0),
      fn([price, amount], [highest_price, highest_amount]) ->
        if String.to_float(price) > String.to_float(highest_price), do: [price, amount], else: [highest_price, highest_amount]
      end)
  end

  defp lowest_ask(asks) do
    Enum.reduce(asks,
      Enum.at(asks, 0),
      fn([price, amount], [lowest_price, lowest_amount]) ->
        if String.to_float(price) > String.to_float(lowest_price), do: [lowest_price, lowest_amount], else: [price, amount]
      end)
  end

  defp is_valid({:input, {update_id, bids, asks}}, state) do
    is_valid({:id, update_id}, state.update_id) &&
    is_valid({:list, bids}) &&
    is_valid({:list, asks})
  end

  defp is_valid({:id, update_id}, pre_update_id) do
    is_number(update_id) && update_id != pre_update_id
  end

  defp is_valid({:list, data}) do
    is_list(data) && length(data) > 0
  end

  # stream "/ws/btcusdt@depth10"
  def get_symbol(stream) do
    Helper.symbol(stream)
  end

  # endpoint = "wss://stream.binance.com:9443"
  def get_exchange(endpoint) do
    Helper.exchange(endpoint)
  end
end

defmodule Ladder.Services.Binanace.ParserState do
  defstruct [:exchange, :symbol, :update_id]
  use ExConstructor
end
