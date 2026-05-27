defmodule MobDemoHapticExtras do
  @moduledoc """
  Tier-1 demo plugin: the smallest plugin that ships native code.

  Exercises the manifest's `:nifs` / `:android` / `:ios` sections. The native
  side is a stub (one function returning `:ok`); the focus is the build
  pipeline, not the haptics. Real static-NIF loading wires up when the
  compile-time merge engine lands.
  """

  defdelegate buzz, to: MobDemoHapticExtras.Nif
end

defmodule MobDemoHapticExtras.Nif do
  @moduledoc false

  # Placeholder until the merge engine statically links the NIF into the host's
  # libpigeon.so. Until then this is a plain Elixir stub so the wrapper loads.
  def buzz, do: :ok
end
