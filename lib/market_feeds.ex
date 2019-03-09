defmodule MarketFeeds do
  @moduledoc """
  Collect latest streaming pricing data in the world of cryptocurrencies.
  """

  @doc """
  require: influxdb
  steps:
  - mix deps.get
  - mix deps.compile
  - iex -S mix
  """
  use Application

  def start(_type, _args) do
    Ladder.System.start_link
  end
end
