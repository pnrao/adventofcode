try include("preamble.jl") catch end

fish =[3,4,3,1,2]

function spawnfish(fish, days)
	for d ∈ 1:days
		for i ∈ 1:length(fish)
			if fish[i] == 0
				fish[i] = 6
				push!(fish, 8)
			else
				fish[i]-=1
			end
		end
	end
	return length(fish)
end

input = parse.(Int,split(readline("input06.txt"),','))
@time sample18 = spawnfish([3,4,3,1,2],18)
@show sample18
@time sample80 = spawnfish([3,4,3,1,2],80)
@show sample80
@time part1=spawnfish(copy(input), 80)
@show part1
@time part2=spawnfish(input, 256)
@show part2
