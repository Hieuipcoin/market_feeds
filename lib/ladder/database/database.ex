defmodule Ladder.Database.Database do
  use Instream.Connection, otp_app: :market_feeds
  alias Ladder.Database.LadderSeries

  def save(value, state) do
    create(value, state)
    |> write
  end

  defp create(%{bids: bids, market_bid: market_bid, asks: asks, market_ask: market_ask}, state) do
    data = %LadderSeries{}
    data = %{data | tags: %{data.tags | exchange: state.exchange, symbol: state.symbol}}
    %{data | fields: %{data.fields |
      bids: Poison.encode!(bids),
      market_bid: Poison.encode!(market_bid),
      asks: Poison.encode!(asks),
      market_ask: Poison.encode!(market_ask)}}
  end
end

