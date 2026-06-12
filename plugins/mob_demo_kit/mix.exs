defmodule MobDemoKit.MixProject do
  use Mix.Project

  def project do
    [app: :mob_demo_kit, version: "0.1.0", elixir: "~> 1.17", deps: deps()]
  end

  def application, do: [extra_applications: []]

  defp deps do
    [{:mob, path: "/Users/kevin/code/mob"}]
  end
end
