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
  ]
}
