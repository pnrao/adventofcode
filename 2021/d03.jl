include("preamble.jl")

@time function bothparts()
	allbits = readlines("input03.txt").|>collect.|>a->BitVector(map(l->l-'0',a))
	σ = sum(allbits)
	t = length(allbits)
	γ = Int(reverse(BitVector(map((>=(t/2)),σ))).chunks[1])
	ϵ = Int(reverse(BitVector(map((<=(t/2)),σ))).chunks[1])
	part1 = γ*ϵ

	o2bits = deepcopy(allbits)
	for i ∈ 1:length(allbits[1])
		si = sum(o2bits)[i] # Summing everything because I can't figure out how to sum a particular column
		mstcmni = si>=length(o2bits)/2 ? 1 : 0
		filter!(r->r[i]==mstcmni, o2bits)
		length(o2bits)==1 && break
	end
	o2rating=Int(reverse(o2bits[1]).chunks[1])

	co2bits = deepcopy(allbits)
	for i ∈ 1:length(allbits[1])
		si = sum(co2bits)[i] # Summing everything because I can't figure out how to sum a particular column
		lstcmni = si>=length(co2bits)/2 ? 0 : 1
		filter!(r->r[i]==lstcmni, co2bits)
		length(co2bits)==1 && break
	end
	co2rating=Int(reverse(co2bits[1]).chunks[1])

	part2 = o2rating*co2rating
	return part1, part2
end

part1, part2 = bothparts()
@show part1
@show part2
