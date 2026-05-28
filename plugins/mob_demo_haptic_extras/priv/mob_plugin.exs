%{
  name: :mob_demo_haptic_extras,
  mob_version: "~> 0.6",
  plugin_spec_version: 1,
  description: "Demo tier-1 plugin: a trivial static NIF",
  nifs: [
    # :module is the C/Erlang NIF name (a valid C token), NOT an Elixir module
    # — ERL_NIF_INIT uses it as both the registered module name and the
    # static init symbol prefix (haptic_extras_nif_nif_init).
    %{module: :haptic_extras_nif, native_dir: "priv/native/jni"}
  ],
  android: %{
    gradle_deps: []
  },
  ios: %{
    frameworks: ["CoreHaptics"]
  }
}
