defmodule MobDemoSubapp.Worker do
  @moduledoc "A trivial supervised background worker for the tier-4 demo."
  use GenServer

  def start_link(_arg), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  @impl GenServer
  def init(:ok) do
    Mob.State.put({:subapp, :worker_started}, true)
    {:ok, %{ticks: 0}}
  end
end
