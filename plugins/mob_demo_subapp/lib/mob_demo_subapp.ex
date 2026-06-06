defmodule MobDemoSubapp do
  @moduledoc """
  Tier-4 sub-app plugin lifecycle hooks. Each records a side-effect in `Mob.State`
  so a device probe can confirm the host invoked it (`probe/0` reads them back).
  """

  @doc "lifecycle.on_start — runs at boot under the plugin supervisor."
  def start do
    Mob.State.put({:subapp, :started}, true)
    :ok
  end

  @doc "lifecycle.on_resume — host foregrounded."
  def on_resume, do: bump(:resume_count)

  @doc "lifecycle.on_background — host backgrounded."
  def on_background, do: bump(:background_count)

  @doc "Reads back every observable side-effect for the device probe."
  def probe do
    %{
      started: Mob.State.get({:subapp, :started}, false),
      worker_alive: is_pid(Process.whereis(MobDemoSubapp.Worker)),
      resume_count: Mob.State.get({:subapp, :resume_count}, 0),
      background_count: Mob.State.get({:subapp, :background_count}, 0),
      last_notification: Mob.State.get({:subapp, :last_notification}, nil),
      sound: Mob.Plugins.get_setting(:mob_demo_subapp, :sound),
      channel: Mob.Plugins.get_setting(:mob_demo_subapp, :channel)
    }
  end

  defp bump(key) do
    Mob.State.put({:subapp, key}, Mob.State.get({:subapp, key}, 0) + 1)
    :ok
  end
end
