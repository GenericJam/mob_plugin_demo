defmodule MobDemoKit.Card do
  @moduledoc """
  `<DemoCard title="...">children</DemoCard>` — a raised surface with a title
  row wrapping its children. Pure-Elixir composite: expands to built-in
  widgets, no native code.
  """
  import Mob.Sigil

  @doc "Composite expander (registered via the manifest expand: form)."
  @spec expand(map(), [map()], map()) :: map()
  def expand(props, children, _ctx) do
    title = Map.get(props, :title, "")

    ~MOB"""
    <Column background={:surface_raised} corner_radius={12} padding={:space_md}>
      <Text text={title} text_size={:lg} text_color={:on_surface} />
      <Spacer size={8} />
      {children}
    </Column>
    """
  end
end
