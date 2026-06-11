# Post-build probe for the Wave-2 photos + biometric extractions (Moto G via adb).
# Usage: mix run bughunt/probe_photos_biometric.exs
{connected, _} = MobDev.Connector.connect_all(cookie: :mob_secret)

node =
  connected
  |> Enum.map(& &1.node)
  |> Enum.find(fn n -> to_string(n) =~ "android_zy22dp6hfl" end)

if node == nil do
  IO.puts("MOTO G NOT CONNECTED — got: #{inspect(Enum.map(connected, & &1.node))}")
  System.halt(1)
end

rpc = fn m, f, a -> :rpc.call(node, m, f, a, 10_000) end

IO.inspect(node, label: "node")
IO.inspect(rpc.(Process, :whereis, [:mob_screen]), label: "mob_screen registered")

# Eager NIF load should now include the two new modules.
for mod <- [:mob_photos_nif, :mob_biometric_nif, :mob_camera_nif] do
  IO.inspect(rpc.(:erlang, :module_loaded, [mod]), label: "module_loaded #{mod}")
end

# The stripped core modules must be GONE on device.
for mod <- [Mob.Photos, Mob.Biometric] do
  IO.inspect(rpc.(Code, :ensure_loaded?, [mod]), label: "stripped #{inspect(mod)} absent (expect false)")
end

# Plugin APIs callable end-to-end: each returns the socket (:ok-shaped) and
# dispatches to the real NIF. biometric on a device with no enrollment/hardware
# delivers {:biometric, :not_available}; the photos picker OPENS THE SYSTEM UI
# (probe only invokes biometric — photos needs a hand on the device).
code = ~S"""
:mob_biometric_nif.biometric_authenticate("probe")
receive do
  {:biometric, result} -> {:delivered, result}
after
  8_000 -> :no_delivery_in_8s
end
"""

IO.inspect(rpc.(Code, :eval_string, [code]) |> elem(0), label: "biometric round-trip")
