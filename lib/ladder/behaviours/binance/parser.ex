defmodule Ladder.Behaviours.Binance.Parser do
  defmacro __using__(_) do
    quote do
      require Logger
      use GenServer
      alias Ladder.Services.Binanace.ParserState
      alias Ladder.Helper.ProcessRegistry
      alias Ladder.Database.Database

      @impl true
      def init(state) do
        IO.puts("init #{__MODULE__}")
        {:ok, state}
      end

      def start_link({endpoint, stream}) do
        Logger.info("[#{__MODULE__}][start_link] endpoint=#{inspect endpoint}, stream=#{inspect stream}")

        {:ok, _pid} = GenServer.start_link(
          __MODULE__,
          create_state({endpoint, stream}),
          name: via_tuple(get_symbol(stream)))
      end

      def send(data, symbol) do
        GenServer.cast(via_tuple(symbol), {:send, data})
      end

      @impl GenServer
      def handle_cast({:send, data}, state) do
        case parse(data, state) do
          {:ok, parsed_data, new_state} ->
            Database.save(parsed_data, new_state)
            {:noreply, new_state}
          _ -> {:noreply, state}
        end
      end

      def handle_cast(request, state) do
        Logger.error("[#{__MODULE__}][handle_cast] request=#{inspect request}, state=#{inspect state}")
        {:noreply, state}
      end

      defp via_tuple(symbol) do
        ProcessRegistry.via_tuple({__MODULE__, symbol})
      end
    end
  end
end
