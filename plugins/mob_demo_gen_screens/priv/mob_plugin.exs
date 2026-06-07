%{
  name: :mob_demo_gen_screens,
  mob_version: "~> 0.6",
  plugin_spec_version: 2,
  description: "Tier-3 spec-v2 demo: screens generated at build from host config.",
  # Spec-v2 :screens_generator runs at build time (under the host-config audit)
  # and emits one screen per configured section. host_config_keys declares which
  # host config keys the generator is allowed to read — an undeclared read fails
  # the build.
  screens_generator: {MobDemoGenScreens.Generator, :generate, []},
  host_config_keys: [:gen_sections],
  # Multi-tier composition: this plugin ALSO carries a tier-3 migration and
  # tier-4 lifecycle/settings/notifications, all with names distinct from
  # mob_demo_subapp's, so the conflict surface stays clean and multiple plugins
  # stack per tier at runtime.
  migrations: %{
    repo_namespace: "gen_",
    migrations_dir: "priv/repo/migrations"
  },
  lifecycle: %{
    on_start: {MobDemoGenScreens, :start, []},
    supervised: [MobDemoGenScreens.Worker]
  },
  settings: %{
    schema: [%{key: :verbose, type: :boolean, default: false}]
  },
  notifications: %{
    handlers: [
      %{match: %{type: "gen_ping"}, handler: {MobDemoGenScreens.Notifications, :handle, 1}}
    ]
  }
}
