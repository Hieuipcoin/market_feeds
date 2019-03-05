defmodule Ladder.Behaviours.ParserServer do
  defmacro __using__(_) do
    quote do
      use GenServer
      alias Ladder.Services.Binanace.ParserState
      alias Ladder.Services.Binanace.Helper
      alias Ladder.Helper.ProcessRegistry
      alias Ladder.Database.Database

      @impl true
      def init(state) do
        IO.puts("init #{__MODULE__}")
        {:ok, state}
      end

      def start_link({endpoint, stream}) do
        IO.puts("start_link #{__MODULE__}} : #{endpoint} and #{stream}")
        {:ok, _pid} = GenServer.start_link(
          __MODULE__,
          create_state({endpoint, stream}),
          name: via_tuple(Helper.symbol(stream)))
      end

      def send(data, symbol) do
        IO.puts("send data")
        GenServer.cast(via_tuple(symbol), {:send, data})
      end

      defp create_state({endpoint, stream}) do
        ParserState.new(%{
          exchange: Helper.exchange(endpoint),
          symbol: Helper.symbol(stream)
        })
      end

      defp via_tuple(symbol) do
        ProcessRegistry.via_tuple({__MODULE__, symbol})
      end

      @impl GenServer
      def handle_cast({:send, data}, state) do
        IO.puts("handle_cast")

        parse(data)
        |> Database.save(state)

        {:noreply, state}
      end
    end
  end
end


defmodule Ladder.Services.Binanace.ParserState do
  defstruct [:exchange, :symbol]
  use ExConstructor
end
