defmodule MobDemoSignaturePad do
  @moduledoc """
  Tier-2 demo plugin: a native SignaturePad component, integrated via the
  existing `Mob.UI.native_view` + `Mob.Component` mechanism.

  The implementation reuses mob's existing native-view path: a `Mob.Component`
  module (`MobDemoSignaturePad.View`) owns Elixir-side state; the corresponding
  Kotlin/Swift factory is registered on the native side under the conventional
  name `MobDemoSignaturePad_View` (Elixir-module name stripped of `Elixir.`
  prefix, dots replaced with underscores).

  Until the merge engine wires plugin Kotlin/Swift into the build automatically,
  the host app developer copies the plugin's `priv/native/android/MobSignaturePad.kt`
  into `MobBridge.kt` and arranges `MobSignaturePadPlugin.register()` to run at
  startup. The drawing is a no-op rounded rectangle — focus is on the
  registration/dispatch path, not the rendered content.
  """

  @doc """
  Returns a `Mob.UI.native_view` node for the SignaturePad component.

      ~MOB"\""
      <Column>
        {MobDemoSignaturePad.signature_pad(id: :sig, bg_color: "#3366cc", corner_radius: 12)}
      </Column>
      "\""

  `:id` must be unique on the screen. Defaults to `:signature_pad` if omitted.
  """
  @spec signature_pad(keyword()) :: map()
  def signature_pad(opts \\ []) do
    {id, props} = Keyword.pop(opts, :id, :signature_pad)
    Mob.UI.native_view(MobDemoSignaturePad.View, [{:id, id} | props])
  end
end
