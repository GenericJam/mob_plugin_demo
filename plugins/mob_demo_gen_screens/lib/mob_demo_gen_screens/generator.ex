defmodule MobDemoGenScreens.Generator do
  @moduledoc """
  Tier-3 spec-v2 screens generator. Runs at build time (under the host-config
  audit) and emits one screen entry per section configured in the host's
  `:gen_sections`. Every entry points at the shared `MobDemoGenScreens.Screen`
  module with a per-section route, proving the generator produced N screens from
  host config.
  """

  @doc "Emits `[%{module, default_route}]`, one per host-configured section."
  def generate do
    # Read via apply/3 so the plugin needn't compile-depend on mob_dev; the
    # audit context (set by mob_dev when it runs this generator) enforces that
    # :gen_sections is declared in the manifest's :host_config_keys.
    sections = apply(MobDev.Plugin, :host_config, [:mob_plugin_demo, :gen_sections, [:default]])

    for section <- sections do
      %{module: MobDemoGenScreens.Screen, default_route: "/gen/#{section}"}
    end
  end
end
