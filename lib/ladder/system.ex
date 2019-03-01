defmodule Ladder.System do
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

    Supervisor.init(children, strategy: :one_for_one)
  end
end

