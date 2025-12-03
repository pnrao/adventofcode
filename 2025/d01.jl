try
	include("../preamble.jl")
catch
	global progdir = dirname(abspath(joinpath(".", @__FILE__)))
end

#input=["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"]
input = readlines("$(progdir)/input01.txt")

function part1()
	dial=50
	z=0
	for l in input
		rotate = parse(Int, l[2:end])
		if l[1] == 'L'
			dial -= rotate
		elseif l[1] == 'R'
			dial += rotate
		end
		dial %= 100
		if dial < 0
			dial += 100
		elseif dial == 0
			z+=1
		end
	end
	return z
end

function part2()
	dial=50
	zhits=0
	for l in input
		rotate = parse(Int, l[2:end])
		zhits += rotate ÷ 100
		rotate %= 100
		if l[1] == 'L'
			if dial == 0
				zhits -= 1 # because will count this zero crossing when rounding up
			end
			dial -= rotate
		elseif l[1] == 'R'
			dial += rotate
		end
		if dial < 0
			dial += 100
			zhits+=1
		elseif dial == 0
			zhits+=1
		elseif dial>=100
			dial -= 100
			zhits+=1
		end
	end
	return zhits
end

println(part1())
println(part2())
