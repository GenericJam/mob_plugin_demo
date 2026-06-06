defmodule MobDemoKvBrowser.Repo.Migrations.CreateKvEntries do
  @moduledoc "Tier-3 plugin migration — namespaced + copied into the host at build."
  use Ecto.Migration

  def change do
    create table(:kv_entries) do
      add(:key, :string, null: false)
      add(:value, :string)
    end
  end
end
