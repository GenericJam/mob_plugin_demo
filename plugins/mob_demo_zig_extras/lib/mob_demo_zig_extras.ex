defmodule MobDemoZigExtras do
  @moduledoc """
  Trivial tier-1 demo plugin shipping a real static **zig** NIF.

  `answer/0` returns `42` and `ping/0` returns `:pong` from
  `priv/native/jni/mob_zig_extras_nif.zig`, statically linked into the host
  binary on device via the zig plugin-NIF path (`lang: :zig` → `-Dplugin_zig_nifs`
  → `addZigObject`). On a host dev build the NIF isn't linked, so the calls
  raise `nif_not_loaded` until the native merge compiles + links the source.

  This is the zig counterpart to `MobDemoHapticExtras` — its job is to prove
  the build pipeline, not to do anything useful.
  """

  defdelegate answer, to: :mob_zig_extras_nif
  defdelegate ping, to: :mob_zig_extras_nif

  @doc """
  Calls the plugin's own Kotlin bridge class (`io.mob.zigextras.MobZigExtrasBridge`)
  via the NIF and returns its `greet()` string as a charlist. Proves the Android
  plugin bridge-class capability end to end (registration + NIF->Kotlin call).
  Returns `:not_registered` if the startup bootstrap hasn't cached the class yet.
  """
  defdelegate kotlin_greet, to: :mob_zig_extras_nif
end
