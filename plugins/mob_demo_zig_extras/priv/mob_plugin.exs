%{
  name: :mob_demo_zig_extras,
  mob_version: "~> 0.6",
  plugin_spec_version: 1,
  description: "Demo tier-1 plugin: a trivial static ZIG NIF (proves the zig plugin-NIF path)",
  nifs: [
    # lang: :zig routes this through -Dplugin_zig_nifs + addZigObject instead
    # of the C path. :module is the C/Erlang NIF name (a valid C token) — the
    # source's `export fn mob_zig_extras_nif_nif_init()` is the static init
    # symbol the generated driver table references.
    %{module: :mob_zig_extras_nif, native_dir: "priv/native/jni", lang: :zig}
  ],
  android: %{
    # Plugin-owned Kotlin bridge class (own package). mob_dev copies it into the
    # app Kotlin sourceSet and generates MobPluginBootstrap.registerAll() to call
    # MobZigExtrasBridge.register() at startup, which caches the jclass natively.
    # The nativeRegister thunk + nif->Kotlin call live in the zig NIF above (no
    # separate jni_source needed — zig exports the Java_ symbol directly).
    bridge_kt: "priv/native/android/MobZigExtrasBridge.kt",
    bridge_class: "io.mob.zigextras.MobZigExtrasBridge"
  }
}
