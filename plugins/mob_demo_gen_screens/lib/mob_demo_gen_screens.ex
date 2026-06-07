defmodule MobDemoGenScreens do
  @moduledoc """
  Multi-tier composition fixture. Besides its tier-3 `screens_generator`, this
  plugin also carries tier-4 lifecycle + settings + notifications and a tier-3
  migration — so a single plugin spans several tiers, and (alongside
  `mob_demo_subapp` + `mob_demo_kv_browser`) multiple plugins stack per tier:
  two supervised workers, two notification handlers, two settings owners, and
  two namespaced migrations all active at once.

  Each hook records an observable side-effect in `Mob.State` (namespaced `:gen`,
  distinct from subapp's `:subapp`) so a device probe can confirm composition.
  """

  @doc "lifecycle.on_start — runs at boot under the plugin supervisor."
  def start do
    Mob.State.put({:gen, :started}, true)
    :ok
  end

  @doc "Reads back every observable side-effect for the device probe."
  def probe do
    %{
      started: Mob.State.get({:gen, :started}, false),
      worker_alive: is_pid(Process.whereis(MobDemoGenScreens.Worker)),
      last_notification: Mob.State.get({:gen, :last_notification}, nil),
      verbose: Mob.Plugins.get_setting(:mob_demo_gen_screens, :verbose)
    }
  end
end
