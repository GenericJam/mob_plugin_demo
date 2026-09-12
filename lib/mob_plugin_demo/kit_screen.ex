defmodule MobPluginDemo.KitScreen do
  @moduledoc """
  Exercises the third expansion pass: `<DemoCard>`/`<DemoCombobox>` composite
  TAGS (mob_demo_kit plugin, pure Elixir) with auto-injected event targets —
  note: no `self()` anywhere in this screen's markup.
  """
  use Mob.Screen

  @fruit ~w(apple apricot banana cherry grape mango orange peach pear plum)

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> Mob.Socket.assign(:query, "")
     |> Mob.Socket.assign(:options, @fruit)
     |> Mob.Socket.assign(:selected, nil)}
  end

  @impl true
  def render(assigns) do
    ~MOB"""
    <Scroll background={:background}>
      <Column background={:background} padding={:space_lg}>
        <Text text="Composite kit (pure Elixir)" text_size={:xl} text_color={:on_surface} padding={:space_sm} />
        <DemoCard title="Pick a fruit">
          <DemoCombobox query={assigns.query} options={assigns.options}
                        placeholder="Search fruit…"
                        on_change="combo_query" on_select="combo_select" />
        </DemoCard>
        <Spacer size={12} />
        <DemoCard title="Selection">
          <Text text={assigns.selected || "nothing yet"} text_size={:lg} text_color={:primary} />
        </DemoCard>
      </Column>
    </Scroll>
    """
  end

  @impl true
  def handle_info({:change, :combo_query, q}, socket) do
    options = Enum.filter(@fruit, &String.contains?(&1, String.downcase(q)))

    {:noreply,
     socket
     |> Mob.Socket.assign(:query, q)
     |> Mob.Socket.assign(:options, options)}
  end

  @impl true
  def handle_info({:tap, {:combo_select, opt}}, socket) do
    {:noreply, Mob.Socket.assign(socket, :selected, opt)}
  end
end
