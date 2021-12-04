try include("preamble.jl") catch end
using DelimitedFiles

function parseinput(input)
	local top, boards
	open(input) do f
		top = Vector{Int8}(Meta.parse(readline(f)).args)
		boards = [readdlm(IOBuffer(bl), Int8) for bl in split(read(f, String), "\n\n")]
	end;
	return top, boards
end

function isbingo(board)
	n = size(board)[1]
	for i in 1:n
		if count(<(0),(board)[:,i])==n || count(<(0),(board)[i,:])==n
			return true
		end
	end
	return false
end

@time function part1(draws, bs)
	for d in draws
		for b in bs
			replace!(b, d=>-d)
			if isbingo(b)
				return d*sum(filter(>(0),b))
			end
		end
	end
	return 0
end

@time function part2(draws, bs)
	for d in draws
		filter!(!isbingo,bs)
		for b in bs
			if length(bs) == 1 && d in b
				return d*(sum(filter(>(0),b))-d)
			end
			replace!(b, d=>-d)
		end
	end
	return 0
end

top, boards = parseinput("input04.txt")
@show part1(top, boards)
@show part2(top, boards)
