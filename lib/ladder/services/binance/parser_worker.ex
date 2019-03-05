defmodule Ladder.Services.Binanace.ParserWorker do
  use GenServer
  alias Ladder.Database.Database
  alias Ladder.Services.Binanace.ParserState
  alias Ladder.Helper.ProcessRegistry

    @impl true
  def init(state) do
    IO.puts("init parserworker")
    {:ok, state}
  end

  def start_link({endpoint, stream_name}) do
    IO.puts("start_link parserworker : #{endpoint} and #{stream_name}")
    {:ok, _pid} = GenServer.start_link(
      __MODULE__,
#      %{exchange: get_exchange_name(endpoint), symbol: get_symbol(stream_name)},
      create_state(%{endpoint: endpoint, stream_name: stream_name}),
      name: process_name(stream_name))
  end

  defp create_state(exchange_info) do
    ParserState.new(%{
      process_name: process_name(exchange_info[:stream_name]),
      binance_info: %{
        exchange: get_exchange_name(exchange_info[:endpoint]),
        symbol: get_symbol(exchange_info[:stream_name])
      }
    })
  end

  def send(data, stream_name) do
    IO.puts("send data")
    GenServer.cast(process_name(stream_name), {:send, data})
  end

  @impl GenServer
  def handle_cast({:send, data}, state) do
#    IO.puts("riki handle cast: #{inspect(data)}")

    IO.puts("handle_cast")

    parse(data)
    |> Database.save(state)

    {:noreply, state}
  end

  defp process_name(stream_name) do
#    String.to_atom("#{__MODULE__}#{stream_name}")
    ProcessRegistry.via_tuple({__MODULE__, get_symbol(stream_name)})
  end

  defp parse(data) do
    %{"s" => symbol, "p" => price, "q" => quantity} = data
    String.to_float(price)
  end

  # endpoint = "wss://stream.binance.com:9443"
  def get_exchange_name(endpoint) do
    endpoint
    |> String.split(".")
    |> Enum.at(1)
  end

  # stream "/ws/btcusdt@trade"
  def get_symbol(stream) do
    stream
    |> String.split("/")
    |> Enum.at(2)
    |> String.split("@")
    |> Enum.at(0)
  end
end



defmodule Ladder.Services.Binanace.ParserState do
  defstruct process_name: nil,
            binance_info: %{}
  use ExConstructor
end