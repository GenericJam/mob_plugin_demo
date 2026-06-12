defmodule MobDemoKit.Combobox do
  @moduledoc """
  `<DemoCombobox query={...} options={...} on_change="combo_query"
  on_select="combo_select" />` — a TextField + tappable option rows, assembled
  entirely from built-in widgets (the no-Swift/Kotlin combobox).

  Event ergonomics: `on_change`/`on_select` are written as bare strings — the
  expansion pass delivers them as `{screen_pid, tag}`, so the kit user never
  threads `self()`. Selection identity rides the tap tag as `{tag, option}`;
  the screen handles `{:tap, {:combo_select, opt}}`.
  """
  import Mob.Sigil

  @doc "Composite expander (registered via the manifest expand: form)."
  @spec expand(map(), [map()], map()) :: map()
  def expand(props, _children, _ctx) do
    query = Map.get(props, :query, "")
    placeholder = Map.get(props, :placeholder, "Search…")
    on_change = Map.fetch!(props, :on_change)
    {pid, select_tag} = Map.fetch!(props, :on_select)

    rows =
      for opt <- Map.get(props, :options, []) do
        tap = {pid, {select_tag, opt}}

        ~MOB"""
        <Column>
          <Button text={opt} background={:surface} text_color={:on_surface}
                  padding={:space_sm} fill_width={true} on_tap={tap} />
          <Spacer size={4} />
        </Column>
        """
      end

    ~MOB"""
    <Column>
      <TextField value={query} placeholder={placeholder} on_change={on_change} />
      <Spacer size={8} />
      {rows}
    </Column>
    """
  end
end
