include("preamble.jl")

function readinput()
	readlines("input01.txt").|>l->parse(Int,l)
end

global depths = readinput()

@time function part1()
	global depths
	prev = depths[1]
	incs = 0
	for d in depths[2:end]
		if d>prev incs +=1 end
		prev = d
	end
	return incs
end

@time function part2()
	global depths
	incs = 0
	for i in 1:length(depths)-3
		if depths[i]<depths[i+3] incs +=1 end
	end
	return incs
end

@show part1()
@show part2()
