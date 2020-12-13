lines = readlines("input13.txt")
let arrival = parse(Int,lines[1])
    buses = Vector{Int}()
    for s in split(replace(lines[2], ",x"=>""),",")
        n=tryparse(Int,s)
        push!(buses,n)
    end
    busat=buses.|>x->ceil(arrival/x)*x.|>Int
    mini=argmin(busat)
    println("Part 1: ", (busat[mini]-arrival)*buses[mini])
end

let off=0
    global busoffs=Dict()
    trials = [lines[2]]
    push!(trials, "17,x,13,19")
    push!(trials, "67,7,59,61")
    push!(trials, "67,x,7,59,61")
    push!(trials, "67,7,x,59,61")
    push!(trials, "1789,37,47,1889")
    for s in split(trials[1],",") # select trial number by index
        n=tryparse(Int,s)
        !isnothing(n) && push!(busoffs, n=>off)
        off+=1
    end
    println("busoffs = ", busoffs)
    busmax = max(keys(busoffs)...)
    busmaxoff = busoffs[busmax]
    t=0
    slot=-1
    trynextt = true
    while trynextt
        slot+=1
        t=slot*busmax-busmaxoff
        if floor(log(slot+1))>floor(log(slot))
            @info "trying slot=$slot t=$t"
        end
        trynextt = false
        for (bus, off) in pairs(busoffs)
            if (t+off)%bus!=0
                trynextt = true
                break
            end
        end
    end
    @info "worked at slot=$slot t=$t"
    println("Part 2: ", t)
end
