try include("preamble.jl") catch end

function parseinput(file)
	nums = []
	for l in eachline(file)
		if l[1] == '#' continue end
		x1,y1,x2,y2=split(l,r"[^\d]+").|>s->parse(Int,s)
		push!(nums,(x1,y1,x2,y2))
	end
	return nums
end

function bothparts(list, dodiag=false)
	d = Dict{Tuple, Int}()
	for (x1,y1,x2,y2) ∈ list
		if x1==x2
			for y in range(minmax(y1,y2)...)
				n=get!(d,(x1,y),0)
				d[(x1,y)]=n+1
			end
		elseif y1==y2
			for x in range(minmax(x1,x2)...)
				n=get!(d,(x,y1),0)
				d[(x,y1)]=n+1
			end
		elseif dodiag
			sgnx = x1<x2 ? 1 : -1
			sgny = y1<y2 ? 1 : -1
			for p in collect(zip(x1:sgnx:x2,y1:sgny:y2))
				n=get!(d,p,0)
				d[p]=n+1
			end
		else
			continue
		end
	end
	dangerous = 0
	for p in keys(d)
		if d[p]>1 dangerous+=1 end
	end
	return dangerous
end

part1(input) = bothparts(input, false)
part2(input) = bothparts(input, true)

input = parseinput("input05.txt")
@show part1(input)
@show part2(input)
