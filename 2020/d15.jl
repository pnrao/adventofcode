function nthofseq1(seq, n)
    s = copy(seq)
    for t in 1:(n-length(s))
        @views i = findlast(==(s[end]), s[1:end-1])
        if isnothing(i)
            push!(s, 0)
        else
            push!(s, length(s)-i)
        end
    end
    return s[end]
end

function nthofseq2(seq, n)
    lseq=length(seq)
    d = Dict{Int, Int}(seq[i]=>i for i∈1:lseq-1)
    # dict of number => turn_last_seen
    lastn = seq[end]
    for turn ∈ lseq+1:n
        prevt = get(d, lastn, 0)
        d[lastn] = turn-1
        lastn = prevt == 0 ? 0 : lastn = turn-1-prevt
    end
    return lastn
end

# println("Part 1: ", nthofseq1([0,3,6], 2020))
# println("Part 1: ", nthofseq1([1,3,2], 2020))
# println("Part 1: ", nthofseq1([2,1,3], 2020))
# println("Part 1: ", nthofseq1([1,2,3], 2020))
# println("Part 1: ", nthofseq1([2,3,1], 2020))
# println("Part 1: ", nthofseq1([3,2,1], 2020))
# println("Part 1: ", nthofseq1([3,1,2], 2020))
println("Part 1: ", @time nthofseq1([1,12,0,20,8,16], 2020))
println("Part 1: ", @time nthofseq2([1,12,0,20,8,16], 2020))
println("Part 2: ", @time nthofseq2([1,12,0,20,8,16], 30000000))
