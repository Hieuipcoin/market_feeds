defmodule Ladder.Services.Binanace.ParserWorker do
  use Ladder.Behaviours.ParserServer

  defp parse(data) do
    %{"s" => _symbol, "p" => price, "q" => _quantity} = data
    String.to_float(price)
  end
end
