%% mob_zig_extras_nif — Erlang NIF module for the trivial tier-1 ZIG demo plugin.
%%
%% The zig side (priv/native/jni/mob_zig_extras_nif.zig) registers answer/0 and
%% ping/0 under this module name via its `mob_zig_extras_nif_nif_init` export.
%% On device the NIF is statically linked into the host binary; on a host dev
%% build it isn't linked, so on_load tolerates the load failure and the stubs
%% fall back to nif_error until the native merge links the .zig in.
-module(mob_zig_extras_nif).
-export([answer/0, ping/0]).
-on_load(init/0).

init() ->
    case erlang:load_nif("mob_zig_extras_nif", 0) of
        ok -> ok;
        {error, _} -> ok
    end.

answer() ->
    erlang:nif_error(nif_not_loaded).

ping() ->
    erlang:nif_error(nif_not_loaded).
