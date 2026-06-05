%% mob_demo_perm_nif — Erlang NIF module for the permission-registry demo plugin.
%%
%% The C side (priv/native/jni/mob_demo_perm_nif.c) is statically linked into
%% the host binary. Its load callback registers the iOS :demo_perm permission
%% handler with core (mob_register_permission_handler). On a host dev build the
%% NIF isn't linked, so on_load tolerates the failure and ping/0 falls back to a
%% nif_error until the native merge links it.
-module(mob_demo_perm_nif).
-export([ping/0, load_result/0]).
-on_load(init/0).

init() ->
    R = erlang:load_nif("mob_demo_perm_nif", 0),
    persistent_term:put({?MODULE, load_result}, R),
    case R of
        ok -> ok;
        {error, _} -> ok
    end.

load_result() ->
    persistent_term:get({?MODULE, load_result}, undefined).

ping() ->
    erlang:nif_error(nif_not_loaded).
