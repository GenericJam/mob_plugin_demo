%{
  name: :mob_demo_subapp,
  mob_version: "~> 0.6",
  plugin_spec_version: 1,
  description: "Tier-4 embedded sub-app demo: lifecycle + settings + notifications.",
  # Tier 4: the plugin lives under the host's supervisor — on_start runs at boot,
  # a supervised worker joins the tree, and fore/background hooks fire on OS
  # transitions. Each hook records an observable side-effect in Mob.State so a
  # device probe can confirm it ran.
  lifecycle: %{
    on_start: {MobDemoSubapp, :start, []},
    supervised: [MobDemoSubapp.Worker],
    on_resume: {MobDemoSubapp, :on_resume, []},
    on_background: {MobDemoSubapp, :on_background, []}
  },
  settings: %{
    schema: [
      %{key: :sound, type: :boolean, default: true},
      %{key: :channel, type: :string, default: "#general"}
    ],
    editor_screen: MobDemoSubapp.SettingsScreen
  },
  notifications: %{
    handlers: [
      %{match: %{type: "subapp_ping"}, handler: {MobDemoSubapp.Notifications, :handle, 1}}
    ]
  }
}
