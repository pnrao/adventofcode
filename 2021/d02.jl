include("preamble.jl")

@time function part1()
	h,d = 0,0
	for l in eachline("input02.txt")
		m = match(r"^(.).*(\d+)$", l)
		n = parse(Int, m[2])
		if m[1] == "f" h+=n
		elseif m[1] == "d" d+=n
		else d-=n end
	end
	return h*d
end

@time function part2()
	h,d,a = 0,0,0
	for l in eachline("input02.txt")
		m = match(r"^(.).*(\d+)$", l)
		n = parse(Int, m[2])
		if m[1] == "f" h+=n; d+=a*n
		elseif m[1] == "d" a+=n
		else a-=n end
	end
	return h*d
end

@show part1()
@show part2()
