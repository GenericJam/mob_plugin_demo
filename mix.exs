defmodule MobPluginDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :mob_plugin_demo,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: false,
      deps: deps(),
      erlc_paths: ["src"],
      erlc_options: [:debug_info]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:mob, path: "/Users/kevin/code/mob", override: true},
      {:mob_dev,
       path: "/Users/kevin/code/mob_dev/.claude/worktrees/plugin-host-config",
       only: :dev,
       runtime: false},
      # Phase 1 prototype plugins (local path deps).
      {:mob_palette_demo, path: "plugins/mob_palette_demo"},
      {:mob_demo_haptic_extras, path: "plugins/mob_demo_haptic_extras"},
      {:mob_demo_zig_extras, path: "plugins/mob_demo_zig_extras"},
      {:mob_demo_signature_pad, path: "plugins/mob_demo_signature_pad"},
      {:mob_bluetooth, path: "/Users/kevin/code/mob_bluetooth"},
      {:ecto_sqlite3, "~> 0.18"},
      # Code quality — Credo + ex_slop (catches AI-generated patterns
      # like blanket rescue, narrator docs, redundant Enum chains, etc).
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4.2", only: [:dev, :test], runtime: false}
    ]
  end
end
