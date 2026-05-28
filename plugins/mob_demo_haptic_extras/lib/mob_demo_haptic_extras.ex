defmodule MobDemoHapticExtras do
  @moduledoc """
  Tier-1 demo plugin: the smallest plugin that ships a real static NIF.

  `buzz/0` calls into the `haptic_extras_nif` Erlang NIF module
  (priv/native/jni/haptic_extras.c), statically linked into the host binary
  on device. On a host dev build the NIF isn't linked, so calling `buzz/0`
  there raises `nif_not_loaded` — it only runs once the native merge (part 2)
  compiles + links the source into the binary.
  """

  defdelegate buzz, to: :haptic_extras_nif
end
