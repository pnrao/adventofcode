import HTTP

if abspath(PROGRAM_FILE) == @__FILE__
    print("""
   This script downloads your input text from adventofcode.com.
   The day # is extracted from the name of the program file.
   The year # is extracted from the name of the program file's base dir.
   Your input will be saved as input<day>.txt.
   Uses AdventOfCode.jl convention of storing cookie in ~/.julia/config/startup.jl:
   ENV["AOC_SESSION"]="0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"

   If you choose to modify this program to include your session cookie, be careful to not push it to a public repository.
   """)
else
    global progdir = dirname(abspath(joinpath(".", PROGRAM_FILE)))
    local year = splitpath(progdir)[end]
    local sday = match(r"\d+", basename(PROGRAM_FILE)).match
    local iday = parse(Int, sday)
    local fname = joinpath(progdir, "input$(sday).txt")
    isfile(fname) || open(fname, "w") do f
        write(f, HTTP.get("https://adventofcode.com/$year/day/$iday/input"; cookies=Dict("session" => ENV["AOC_SESSION"])).body |> String)
    end
end
