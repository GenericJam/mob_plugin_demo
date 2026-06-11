# Direct WiFi dist probe of the PHYSICAL iPhone (USB unplugged, so the
# MobDev.Connector can't see it — connect straight to its node instead).
# Usage: elixir --name probe@<mac-ip> --cookie mob_secret bughunt/probe_iphone_wifi.exs <phone-ip>
phone_ip = System.argv() |> List.first() || "10.0.0.120"
target = :"mob_plugin_demo_ios@#{phone_ip}"

true = Node.alive?() or raise "start with --name probe@<mac-ip>"

case Node.connect(target) do
  true -> IO.puts("connected to #{target}")
  other -> raise "Node.connect(#{target}) -> #{inspect(other)}"
end

rpc = fn m, f, a -> :rpc.call(target, m, f, a, 10_000) end

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
# this bundle is a fresh --native with the current manifest, so BOTH camera
# and screencast must be true; a false here is a real eager-loader bug.
for mod <- [:mob_camera_nif, :mob_screencast_nif, :mob_location_nif] do
  IO.inspect(rpc.(:erlang, :module_loaded, [mod]), label: "module_loaded #{mod}")
end

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
