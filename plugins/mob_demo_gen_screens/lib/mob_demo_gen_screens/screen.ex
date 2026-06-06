defmodule MobDemoGenScreens.Screen do
  @moduledoc "Shared screen the spec-v2 generator points each generated route at."
  use Mob.Screen

  def mount(_params, _session, socket), do: {:ok, socket}

  def render(_assigns) do
    ~MOB"""
    <Scroll background={:background}>
      <Column background={:background} padding={:space_lg}>
        <Text text="Generated screen (plugin, spec-v2)" text_size={:xl} text_color={:on_surface} padding={:space_sm} />
      </Column>
    </Scroll>
    """
  end
end
