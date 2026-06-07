defmodule MobDemoKvBrowser.Migrations.CreateKvEntries do
  # Tier-3 plugin migration. mob_dev copies this into the host's migrations dir
  # at `--native` build, namespaced by the plugin's `repo_namespace` (so the
  # emitted filename is `20260106000000_kv_create_kv_entries.exs`), and the host's
  # Ecto.Migrator runs it alongside its own migrations.
  use Ecto.Migration

  def change do
    create table(:kv_entries) do
      add(:key, :string, null: false)
      add(:value, :string)
    end

    create(unique_index(:kv_entries, [:key]))
  end
end
