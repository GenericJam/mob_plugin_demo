defmodule MobDemoSubapp.SettingsScreen do
  @moduledoc "Tier-4 settings editor screen (the host pushes this on demand)."
  use Mob.Screen

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> Mob.Socket.assign(:sound, Mob.Plugins.get_setting(:mob_demo_subapp, :sound))
     |> Mob.Socket.assign(:channel, Mob.Plugins.get_setting(:mob_demo_subapp, :channel))}
  end

  def render(assigns) do
    ~MOB"""
    <Scroll background={:background}>
      <Column background={:background} padding={:space_lg}>
        <Text text="Sub-app Settings (plugin)" text_size={:xl} text_color={:on_surface} padding={:space_sm} />
        <Spacer size={16} />
        <Text text={"sound: " <> inspect(assigns.sound)} text_size={:lg} text_color={:primary} padding={4} />
        <Text text={"channel: " <> assigns.channel} text_size={:lg} text_color={:on_surface} padding={4} />
        <Spacer size={16} />
        <Button text="Toggle sound" background={:primary} text_color={:on_primary} text_size={:lg}
                padding={:space_md} on_tap={{self(), :toggle}} />
      </Column>
    </Scroll>
    """
  end

  def handle_event("toggle", _p, socket) do
    new = not socket.assigns.sound
    Mob.Plugins.put_setting(:mob_demo_subapp, :sound, new)
    {:noreply, Mob.Socket.assign(socket, :sound, new)}
  end
end
