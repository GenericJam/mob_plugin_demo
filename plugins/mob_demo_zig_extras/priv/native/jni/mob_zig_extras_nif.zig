//! mob_zig_extras_nif — trivial tier-1 ZIG plugin NIF.
//!
//! Proves the zig-plugin-NIF build path end to end: compiled via
//! `addZigObject` from `-Dplugin_zig_nifs`, reaching mob-core ERTS bindings
//! through the named import `@import("erts")` that build.zig wires for plugin
//! zig objects (the source lives outside mob/android/jni/ so it can't use the
//! sibling-relative `@import("mob_erts.zig")` mob_nif.zig itself uses).
//!
//! Unlike the C path there is no STATIC_ERLANG_NIF_LIBNAME: the
//! `mob_zig_extras_nif_nif_init` export below is named directly, and the
//! generated driver table references it (added by RegenDriverTab.resolved_nifs/0
//! for the activated plugin's manifest entry).
const erts = @import("erts");
const jni = @import("jni");

// mob-core exports (linked into the same .so).
extern fn get_jenv(attached: *c_int) ?*jni.JNIEnv;
extern var g_jvm: ?*jni.JavaVM;

// Cached by the nativeRegister thunk below (Android plugin bridge-class path).
var g_bridge_cls: jni.JClass = null;
var g_greet_mid: jni.JMethodID = null;

inline fn detachIfAttached(attached: c_int) void {
    if (attached != 0) {
        if (g_jvm) |jvm| jni.detachCurrentThread(jvm);
    }
}

// JNI thunk for MobZigExtrasBridge.nativeRegister(). The JVM passes the
// declaring class as `cls` for a static-method thunk, so we cache a global ref
// to it + the greet() method id directly — no FindClass, no classloader issue.
// Resolved by name from the loaded .so (zig `export fn` emits the C-ABI symbol).
export fn Java_io_mob_zigextras_MobZigExtrasBridge_nativeRegister(jenv: *jni.JNIEnv, cls: jni.JClass) callconv(.c) void {
    g_bridge_cls = jni.newGlobalRef(jenv, cls);
    g_greet_mid = jni.getStaticMethodID(jenv, cls, "greet", "()Ljava/lang/String;");
}

// kotlin_greet/0 — calls the cached Kotlin static MobZigExtrasBridge.greet()
// and returns its String as an Erlang charlist. Proves the NIF -> plugin Kotlin
// bridge call end to end.
fn kotlin_greet(env: ?*erts.ErlNifEnv, argc: c_int, argv: [*]const erts.ERL_NIF_TERM) callconv(.c) erts.ERL_NIF_TERM {
    _ = argc;
    _ = argv;
    if (g_bridge_cls == null or g_greet_mid == null) return erts.atom(env, "not_registered");

    var attached: c_int = 0;
    const jenv = get_jenv(&attached) orelse return erts.atom(env, "no_jenv");

    const jstr = jenv.*.CallStaticObjectMethod.?(jenv, g_bridge_cls, g_greet_mid);
    if (jstr == null) {
        detachIfAttached(attached);
        return erts.atom(env, "null_result");
    }

    const term = if (jni.getStringUTFChars(jenv, jstr)) |utf| blk: {
        const t = erts.enif_make_string(env, utf, erts.ERL_NIF_UTF8);
        jni.releaseStringUTFChars(jenv, jstr, utf);
        break :blk t;
    } else erts.atom(env, "no_utf");

    jni.deleteLocalRef(jenv, jstr);
    detachIfAttached(attached);
    return term;
}

fn answer(env: ?*erts.ErlNifEnv, argc: c_int, argv: [*]const erts.ERL_NIF_TERM) callconv(.c) erts.ERL_NIF_TERM {
    _ = argc;
    _ = argv;
    return erts.enif_make_int(env, 42);
}

fn ping(env: ?*erts.ErlNifEnv, argc: c_int, argv: [*]const erts.ERL_NIF_TERM) callconv(.c) erts.ERL_NIF_TERM {
    _ = argc;
    _ = argv;
    return erts.enif_make_atom(env, "pong");
}

const nif_funcs = [_]erts.ErlNifFunc{
    .{ .name = "answer", .arity = 0, .fptr = answer, .flags = 0 },
    .{ .name = "ping", .arity = 0, .fptr = ping, .flags = 0 },
    .{ .name = "kotlin_greet", .arity = 0, .fptr = kotlin_greet, .flags = 0 },
};

var entry: erts.ErlNifEntry = .{
    .major = erts.ERL_NIF_MAJOR_VERSION,
    .minor = erts.ERL_NIF_MINOR_VERSION,
    .name = "mob_zig_extras_nif",
    .num_of_funcs = nif_funcs.len,
    .funcs = &nif_funcs,
    .load = null,
    .reload = null,
    .upgrade = null,
    .unload = null,
    .vm_variant = erts.ERL_NIF_VM_VARIANT,
    .options = 1,
    .sizeof_ErlNifResourceTypeInit = erts.SIZEOF_ErlNifResourceTypeInit,
    .min_erts = erts.ERL_NIF_MIN_ERTS_VERSION,
};

/// The symbol the BEAM looks up via the static NIF table (driver_tab) to find
/// this NIF's `ErlNifEntry`. RegenDriverTab extern-declares it as
/// `mob_zig_extras_nif_nif_init` over C ABI.
pub export fn mob_zig_extras_nif_nif_init() callconv(.c) *erts.ErlNifEntry {
    return &entry;
}
