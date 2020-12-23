function rotateview(circle)
    cup = popfirst!(circle)
    push!(circle, cup)
end

function move(cups, curr)
    #@info "cups $(join(cups,',')) ($curr)"
    lencups = length(cups)
    curloc=findfirst(==(curr), cups)
    pick = zeros(Int,3)
    deletedat1 = 0
    for i ∈ 1:3
        if curloc+1<=length(cups)
            pick[i] = popat!(cups, curloc+1)
        else
            pick[i] = popat!(cups, 1)
            deletedat1+=1
        end
    end

    dest = mod1(curr-1,lencups)
    while dest ∈ pick
        dest = mod1(dest-1,lencups)
    end
    #@info "pick up $(join(pick,',')) dest $dest"
    destloc=findfirst(==(dest), cups)
    destloc=mod1(destloc+1,lencups)
    while !isempty(pick)
        insert!(cups,destloc,pop!(pick))
    end
    #newloc = findfirst(==(curr), cups)
    #newloc = mod1(newloc+1,lencups)
    if destloc <= curloc-deletedat1
        newloc = mod1(curloc-deletedat1+4,lencups)
        #@info "LT $curloc $destloc $deletedat1 $(mod1(curloc-deletedat1+4,lencups)) $newloc"
    else
        newloc = mod1(curloc-deletedat1+1,lencups)
        #@info "GE $curloc $destloc $deletedat1 $(mod1(curloc-deletedat1+1,lencups)) $newloc"
    end
    return cups[newloc]
end

function part1()
    #start="389125467"
    start="157623984"
    cups = (collect(start).|>c->parse(Int,c))
    curr = cups[1]
    #@info "cups $(join(cups,',')) ($curr)"
    for _ ∈ 1:100
        curr=move(cups, curr)
        #@info "cups $(join(cups,',')) ($curr)"
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
    curr = cups[1]
    append!(cups, collect(10:1000000))
    for _ ∈ 1:10000000
        curr=move(cups, curr)
        #@info "cups $(join(cups,',')) ($curr)"
    end
    loc=findfirst(==(1), cups)
    return cups[loc+1]*cups[loc+2]
end

#println("Part 2: ", @time part2())
