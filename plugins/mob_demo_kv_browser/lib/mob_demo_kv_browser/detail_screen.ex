defmodule MobDemoKvBrowser.DetailScreen do
  @moduledoc "Tier-3 plugin screen: shows one key/value, pushed from the list screen."
  use Mob.Screen

  def mount(params, _session, socket) do
    key = params[:key] || params["key"] || "?"
    value = Map.get(MobDemoKvBrowser.ListScreen.entries(), key, "(unknown)")

    {:ok,
     socket
     |> Mob.Socket.assign(:key, key)
     |> Mob.Socket.assign(:value, value)}
  end

  def render(assigns) do
    ~MOB"""
    <Scroll background={:background}>
      <Column background={:background} padding={:space_lg}>
        <Text text="KV Detail (plugin)" text_size={:xl} text_color={:on_surface} padding={:space_sm} />
        <Spacer size={16} />
        <Text text={"key: " <> assigns.key} text_size={:lg} text_color={:primary} padding={4} />
        <Text text={"value: " <> assigns.value} text_size={:lg} text_color={:on_surface} padding={4} />
        <Spacer size={24} />
        <Button text="Back" background={:primary} text_color={:on_primary} text_size={:lg}
                padding={:space_md} on_tap={{self(), :back}} />
      </Column>
    </Scroll>
    """
  end

  def handle_info({:tap, :back}, socket), do: {:noreply, Mob.Socket.pop_screen(socket)}
  def handle_info(_msg, socket), do: {:noreply, socket}
end
