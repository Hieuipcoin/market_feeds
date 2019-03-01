defmodule MarketFeeds do
  @moduledoc """
  Documentation for MarketFeeds.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MarketFeeds.hello()
      :world

  """
  use Application

  def start(_type, _args) do
    Ladder.System.start_link
  end
end
