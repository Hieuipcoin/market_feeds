defmodule Ladder.Database.LadderSeries do
  use Instream.Series

  series do
    database    "ladders"
    measurement "price"

    tag :exchange
    tag :symbol

    field :bids
    field :market_bid
    field :asks
    field :market_ask
  end
end
