defmodule MobDemoKvBrowser.ListScreen do
  @moduledoc "Tier-3 plugin screen: lists keys; tapping one pushes the detail screen."
  use Mob.Screen

  @entries %{
    "alpha" => "first letter",
    "beta" => "second letter",
    "gamma" => "third letter"
  }

  def entries, do: @entries

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(_assigns) do
    ~MOB"""
    <Scroll background={:background}>
      <Column background={:background} padding={:space_lg}>
        <Text text="KV Browser (plugin)" text_size={:xl} text_color={:on_surface} padding={:space_sm} />
        <Spacer size={16} />
        {open_button("alpha", :open_alpha)}
        <Spacer size={12} />
        {open_button("beta", :open_beta)}
        <Spacer size={12} />
        {open_button("gamma", :open_gamma)}
      </Column>
    </Scroll>
    """
  end

  def handle_event("open_alpha", _p, socket), do: open(socket, "alpha")
  def handle_event("open_beta", _p, socket), do: open(socket, "beta")
  def handle_event("open_gamma", _p, socket), do: open(socket, "gamma")

  defp open(socket, key) do
    {:noreply, Mob.Socket.push_screen(socket, MobDemoKvBrowser.DetailScreen, %{key: key})}
  end

  defp open_button(label, tag) do
    tap = {self(), tag}

    ~MOB"""
    <Button text={label} background={:primary} text_color={:on_primary} text_size={:lg}
            padding={:space_md} fill_width={true} on_tap={tap} />
    """
  end
end
