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

      @impl GenServer
      def handle_cast({:send, data}, state) do
        IO.puts("handle_cast")

        case parse(data, state) do
          {:ok, parsed_data, new_state} ->
            Database.save(parsed_data, new_state)
            {:noreply, new_state}
          _ -> {:noreply, state}
        end

      end

      defp via_tuple(symbol) do
        ProcessRegistry.via_tuple({__MODULE__, symbol})
      end
    end
  end
end
