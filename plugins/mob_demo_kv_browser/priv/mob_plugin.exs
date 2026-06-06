%{
  name: :mob_demo_kv_browser,
  mob_version: "~> 0.6",
  plugin_spec_version: 1,
  description: "Tier-3 multi-screen demo: a two-screen key/value browser.",
  # Tier 3: ship whole screens. The host registers them as navigable
  # destinations at boot (by default_route) and chooses where to surface them.
  screens: [
    %{module: MobDemoKvBrowser.ListScreen, default_route: "/kv/list"},
    %{module: MobDemoKvBrowser.DetailScreen, default_route: "/kv/detail"}
  ],
  # Tier-3 migration: build-time copied into the host migrations dir
  # (namespaced, version-preserving), run by the host's existing Ecto.Migrator.
  migrations: %{repo_namespace: "kv_", migrations_dir: "priv/repo/migrations"},
  # Tier-3 assets: images are build-copied into the host bundle and addressable
  # from a screen via `plugin://mob_demo_kv_browser/<file>`.
  assets: %{images: ["priv/assets/kv_icon.png"]}
}
