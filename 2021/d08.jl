try include("preamble.jl") catch end
using OffsetArrays

#input = readlines("sample08.txt")
input = readlines("input08.txt")

function learn(str)
    allsym = Set()
    lut = OffsetVector(Array{Set}(undef, 10), OffsetArrays.Origin(0))
    words = split(str) .|> Set
	for w ∈ words
		if length(w) == 2
			lut[1] = w
		elseif length(w) == 4
			lut[4] = w
		elseif length(w) == 3
			lut[7] = w
		elseif length(w) == 7
			lut[8] = w
		end
    end
	filter!(w->length(w)∉[2,3,4,7], words)

	lut[9] = filter(w->length(lut[4]∩w)==4, words)[1]
	filter!(!=(lut[9]), words)

	lut[2] = filter(w->length(setdiff(lut[9],w))==2, words)[1]
	filter!(!=(lut[2]), words)

	lut[5] = filter(w->length(lut[2]∩w)==3, words)[1]
	filter!(!=(lut[5]), words)

	lut[3] = filter(w->length(w)==5, words)[1]
	filter!(!=(lut[3]), words)

	lut[0] = filter(w->length(lut[1]∩w)==2, words)[1]
	filter!(!=(lut[0]), words)

	lut[6] = words[1]

	Dict([lut[i]=>i for i ∈ 0:9])
end

function part1()
    n = 0
    for l ∈ input
        n += length(filter(w -> length(w) ∈ [2, 3, 4, 7], split(split(l, " | ")[2])))
    end
    return n
end

function part2()
	n = 0
	for l in input
		usp,fdov = split(l, " | ")
		lut = learn(usp)
		digs= [lut[v] for v in split(fdov).|>Set]
		n+=digs[1]*1000+digs[2]*100+digs[3]*10+digs[4]
	end
	return n
end

@show part1()
@show part2()
