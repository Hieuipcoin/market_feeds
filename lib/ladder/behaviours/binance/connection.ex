defmodule Ladder.Behaviours.Binance.Connection do
  defmacro __using__(_) do
    quote do
      use WebSockex
      alias Ladder.Helper.ProcessRegistry
      alias Ladder.Services.Binanace.Helper

      def start_link({endpoint, stream}) do
        Logger.info("[#{__MODULE__}][start_link] endpoint=#{inspect endpoint}, stream=#{inspect stream}")
        endpoint<>stream
        |> WebSockex.start_link(
             __MODULE__,
             create_state({endpoint, stream}),
             name: via_tuple(get_symbol(stream)))
      end

      defp via_tuple(symbol) do
        ProcessRegistry.via_tuple({__MODULE__, symbol})
      end

      def handle_connect(conn, state) do
        Logger.info("[#{__MODULE__}][handle_connect] conn=#{inspect conn}, state=#{inspect state}")
        {:ok, state}
      end

      def handle_disconnect(conn_status_map, state) do
        Logger.error("[#{__MODULE__}][handle_disconnect] conn_status_map=#{inspect conn_status_map}, state=#{inspect state}")
        {:ok, state}
      end

      def handle_ping(:ping, state) do
        Logger.info("[#{__MODULE__}][handle_ping] #{inspect :ping}, state=#{inspect state}")
        {:reply, :pong, state}
      end

      def handle_ping({:ping, msg}, state) do
        Logger.info("[#{__MODULE__}][handle_ping] #{inspect :ping} msg=#{inspect msg}, state=#{inspect state}")
        {:reply, {:pong, msg}, state}
      end

      def handle_info(message, state) do
        Logger.error("[#{__MODULE__}][handle_info] message=#{inspect message}, state=#{inspect state}")
        {:ok, state}
      end

      def terminate(reason, state) do
        Logger.error("[#{__MODULE__}][terminate] reason=#{inspect reason}, state=#{inspect state}")
        exit(:normal)
      end
    end
  end
end

defmodule Ladder.Services.Binanace.ConnectionState do
  defstruct [:exchange, :symbol]
  use ExConstructor
end
