# One-shot dist probe of the PHYSICAL iPhone demo app post camera/screencast deploy.
# The phone's node is mob_plugin_demo_ios@<wifi-ip> (NO serial suffix); the sim's is
# mob_plugin_demo_ios_<serial>@127.0.0.1 — match the unsuffixed name only.
{connected, _failed} = MobDev.Connector.connect_all(cookie: :mob_secret)

node =
  connected
  |> Enum.map(& &1.node)
  |> Enum.find(fn n -> to_string(n) =~ ~r/^mob_plugin_demo_ios@/ end)

if node == nil do
  IO.puts("PHYSICAL iPHONE NODE NOT CONNECTED — got: #{inspect(Enum.map(connected, & &1.node))}")
  System.halt(1)
end

rpc = fn m, f, a -> :rpc.call(node, m, f, a, 10_000) end

IO.inspect(node, label: "PHONE node")
IO.inspect(rpc.(System, :version, []), label: "elixir version")
IO.inspect(rpc.(Process, :whereis, [:mob_screen]), label: "mob_screen registered")

IO.inspect(
  rpc.(Mob.Plugins, :screens, [])
  |> then(fn
    l when is_list(l) -> {length(l), Enum.map(l, & &1[:default_route])}
    other -> other
  end),
  label: "plugin screens"
)

# Eager NIF-module load (the systemic iOS permission fix, mob e66eccb) —
# on the phone the --native bundle has the CURRENT manifest, so BOTH camera
# and screencast must be true; a false here is a real eager-loader bug.
for mod <- [:mob_camera_nif, :mob_screencast_nif, :mob_location_nif] do
  IO.inspect(rpc.(:erlang, :module_loaded, [mod]), label: "module_loaded #{mod}")
end

IO.inspect(rpc.(:code, :which, [:mob_camera_nif]), label: "camera beam path (on-device)")

# Tier-4 lifecycle/settings sanity
IO.inspect(
  rpc.(Mob.Plugins, :settings, [])
  |> then(fn
    l when is_list(l) -> length(l)
    other -> other
  end),
  label: "settings owners"
)

IO.inspect(rpc.(Code, :ensure_loaded?, [MobCamera]), label: "MobCamera loaded")

# Migrations applied (kv_ + gen_ namespaced)
IO.inspect(
  rpc.(Ecto.Migrator, :migrations, [MobPluginDemo.Repo])
  |> then(fn
    l when is_list(l) -> Enum.map(l, fn {state, version, _name} -> {state, version} end)
  end),
  label: "migrations"
)
