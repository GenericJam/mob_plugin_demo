%% haptic_extras_nif — Erlang NIF module for the tier-1 demo plugin.
%%
%% The C side (priv/native/jni/haptic_extras.c) registers buzz/0 under this
%% module name via ERL_NIF_INIT. On device the NIF is statically linked into
%% the host binary; on a host dev build it isn't linked, so on_load tolerates
%% the load failure (returning ok keeps the module loadable) and buzz/0 falls
%% back to a nif_error until the native merge links it.
-module(haptic_extras_nif).
-export([buzz/0]).
-on_load(init/0).

init() ->
    case erlang:load_nif("haptic_extras_nif", 0) of
        ok -> ok;
        {error, _} -> ok
    end.

buzz() ->
    erlang:nif_error(nif_not_loaded).
