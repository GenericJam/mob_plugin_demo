defmodule MobPluginDemo.Blog.Post do
  @moduledoc """
  Demo Ash resource for the mob_ash plugin: ETS data layer (device-safe,
  process-less), seeded with a couple of posts in `App.on_start/0`.
  """
  use Ash.Resource,
    domain: MobPluginDemo.Blog,
    data_layer: Ash.DataLayer.Ets

  attributes do
    uuid_primary_key :id
    attribute :title, :string, public?: true, allow_nil?: false
    attribute :body, :string, public?: true
    attribute :views, :integer, public?: true, default: 0
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end
end

defmodule MobPluginDemo.Blog do
  @moduledoc "Demo Ash domain registered in `config :mob_plugin_demo, :ash_domains`."
  use Ash.Domain

  resources do
    resource MobPluginDemo.Blog.Post
  end
end
