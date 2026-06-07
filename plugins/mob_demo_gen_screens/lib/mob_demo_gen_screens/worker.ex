defmodule MobDemoGenScreens.Worker do
  @moduledoc "A trivial supervised worker — distinct name from MobDemoSubapp.Worker."
  use GenServer

  def start_link(_arg), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  @impl GenServer
  def init(:ok) do
    Mob.State.put({:gen, :worker_started}, true)
    {:ok, %{}}
  end
end
