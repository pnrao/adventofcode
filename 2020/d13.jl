lines = readlines("input13.txt")
function part1()
    arrival = parse(Int,lines[1])
    buses = Vector{Int}()
    for s in split(replace(lines[2], ",x"=>""),",")
        n=tryparse(Int,s)
        push!(buses,n)
    end
    busat=buses.|>x->ceil(arrival/x)*x.|>Int
    mini=argmin(busat)
    t=(busat[mini]-arrival)*buses[mini]
    @info "Part 1: $t"
    return t
end

trials = [lines[2]]
push!(trials, "17,x,13,19")
push!(trials, "67,7,59,61")
push!(trials, "67,x,7,59,61")
push!(trials, "67,7,x,59,61")
push!(trials, "1789,37,47,1889")

function part2(series)
    # naïve stepping by the largest bus number
    off=0
    busoffs=Dict{Int,Int}()
    for s in split(trials[series],",") # select trial number by index
        n=tryparse(Int,s)
        !isnothing(n) && push!(busoffs, n=>off)
        off+=1
    end
    @info busoffs
    busmax = max(keys(busoffs)...)
    busmaxoff = busoffs[busmax]
    t=0
    slot=-1
    trynextt = true
    while trynextt
        slot+=1
        t=slot*busmax-busmaxoff
        # floor(log(slot+1))>floor(log(slot)) && @info "trying slot=$slot t=$t"
        trynextt = false
        for (bus, off) in pairs(busoffs)
            if (t+off)%bus!=0
                trynextt = true
                break
            end
        end
    end
    # @info "worked at slot=$slot t=$t"
    @info "Part 2, series $series: $t"
    return t
end

function chinese_remainder(dic)
    # assumes Dict(modulo=>remainder)
    N = prod(keys(dic))
    mod(sum(dic[n_i] * invmod(N ÷ n_i, n_i) * N÷n_i for n_i in keys(dic)), N)
end

function part2_c_r(series)
    off=0
    busoffs=Dict()
    for s in split(trials[series],",") # select trial number by index
        n=tryparse(Int,s)
        !isnothing(n) && push!(busoffs, n=>off)
        off+=1
    end
    println("busoffs = ", busoffs)
    println("Part 2 with Chinese Remainder, series $series: ", chinese_remainder(busoffs))
end

function chineseremainder(n::Array, a::Array)
    # From Rosetta Code
    Π = prod(n)
    mod(sum(ai * invmod(Π ÷ ni, ni) * Π ÷ ni for (ni, ai) in zip(n, a)), Π)
end

function part2_cr(series)
    off=0
    buss=Vector{Int}()
    offs=Vector{Int}()
    for s in split(trials[series],",") # select trial number by index
        n=tryparse(Int,s)
        if !isnothing(n)
            push!(buss, n)
            push!(offs, off)
        end
        off+=1
    end
    println("(buss, offs) = ", (buss, offs))
    println("Part 2 with Chinese Remainder, series $series: ", chineseremainder(buss, offs))
end


part1()
part2(2)
part2(3)
part2(4)
part2(5)
part2(6)
part2_cr(2)
part2_cr(3)
part2_cr(4)
part2_cr(5)
part2_cr(6)
