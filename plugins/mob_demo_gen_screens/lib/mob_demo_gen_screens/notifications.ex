defmodule MobDemoGenScreens.Notifications do
  @moduledoc "Notification handler — matches a distinct payload from subapp's."

  @doc "Records the routed notification so a device probe can confirm it fired."
  def handle(payload) do
    Mob.State.put({:gen, :last_notification}, payload)
    :ok
  end
end
