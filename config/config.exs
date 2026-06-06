import Config

# Register the Repo so Mix tasks (mix ecto.create, mix ecto.migrate) can
# discover it. The actual database path is configured at runtime in
# MobPluginDemo.Repo.init/2 via the MOB_DATA_DIR environment variable.
config :mob_plugin_demo, ecto_repos: [MobPluginDemo.Repo]

# Wire the Repo into Mob.ScreenState so screens using `vsn:` get automatic
# state persistence. Remove this line to disable screen state persistence.
config :mob, :repo, MobPluginDemo.Repo

# Host config read by the mob_demo_gen_screens tier-3 screens_generator
# (spec-v2 codegen) — it emits one screen per section, audited via
# the plugin's :host_config_keys.
config :mob_plugin_demo, :gen_sections, [:dashboard, :reports]
