defmodule MobDemoPerm do
  @moduledoc """
  Demo plugin that proves the extensible permission registry: it owns a
  `:demo_perm` capability that core knows nothing about.

  - **iOS**: the `mob_demo_perm_nif` static NIF's load callback registers a
    handler with core's permission registry (`mob_register_permission_handler`);
    `Mob.Permissions.request(socket, :demo_perm)` falls through core to that
    handler, which immediately delivers `{:permission, :demo_perm, :granted}`.
  - **Android**: `io.mob.demoperm.MobDemoPermBridge` implements
    `MobPermissionProvider`, mapping `:demo_perm` to `INTERNET` (a normal,
    already-granted permission), so core's `MobBridge.request_permission`
    delivers `:granted` without a dialog.

  `ping/0` just confirms the NIF linked.
  """

  defdelegate ping, to: :mob_demo_perm_nif
end
