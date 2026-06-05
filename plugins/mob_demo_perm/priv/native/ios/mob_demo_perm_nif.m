/* Permission-registry demo plugin NIF — Objective-C (iOS only).
 *
 * Proves two things end-to-end on a physical iPhone:
 *   1. the extensible permission registry: at NIF load the load callback
 *      registers a handler for the :demo_perm capability (core knows nothing
 *      about it) via the exported core symbol mob_register_permission_handler;
 *      core's nif_request_permission falls through to it and it delivers
 *      {:permission, :demo_perm, :granted} via raw enif_send.
 *   2. the iOS ObjC plugin-NIF compile path: this is a `.m` (manifest
 *      lang: :objc, platform: :ios) so build.zig compiles it as Objective-C
 *      with -fobjc-arc + -fmodules — the path every Wave-2 iOS plugin needs to
 *      drive an Apple framework (CoreLocation, etc.). We touch Foundation
 *      (NSString) so the build genuinely exercises ObjC + ARC.
 *
 * Android proves the registry via the Kotlin MobPermissionProvider bridge
 * instead (this NIF is platform: :ios, so it is not compiled there).
 */
#import <Foundation/Foundation.h>
#include <erl_nif.h>

/* Defined in core mob's ios/mob_nif.m, linked into the same static binary. */
extern void mob_register_permission_handler(const char *cap, void (*fn)(ErlNifPid));

static void mob_demo_perm_request_permission(ErlNifPid pid) {
  // An ObjC value, to make this a genuine Objective-C + ARC compile.
  NSString *status = @"granted";
  ErlNifEnv *env = enif_alloc_env();
  ERL_NIF_TERM msg =
      enif_make_tuple3(env, enif_make_atom(env, "permission"),
                       enif_make_atom(env, "demo_perm"), enif_make_atom(env, status.UTF8String));
  enif_send(NULL, &pid, env, msg);
  enif_free_env(env);
}

static int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
  (void)env;
  (void)priv_data;
  (void)load_info;
  mob_register_permission_handler("demo_perm", mob_demo_perm_request_permission);
  return 0;
}

static ERL_NIF_TERM ping(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  (void)argc;
  (void)argv;
  return enif_make_atom(env, "pong");
}

static ErlNifFunc nif_funcs[] = {
    {"ping", 0, ping},
};

ERL_NIF_INIT(mob_demo_perm_nif, nif_funcs, load, NULL, NULL, NULL)
