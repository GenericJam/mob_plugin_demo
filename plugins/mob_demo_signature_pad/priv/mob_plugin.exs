%{
  name: :mob_demo_signature_pad,
  mob_version: "~> 0.6",
  plugin_spec_version: 1,
  description: "Demo tier-2 plugin: a native SignaturePad component (Mob.Component)",

  # iOS: ship the SwiftUI view source for the merge engine to compile in
  # alongside the host's project_swift_sources. No extra frameworks needed
  # (SwiftUI + Foundation are already linked by the base mob app).
  ios: %{
    swift_files: ["priv/native/ios/MobSignaturePadView.swift"]
  },

  ui_components: [
    %{
      tag: "SignaturePad",
      atom: :signature_pad,
      props: [:bg_color, :corner_radius],
      # Native registration name = <Elixir module>, stripped of `Elixir.` and
      # with dots replaced by `_`. This is what Mob.Component.module_name/1
      # emits at render time as the `:module` prop, and what the iOS / Android
      # MobNativeViewRegistry looks up.
      #
      # `swift_struct` is the SwiftUI struct the iOS bootstrap codegen
      # instantiates: `<swift_struct>(props: props)`. The struct name is not
      # derivable from `view_module` (the view_module is the Elixir-module
      # convention; the struct is whatever the plugin author named the
      # SwiftUI type), so the manifest declares it explicitly.
      ios: %{
        view_module: "MobDemoSignaturePad_View",
        swift_struct: "MobSignaturePadView"
      },
      android: %{composable: "MobDemoSignaturePad_View"}
    }
  ]
}
