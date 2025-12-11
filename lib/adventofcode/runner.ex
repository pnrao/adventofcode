defmodule AdventOfCode.Runner do
  @moduledoc """
  Helpers to run a specific year's day module.

  Usage:
    AdventOfCode.Runner.run(2025, 1)

  The runner will try `run/0` on the day module, and if absent will try
  `run/1` passing the downloaded input string.
  """

  def run(year, day) when is_integer(year) and is_integer(day) do
    day_s = String.pad_leading(to_string(day), 2, "0")
    year_atom = String.to_atom("Y#{year}")
    day_atom = String.to_atom("Day#{day_s}")
    mod = Module.concat([AdventOfCode, year_atom, day_atom])

    # ensure project compiled so the module is available
    case Code.ensure_loaded(mod) do
      {:module, _} -> :ok
      _ -> Mix.Task.run("compile")
    end

    # Set environment variables so read_input/0 can find year/day even under debugger
    System.put_env("ADVENT_YEAR", to_string(year))
    System.put_env("ADVENT_DAY", to_string(day))

    cond do
      function_exported?(mod, :run, 0) ->
        apply(mod, :run, [])

      function_exported?(mod, :run, 1) ->
        input = AdventOfCode.read_input(year, day, to_string(year))
        apply(mod, :run, [input])

      true ->
        Mix.raise("no runnable function found for #{inspect(mod)}; expected run/0 or run/1")
    end
  end
end
