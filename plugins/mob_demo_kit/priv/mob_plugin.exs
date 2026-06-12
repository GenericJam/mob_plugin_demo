%{
  name: :mob_demo_kit,
  mob_version: "~> 0.6",
  plugin_spec_version: 1,
  description: "Pure-Elixir composite UI kit (the Mishka-shaped expand: form) — no native code",
  # The third form of ui_components: composites that EXPAND to built-in widget
  # trees in core's render pipeline. Pure Elixir, hot-pushable.
  ui_components: [
    %{tag: "DemoCard", atom: :demo_card, expand: {MobDemoKit.Card, :expand}},
    %{tag: "DemoCombobox", atom: :demo_combobox, expand: {MobDemoKit.Combobox, :expand}}
  ]
}
