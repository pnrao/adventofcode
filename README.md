# Advent of Code Solutions

A multi-language repository for Advent of Code solutions in **Julia** and **Elixir**, with automatic input downloading via session cookies.

## Setup

### Prerequisites
- **Julia**: Install via [julialang.org](https://julialang.org) or use `asdf` (optional).
- **Elixir**: Install via [elixir-lang.org](https://elixir-lang.org) or use `asdf` (optional).
- **Session Cookie**: Create a file named `cookie.txt` in the repository root containing your Advent of Code session ID (retrieve from the `session` cookie in your browser).

### Initial Setup

```zsh
# Julia: fetch and instantiate project dependencies
julia --project=. -e 'import Pkg; Pkg.instantiate()'

# Elixir: fetch dependencies
mix deps.get
```

## Running Solutions

### Julia Solutions

From the repository root, run a Julia day script. The input is downloaded automatically on first run and saved to `inputDD.txt`.

```zsh
julia --project=. 2025/d01.jl
```

**From inside a year directory:**

```zsh
cd 2025
julia --project=.. d01.jl
```

### Elixir Solutions

**Run from CLI (specific day):**

```zsh
mix advent.run 2025 1
```

**Debug in VSCode (current file):**

1. Install the **ElixirLS** extension.
2. Open any day file (e.g., `2025/d02.ex`).
3. Set breakpoints.
4. Press **F5** to launch the debugger.

The debugger will execute the active file's `run/0` or `run/1` entrypoint with full step-through and variable inspection.

**Interactive REPL:**

```zsh
iex -S mix
iex> AdventOfCode.Runner.run(2025, 1)
```

## How Input Download Works

### Julia (`preamble.jl`)
- When a Julia day script includes `preamble.jl`, it searches for `cookie.txt` in the repository root (or parent directories).
- Reads the session ID, then downloads the input for that day from `adventofcode.com`.
- Saves to `inputDD.txt` in the day's directory (e.g., `2025/input01.txt`).
- If the input file already exists, it is **not** re-downloaded.

### Elixir (`lib/adventofcode.ex`)
- Call `AdventOfCode.read_input()` from a day module to download and read the input.
- The library auto-detects the year/day from:
  1. The stacktrace (parent directory name for year, filename digits for day),
  2. Environment variable fallback (`ADVENT_YEAR`, `ADVENT_DAY`) when called via debugger or Mix tasks.
- Searches for `cookie.txt` in the repository root (or parent directories).
- Downloads the input if not already present and caches it locally.

## Session Cookie

To find your session cookie:
1. Visit https://adventofcode.com/
2. Open your browser's developer tools (F12 or Cmd+Option+I).
3. Go to the **Application** or **Storage** tab.
4. Find **Cookies** → **adventofcode.com** → copy the `session` cookie value.
5. Create `cookie.txt` in the repository root and paste the value (no extra whitespace).

**Important:** Keep `cookie.txt` private and **do not commit it** to version control. The `.gitignore` already excludes it.

## Project Structure

```
REPO-ROOT
├── cookie.txt              # Your session ID (ignored by git)
├── .gitignore              # Excludes build artifacts, input files, cookies
├── mix.exs                 # Elixir project definition
├── lib/
│   └── adventofcode.ex     # Elixir library for input download & helpers
├── preamble.jl             # Julia preamble for input download
├── Project.toml            # Julia project (dependencies)
├── 2025/
│   ├── d01.jl              # Julia Day 1 solution
│   ├── d01.ex              # Elixir Day 1 solution
│   ├── d02.jl              # Julia Day 2 solution
│   ├── d02.ex              # Elixir Day 2 solution
│   ├── input01.txt         # Downloaded input (auto-generated, ignored by git)
│   └── input02.txt         # Downloaded input (auto-generated, ignored by git)
└── 2024/
    ├── ...                 # Solutions from previous years
```

## Adding New Solutions

### Julia
Create a new file `YYYY/dDD.jl`:

```julia
try
  include("../preamble.jl")
catch
  global progdir = dirname(abspath(joinpath(".", @__FILE__)))
end

input = readlines("$(progdir)/inputDD.txt")

# your solution here
```

Then run: `julia --project=. YYYY/dDD.jl`

### Elixir
Create a new file `YYYY/dDD.ex`:

```elixir
defmodule AdventOfCode.YYYYY.DayDD do
  def part1(input) do
    # your solution here
  end

  def part2(input) do
    # your solution here
  end

  def run do
    input = AdventOfCode.read_input() |> String.trim()
    IO.puts(part1(input))
    IO.puts(part2(input))
  end
end
```

Then run with:

```bash
mix advent.run YYYY DD
```

Or debug in VSCode by opening the file and pressing **F5**.

## Elixir Tools

- **`mix advent.run YEAR DAY`**: Run a specific day's solution.
- **`mix advent.run_script PATH`**: Run a single script file in isolation (used by VSCode debugger).
- **`AdventOfCode.Runner.run(year, day)`**: Programmatically run a day from `iex`.
- **`AdventOfCode.read_input(year, day, dir)` or `AdventOfCode.read_input()`**: Download and return the input for a day.

## Notes

- **No Version Pinning**: Dependencies are kept to their latest compatible versions. Update with `mix deps.get` (Elixir) or `Pkg.instantiate()` (Julia).
- **Input Files**: Downloaded inputs are cached in `YYYY/inputDD.txt` and ignored by `.gitignore`.
- **Debugger**: Install ElixirLS to use VSCode's integrated debugging with breakpoints and variable inspection.
