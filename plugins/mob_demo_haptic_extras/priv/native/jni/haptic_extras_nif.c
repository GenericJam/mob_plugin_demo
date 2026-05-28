/* Tier-1 demo plugin NIF — a real (minimal) static NIF.
 *
 * buzz/0 returns the atom :ok. The compile-time merge (native_build part 2)
 * links this into the host binary, compiling it with -DSTATIC_ERLANG_NIF so
 * ERL_NIF_INIT emits the static init symbol haptic_extras_nif_nif_init(),
 * which the generated driver table references.
 *
 * The NIF module name (haptic_extras_nif) must be a valid C token because
 * ERL_NIF_INIT uses it both as the registered Erlang module name and as the
 * init symbol prefix — hence the Erlang stub module of the same name rather
 * than an Elixir module.
 */
#include <erl_nif.h>

static ERL_NIF_TERM buzz(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  (void)argc;
  (void)argv;
  return enif_make_atom(env, "ok");
}

static ErlNifFunc nif_funcs[] = {
    {"buzz", 0, buzz},
};

ERL_NIF_INIT(haptic_extras_nif, nif_funcs, NULL, NULL, NULL, NULL)
