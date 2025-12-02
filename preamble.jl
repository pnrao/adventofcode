import HTTP

if abspath(PROGRAM_FILE) == @__FILE__
    print("""
   This script downloads your input text from adventofcode.com.
   The day # is extracted from the name of the program file.
   The year # is extracted from the name of the program file's base dir.
   Your input will be saved as input<day>.txt.
   This script reads your Advent of Code session ID from a file named `cookie.txt`
   located in the repository root (or parent directory). Keep `cookie.txt`
   private and do not commit it to a public repo.

   If you use a repository-level Julia project (a `Project.toml` + `Manifest.toml`
   at the repo root), run day scripts with the `--project` flag pointing at the
   repository root so dependencies are found. Example (from the repo root):
   `julia --project=. 2025/d01.jl` or when inside a year's directory:
   `julia --project=.. d01.jl`.

   Be careful to not push the session cookie file to a public repository.
   """)
else
    global progdir = dirname(abspath(joinpath(".", PROGRAM_FILE)))
    local year = splitpath(progdir)[end]
    local sday = match(r"\d+", basename(PROGRAM_FILE)).match
    local iday = parse(Int, sday)
    local fname = joinpath(progdir, "input$(sday).txt")
    local function _find_cookie(startdir)
        p = startdir
        while true
            f = joinpath(p, "cookie.txt")
            if isfile(f)
                return strip(read(f, String))
            end
            parent = dirname(p)
            if parent == p
                break
            end
            p = parent
        end
        return nothing
    end

    session = begin
        s = _find_cookie(progdir)
        s === nothing && error("cookie.txt not found: create a file named `cookie.txt` containing your session ID in the repository root or a parent directory.")
        s
    end

    isfile(fname) || open(fname, "w") do f
        write(f, HTTP.get("https://adventofcode.com/$year/day/$iday/input"; cookies=Dict("session" => session)).body |> String)
    end
end
