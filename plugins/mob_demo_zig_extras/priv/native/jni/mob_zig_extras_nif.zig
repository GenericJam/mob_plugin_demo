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
