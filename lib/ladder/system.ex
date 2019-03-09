defmodule Ladder.System do
  require Logger
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Ladder.Helper.ProcessRegistry,
      Ladder.Database.Database,
      Ladder.Services.Manager
    ]
    Logger.error("[#{__MODULE__}][init] children=#{inspect children}, strategy=:one_for_one")

    Supervisor.init(children, strategy: :one_for_one)
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

