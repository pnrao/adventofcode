defmodule Mix.Tasks.Advent.RunScript do
  use Mix.Task

  @shortdoc "Run a single Elixir script file without compiling all year directories"

  @moduledoc """
  Loads project `lib` files and then `require_file/1` on the provided script path.
  This avoids compiling all `elixirc_paths` (e.g. all `2025/*` files) and is
  useful for debugging a single day's file in isolation.

  Usage:
    mix advent.run_script path/to/d02.ex
  """

  @impl Mix.Task
  def run([file | _]) do
    Mix.Task.run("app.start")

    # The debug adapter (ElixirLS) already loads our project modules; requiring
    # `lib/**/*.ex` here causes module redefinition warnings. Don't preload
    # lib files — just set the caller path and require the target script.
    System.put_env("CALLER_SCRIPT_PATH", Path.expand(file))

    preloaded = case System.get_env("ADVENT_PRELOADED") do
      v when v in ["1", "true"] -> true
      _ -> false
    end

    unless preloaded do
      Code.require_file(file)
    end

    # If the module defines a `run/0` or `run/1` entrypoint, invoke it.
    # Infer module name from path: .../YYYY/dDD.ex -> AdventOfCode.YYYYY.DayDD
    try do
      file_exp = Path.expand(file)
      dir = Path.dirname(file_exp)
      year = Path.basename(dir)
      day_base = Path.basename(file_exp)
      day = case Regex.run(~r/\d+/, day_base) do
        [d | _] -> String.to_integer(d)
        _ -> nil
      end

      if year =~ ~r/^\d{4}$/ and is_integer(day) do
        day_s = String.pad_leading(to_string(day), 2, "0")
        mod = Module.concat([AdventOfCode, String.to_atom("Y#{year}"), String.to_atom("Day#{day_s}")])

        cond do
          function_exported?(mod, :run, 0) ->
            apply(mod, :run, [])

          function_exported?(mod, :run, 1) ->
            input = AdventOfCode.read_input(String.to_integer(year), day, dir)
            apply(mod, :run, [input])

          true ->
            :ok
        end
      else
        :ok
      end
    rescue
      _ -> :ok
    end

    :ok
  end

  def run(_) do
    Mix.raise("usage: mix advent.run_script PATH_TO_EX")
  end
end
