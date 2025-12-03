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

From the repository root, run an Elixir day script. The input is downloaded automatically and the solution runs.

```zsh
elixir -S mix run 2025/d01.ex
```

**From inside a year directory:**

```zsh
cd 2025
elixir -S mix run d01.ex
```

## How Input Download Works

### Julia (`preamble.jl`)
- When a Julia day script includes `preamble.jl`, it searches for `cookie.txt` in the repository root (or parent directories).
- Reads the session ID, then downloads the input for that day from `adventofcode.com`.
- Saves to `inputDD.txt` in the day's directory (e.g., `2025/input01.txt`).
- If the input file already exists, it is **not** re-downloaded.

### Elixir (`lib/adventofcode.ex`)
- Call `AdventOfCode.read_input()` from a day script (e.g., `2025/d01.ex`).
- The library inspects the caller's stack frame to determine the year (from the parent directory name, e.g., `2025`) and day (from digits in the filename, e.g., `d01` → day 1).
- Searches for `cookie.txt` in the repository root (or parent directories).
- Downloads the input if not already present and returns the file contents.

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
input = AdventOfCode.read_input()

defmodule DayDD do
  def part1(input) do
    # your solution here
  end

  def part2(input) do
    # your solution here
  end
end

IO.puts(DayDD.part1(input))
IO.puts(DayDD.part2(input))
```

Then run: `elixir -S mix run YYYY/dDD.ex`

## Notes

- **No Version Pinning**: Dependencies are kept to their latest compatible versions. Update with `mix deps.get` (Elixir) or `Pkg.instantiate()` (Julia) as new releases come out.
- **Benchmarking** (Elixir/Julia): Both projects support `BenchmarkTools.jl` (Julia) and `Benchmarks` via Elixir libraries. See respective docs for timing solutions.
- **Floating Dependencies**: Input files (`input*.txt`) and build artifacts are ignored in `.gitignore`, so only your solution code is committed.
