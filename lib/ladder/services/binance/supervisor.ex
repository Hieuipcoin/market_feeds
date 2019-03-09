defmodule Ladder.Services.Binanace.Supervisor do
  require Logger
  use Supervisor
  alias Ladder.Services.Binanace.ConnectionWorker
  alias Ladder.Services.Binanace.ParserWorker

  [endpoint: endpoint, streams: streams] = Application.get_env(:market_feeds, __MODULE__)
  @endpoint endpoint
  @streams streams

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Logger.error("[#{__MODULE__}][init] endpoints=#{inspect @endpoint}, streams=#{inspect @streams}")

    connection_children = Enum.map(@streams, &con_worker_spec/1)
    parser_children = Enum.map(@streams, &par_worker_spec/1)

    parser_children ++ connection_children
    |> Supervisor.init(strategy: :one_for_one)
  end

  defp con_worker_spec(stream) do
    worker_spec = {ConnectionWorker, {@endpoint, stream}}
    Supervisor.child_spec(worker_spec, id: stream<>"con")
  end

  defp par_worker_spec(stream) do
    worker_spec = {ParserWorker, {@endpoint, stream}}
    Supervisor.child_spec(worker_spec, id: stream<>"par")
  end

  def handle_info({:EXIT, pid, reason}, state) do
    Logger.error("[#{__MODULE__}][handle_info][:EXIT] pid=#{inspect pid}, reason=#{inspect reason}, state=#{inspect state}")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.error("[#{__MODULE__}][handle_info][:Others] msg=#{inspect msg}, state=#{inspect state}")
    {:noreply, state}
  end
end
