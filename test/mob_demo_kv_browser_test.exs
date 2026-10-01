defmodule MobDemoKvBrowserTest do
  use Mob.ScreenCase

  alias MobDemoKvBrowser.{DetailScreen, ListScreen}

  # A Button's `on_tap: {pid, tag}` reaches the screen as `{:tap, tag}` in
  # handle_info/2. Drive every tap the list actually renders, so a tag the
  # screen doesn't handle (it falls through to the default handle_info and
  # nothing happens on device) fails here.
  test "every key row the list renders opens its detail screen" do
    view = mount_screen(ListScreen)

    rows =
      for %{type: :button, props: %{text: key, on_tap: {_pid, tag}}} <- flatten(view),
          do: {key, tag}

    assert Enum.map(rows, &elem(&1, 0)) == ~w(alpha beta gamma)

    for {key, tag} <- rows do
      tapped = render_info(view, {:tap, tag})
      assert navigated_to(tapped) == DetailScreen, "tapping #{key} did not open the detail screen"

      detail = mount_screen(DetailScreen, %{key: key})
      assert text(detail) =~ "value: #{ListScreen.entries()[key]}"
    end
  end

  test "the detail screen's Back button pops back to the list" do
    view = mount_screen(DetailScreen, %{key: "alpha"})
    %{props: %{on_tap: {_pid, tag}}} = find(view, :button, text: "Back")

    assert navigated_to(render_info(view, {:tap, tag})) == {:pop}
  end
end
