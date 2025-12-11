try
	include("../preamble.jl")
catch
	global progdir = dirname(abspath(joinpath(".", @__FILE__)))
end

#input="11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
input = readlines("$(progdir)/input02.txt")

function part1()
end

function part2()
end

println(part1())
println(part2())
