defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :adventofcode,
      version: "0.1.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(_env) do
    ["lib", "2020", "2021", "2022", "2025"]
  end

  defp deps do
    [
      {:req, github: "wojtekmach/req"}
    ]
  end
end