defmodule Ladder.Database.Database do
  use Instream.Connection, otp_app: :market_feeds
  alias Ladder.Database.LadderSeries

  def save(value, state) do
    create(value, state)
    |> IO.inspect
    |> write
    |> IO.inspect
  end

  defp create(value, state) do
    IO.inspect(state)
    data = %LadderSeries{}
    data = %{data | tags: %{data.tags | exchange: state.exchange, symbol: state.symbol}}
    %{data | fields: %{data.fields | value: value}}
  end
end

