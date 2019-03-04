defmodule Ladder.Behaviours.BinanceWebsocket do
  defmacro __using__(_) do
    quote do
      use WebSockex
      alias Ladder.Database.Database

      def start_link({endpoint, stream_name}) do
        WebSockex.start_link(
          endpoint<>stream_name,
          __MODULE__,
          %{exchange: get_exchange_name(endpoint), symbol: get_symbol(stream_name)},
          name: process_name(stream_name)
        )
      end

      def handle_frame({:text, msg}, state) do
        msg
        |> Poison.decode!()
        |> IO.inspect
        |> handle_decoded_msg
        |> Database.save(state)
        {:ok, state}
      end

      defp process_name(stream_name) do
        String.to_atom("#{__MODULE__}#{stream_name}")
      end
    end
  end
end
