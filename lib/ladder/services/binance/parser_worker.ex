defmodule Ladder.Services.Binanace.ParserWorker do
  use GenServer
  alias Ladder.Database.Database
  alias Ladder.Services.Binanace.ParserState
  alias Ladder.Helper.ProcessRegistry
  alias Ladder.Services.Binanace.Helper

    @impl true
  def init(state) do
    IO.puts("init parserworker")
    {:ok, state}
  end

  def start_link({endpoint, stream_name}) do
    IO.puts("start_link parserworker : #{endpoint} and #{stream_name}")
    {:ok, _pid} = GenServer.start_link(
                                  __MODULE__,
                                  create_state({endpoint, stream_name}),
                                  name: via_tuple(Helper.symbol(stream_name)))
  end

  defp create_state({endpoint, stream_name}) do
    ParserState.new(%{
      exchange: Helper.exchange(endpoint),
      symbol: Helper.symbol(stream_name)
    })
  end

  def send(data, symbol) do
    IO.puts("send data")
    GenServer.cast(via_tuple(symbol), {:send, data})
  end

  @impl GenServer
  def handle_cast({:send, data}, state) do
#    IO.puts("riki handle cast: #{inspect(data)}")
    IO.puts("handle_cast")

    parse(data)
    |> Database.save(state)

    {:noreply, state}
  end

  defp via_tuple(symbol) do
    ProcessRegistry.via_tuple({__MODULE__, symbol})
  end

  defp parse(data) do
    %{"s" => _symbol, "p" => price, "q" => _quantity} = data
    String.to_float(price)
  end
end



defmodule Ladder.Services.Binanace.ParserState do
  defstruct [:exchange, :symbol]
  use ExConstructor
end