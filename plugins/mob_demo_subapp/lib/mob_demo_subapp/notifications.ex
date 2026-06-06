defmodule MobDemoSubapp.Notifications do
  @moduledoc "Tier-4 notification handler — records the routed payload."

  @doc "handler for `%{type: \"subapp_ping\"}` notifications."
  def handle(payload) do
    Mob.State.put({:subapp, :last_notification}, payload)
    :ok
  end
end
