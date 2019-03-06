defmodule Ladder.Behaviours.BinanceWebsocket do
  defmacro __using__(_) do
    quote do
      use WebSockex
      alias Ladder.Helper.ProcessRegistry
      alias Ladder.Services.Binanace.Helper

      def start_link({endpoint, stream}) do
        endpoint<>stream
        |> WebSockex.start_link(
             __MODULE__,
             create_state({endpoint, stream}),
             name: via_tuple(Helper.symbol(stream)))
      end

      defp via_tuple(symbol) do
        ProcessRegistry.via_tuple({__MODULE__, symbol})
      end
    end
  end
end

defmodule Ladder.Services.Binanace.ConnectionState do
  defstruct [:exchange, :symbol]
  use ExConstructor
end
