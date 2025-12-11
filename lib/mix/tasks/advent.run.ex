defmodule Mix.Tasks.Advent.Run do
  use Mix.Task

  @shortdoc "Run Advent of Code solution for YEAR DAY (e.g. mix advent.run 2025 1)"

  @moduledoc """
  A convenience Mix task to run a single day's solution.

  Examples
    mix advent.run 2025 1
  """

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    case args do
      [year_s, day_s] ->
        {year, ""} = Integer.parse(year_s)
        {day, ""} = Integer.parse(day_s)
        AdventOfCode.Runner.run(year, day)

      _ ->
        Mix.shell().info("Usage: mix advent.run YEAR DAY")
    end
  end
end
