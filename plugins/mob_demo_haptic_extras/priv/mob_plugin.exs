%{
  name: :mob_demo_haptic_extras,
  mob_version: "~> 0.6",
  plugin_spec_version: 1,
  description: "Demo tier-1 plugin: a trivial static NIF",
  nifs: [
    %{module: MobDemoHapticExtras.Nif, native_dir: "priv/native/jni"}
  ],
  android: %{
    gradle_deps: []
  },
  ios: %{
    frameworks: ["CoreHaptics"]
  }
}
