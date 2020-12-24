function rotateview(circle)
    cup = popfirst!(circle)
    push!(circle, cup)
end

function move(cups, curloc)
    lencups = length(cups)
    curr = cups[curloc]
    pick = zeros(Int,3)
    deletedat1 = 0
    for i ∈ 1:3
        if curloc+1<=length(cups)
            pick[i] = popat!(cups, curloc+1)
        else
            pick[i] = popat!(cups, 1)
            deletedat1 += 1
        end
    end

    dest = mod1(curr-1,lencups)
    while dest ∈ pick
        dest = mod1(dest-1,lencups)
    end
    destloc=findfirst(==(dest), cups)
    destloc=mod1(destloc+1,lencups)
    for i ∈ 3:-1:1
        insert!(cups,destloc,pick[i])
    end
    if destloc <= curloc-deletedat1
        newloc = mod1(curloc-deletedat1+4,lencups)
    else
        newloc = mod1(curloc-deletedat1+1,lencups)
    end
    return newloc
end

function part1()
    #start="389125467"
    start="157623984"
    cups = (collect(start).|>c->parse(Int,c))
    curloc = 1
    for _ ∈ 1:100
        curloc=move(cups, curloc)
    end
    while cups[1] != 1
        rotateview(cups)
    end
    return cups
end

@time cs=part1()
println("Part 1: ", join(cs[2:end]))

function part2()
    start="157623984"
    cups = (collect(start).|>c->parse(Int,c))
    curloc = 1
    append!(cups, collect(10:1_000_000))
    st = time_ns()
    for i ∈ 1:1_000_000
        if i ∈ [10,100,1_000,10_000,100_000,
            1_000_000,2_000_000,3_000_000,4_000_000,
            5_000_000,6_000_000,7_000_000,8_000_000,
            9_000_000,10_000_000]
            lt = (time_ns()-st)*1e-9
            @info "move $i $lt"
        end
        curloc=move(cups, curloc)
    end
    loc=findfirst(==(1), cups)
    return cups[loc+1]*cups[loc+2]
end

#println("Part 2: ", @time part2())
