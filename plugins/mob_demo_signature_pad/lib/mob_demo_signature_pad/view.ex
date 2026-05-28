defmodule MobDemoSignaturePad.View do
  @moduledoc """
  `Mob.Component` implementation for the SignaturePad. Owns the Elixir-side
  state (current `bg_color` and `corner_radius`); the matching native
  factory under `MobDemoSignaturePad_View` paints the rectangle.

  Native-side registration name: `"MobDemoSignaturePad_View"` (Elixir-module
  name stripped of `Elixir.` and with dots replaced by underscores, per the
  convention in `Mob.Component`'s docs).
  """
  use Mob.Component

  @impl true
  def mount(props, socket) do
    {:ok,
     socket
     |> Mob.Socket.assign(:bg_color, props[:bg_color] || "#3366cc")
     |> Mob.Socket.assign(:corner_radius, props[:corner_radius] || 12)}
  end

  @impl true
  def update(props, socket) do
    {:ok,
     socket
     |> Mob.Socket.assign(:bg_color, props[:bg_color] || socket.assigns.bg_color)
     |> Mob.Socket.assign(:corner_radius, props[:corner_radius] || socket.assigns.corner_radius)}
  end

  @impl true
  def render(assigns) do
    %{bg_color: assigns.bg_color, corner_radius: assigns.corner_radius}
  end
end
