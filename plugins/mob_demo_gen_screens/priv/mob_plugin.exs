%{
  name: :mob_demo_gen_screens,
  mob_version: "~> 0.6",
  plugin_spec_version: 2,
  description: "Tier-3 spec-v2 demo: screens generated at build from host config.",
  # Spec-v2 :screens_generator runs at build time (under the host-config audit)
  # and emits one screen per configured section. host_config_keys declares which
  # host config keys the generator is allowed to read — an undeclared read fails
  # the build.
  screens_generator: {MobDemoGenScreens.Generator, :generate, []},
  host_config_keys: [:gen_sections]
}
