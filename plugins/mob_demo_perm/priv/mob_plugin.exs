%{
  name: :mob_demo_perm,
  mob_version: "~> 0.6",
  plugin_spec_version: 1,
  description: "Demo plugin: proves the extensible permission registry (:demo_perm capability)",
  nifs: [
    # iOS only (lang: :objc -> compiled as Objective-C). This NIF's load callback
    # registers the :demo_perm handler with core's permission registry. Android
    # needs no NIF — its registry path is the MobPermissionProvider bridge below.
    %{module: :mob_demo_perm_nif, native_dir: "priv/native/ios", lang: :objc, platform: :ios}
  ],
  permissions: [
    # iOS handler is self-registered at NIF load (runtime registry); the symbol
    # name is documented here for audits. Android provides the mapping via the
    # bridge implementing MobPermissionProvider (auto-discovered, no entry).
    %{capability: :demo_perm, ios: %{handler: "mob_demo_perm_request_permission"}}
  ],
  android: %{
    bridge_kt: "priv/native/android/MobDemoPermBridge.kt",
    bridge_class: "io.mob.demoperm.MobDemoPermBridge"
  }
}
