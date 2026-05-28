%{
  name: :mob_demo_signature_pad,
  mob_version: "~> 0.6",
  plugin_spec_version: 1,
  description: "Demo tier-2 plugin: a native SignaturePad component (Mob.Component)",

  ui_components: [
    %{
      tag: "SignaturePad",
      atom: :signature_pad,
      props: [:bg_color, :corner_radius],
      # Native registration name = <Elixir module>, stripped of `Elixir.` and
      # with dots replaced by `_`. This is what Mob.Component.module_name/1
      # emits at render time as the `:module` prop, and what the iOS / Android
      # MobNativeViewRegistry looks up.
      ios: %{view_module: "MobDemoSignaturePad_View"},
      android: %{composable: "MobDemoSignaturePad_View"}
    }
  ]
}
