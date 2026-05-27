defmodule MobPaletteDemo do
  @moduledoc """
  Tier-0 plugin demo: a pure-Elixir color helper with no manifest.

  Exists to prove the lowest-friction plugin shape — a plain Hex package
  depending on `:mob`, with no `priv/mob_plugin.exs`. mob_dev's compile
  step treats it as an ordinary dependency (nothing special), which is
  the behavior this prototype validates.
  """

  @doc """
  Returns the complementary color for a `#rrggbb` hex string.

      iex> MobPaletteDemo.suggest_complement("#3366cc")
      "#cc9933"
  """
  @spec suggest_complement(String.t()) :: String.t()
  def suggest_complement("#" <> hex) when byte_size(hex) == 6 do
    <<r::binary-2, g::binary-2, b::binary-2>> = hex

    "#" <>
      invert(r) <> invert(g) <> invert(b)
  end

  defp invert(component) do
    (255 - String.to_integer(component, 16))
    |> Integer.to_string(16)
    |> String.downcase()
    |> String.pad_leading(2, "0")
  end
end
