// Trivial plugin-owned Kotlin bridge class — proves the Android plugin
// bridge-class capability (mob_dev decisions/2026-05-28-android-plugin-bridge-classes.md).
//
// Lives in the plugin's OWN package (io.mob.zigextras), copied into the app's
// Kotlin sourceSet by mob_dev at build time. `register()` is called at startup
// by the generated io.mob.plugin.MobPluginBootstrap.registerAll() (invoked from
// MainActivity.onCreate). `nativeRegister` resolves to the zig export
// Java_io_mob_zigextras_MobZigExtrasBridge_nativeRegister, which caches this
// class + the greet() method id from the jclass the JVM passes the thunk — so
// there's no FindClass / classloader problem.
package io.mob.zigextras

object MobZigExtrasBridge {
  @JvmStatic external fun nativeRegister()

  @JvmStatic
  fun register() {
    nativeRegister()
  }

  // The static method the plugin NIF calls back into via CallStaticObjectMethod.
  @JvmStatic
  fun greet(): String = "hello from kotlin bridge"
}
