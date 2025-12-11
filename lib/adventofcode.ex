defmodule AdventOfCode do
  @moduledoc """
  Advent of Code helper library for downloading inputs and managing solutions.
  """

  @doc """
  Find and read the session cookie from cookie.txt in the repo root or parent directories.
  Raises an error if no cookie file is found.
  """
  def find_cookie(start_path \\ File.cwd!()) do
    find_cookie_recursive(start_path)
  end

  defp find_cookie_recursive(path) do
    cookie_path = Path.join(path, "cookie.txt")

    cond do
      File.exists?(cookie_path) ->
        cookie_path
        |> File.read!()
        |> String.trim()

      Path.dirname(path) == path ->
        raise "cookie.txt not found: create a file named `cookie.txt` containing your session ID in the repository root or a parent directory."

      true ->
        find_cookie_recursive(Path.dirname(path))
    end
  end

  @doc """
  Download Advent of Code input for a given year and day.
  Saves to input<day>.txt in the specified directory.
  Only downloads if the file doesn't already exist.
  """
  def download_input(year, day, output_dir \\ ".") do
    day_padded = String.pad_leading(to_string(day), 2, "0")
    output_file = Path.join(output_dir, "input#{day_padded}.txt")

    case File.exists?(output_file) do
      true ->
        {:ok, output_file}

      false ->
        session = find_cookie()
        url = "https://adventofcode.com/#{year}/day/#{day}/input"

        case Req.get(url, headers: [cookie: "session=#{session}"]) do
          {:ok, response} ->
            File.write!(output_file, response.body)
            {:ok, output_file}

          {:error, reason} ->
            {:error, reason}
        end
    end
  end

  @doc """
  Read input file, automatically downloading if needed.
  """
  def read_input(year, day, input_dir \\ ".") do
    with {:ok, _file} <- download_input(year, day, input_dir) do
      day_padded = String.pad_leading(to_string(day), 2, "0")
      input_file = Path.join(input_dir, "input#{day_padded}.txt")
      File.read!(input_file)
    end
  end

  @doc """
  Read input inferred from the calling script. The function inspects the
  current process stacktrace to find the first caller file inside the
  repository, extracts the year from the caller directory and the day from
  the filename (digits in the filename), then downloads and returns the
  input content.

  As a fallback, checks ADVENT_YEAR and ADVENT_DAY environment variables
  (set by AdventOfCode.Runner).
  """
  def read_input() do
    case caller_script_path() do
      nil ->
        # Fallback: check environment variables set by Runner
        year = System.get_env("ADVENT_YEAR")
        day = System.get_env("ADVENT_DAY")

        if year && day do
          {y, ""} = Integer.parse(year)
          {d, ""} = Integer.parse(day)
          read_input(y, d, to_string(y))
        else
          raise "could not determine caller script path; call read_input(year, day, dir) instead"
        end

      script_file ->
        script_dir = Path.dirname(script_file)
        year = Path.basename(script_dir) |> String.to_integer()
        day =
          script_file
          |> Path.basename()
          |> (&Regex.run(~r/\d+/, &1)).()
          |> case do
            nil -> raise "could not determine day from filename #{script_file}"
            [d | _] -> String.to_integer(d)
          end

        # delegate to existing function
        read_input(year, day, script_dir)
    end
  end

  # Inspect the current process stacktrace and return the first script file
  # that appears to be inside the current working directory and has an
  # `.ex` or `.exs` extension.
  defp caller_script_path do
    case System.get_env("CALLER_SCRIPT_PATH") do
      path when is_binary(path) and path != "" ->
        path

      _ ->
        {:current_stacktrace, stack} = Process.info(self(), :current_stacktrace)
        cwd = File.cwd!() |> Path.expand()

        # Prefer frames where the parent directory looks like a 4-digit year.
        year_candidate =
          Enum.find_value(stack, fn
            {_m, _f, _a, loc} ->
              file =
                case loc do
                  [file: f, line: _] when is_binary(f) -> f
                  [file: f, line: _] when is_list(f) -> List.to_string(f)
                  %{file: f} when is_binary(f) -> f
                  {f, _} when is_binary(f) -> f
                  _ -> nil
                end

              if is_binary(file) do
                file_exp = Path.expand(file)

                if String.starts_with?(file_exp, cwd) and Path.extname(file_exp) in [".ex", ".exs"] do
                  parent = Path.basename(Path.dirname(file_exp))
                  if Regex.match?(~r/^\d{4}$/, parent), do: file_exp, else: nil
                else
                  nil
                end
              else
                nil
              end

            _ ->
              nil
          end)

        case year_candidate do
          nil ->
            # Fallback: first .ex/.exs file under cwd with a 4-digit year parent,
            # or under a year subdirectory at all
            Enum.find_value(stack, fn
              {_m, _f, _a, loc} ->
                file =
                  case loc do
                    [file: f, line: _] when is_binary(f) -> f
                    [file: f, line: _] when is_list(f) -> List.to_string(f)
                    %{file: f} when is_binary(f) -> f
                    {f, _} when is_binary(f) -> f
                    _ -> nil
                  end

                if is_binary(file) do
                  file_exp = Path.expand(file)

                  if String.starts_with?(file_exp, cwd) and Path.extname(file_exp) in [".ex", ".exs"] do
                    # Check if the parent directory looks like a year (4 digits)
                    parent = Path.basename(Path.dirname(file_exp))
                    if Regex.match?(~r/^\d{4}$/, parent), do: file_exp, else: nil
                  else
                    nil
                  end
                else
                  nil
                end

              _ ->
                nil
            end)

          file ->
            file
        end
    end
  end
end
