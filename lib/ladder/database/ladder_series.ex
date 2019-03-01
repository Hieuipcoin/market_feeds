defmodule LadderSeries do
  use Instream.Series

  series do
    database    "ladders"
    measurement "price"

    tag :exchange
    tag :symbol

    field :value
  end
end