try include("preamble.jl") catch end

sample =[3,4,3,1,2]

function spawnfish(fish, days)
	fishdic = Dict((i=>0 for i ∈ 0:8))
	for f ∈ fish
		fishdic[f]+=1
	end
	for d ∈ 1:days
		newdic = Dict((i=>0 for i ∈ 0:8))
		for k ∈ keys(fishdic)
			if k==0
				newdic[6]+=fishdic[0]
				newdic[8] =fishdic[0]
			else
				newdic[k-1]+=fishdic[k]
			end
		end
		fishdic = newdic
	end
	return sum(values(fishdic))
end

input = parse.(Int,split(readline("input06.txt"),','))
@time sample18 = spawnfish(sample,18)
@show sample18
@time sample80 = spawnfish(sample,80)
@show sample80
@time part1=spawnfish(input, 80)
@show part1
@time part2=spawnfish(input, 256)
@show part2
