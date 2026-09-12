defmodule MobDemoGenScreens.Migrations.CreateGenLog do
  # Second tier-3 plugin migration (distinct repo_namespace "gen_"). Proves
  # cross-plugin migration composition: this and kv_browser's migration both get
  # namespaced + copied into the host migrations dir and applied, with distinct
  # filenames (..._gen_create_gen_log.exs vs ..._kv_create_kv_entries.exs).
  use Ecto.Migration

  def change do
    create table(:gen_log) do
      add(:section, :string, null: false)
    end
  end
end
