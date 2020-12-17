const DIMS=4 # run-time initialization of unit and window slows down code
function makeinit(file)
    str=read(file, String)
    carts = Set{CartesianIndex{DIMS}}()
    for (y,s) in enumerate(split(str,"\n"))
        for (x, c) in enumerate(s)
            if c == '#'
                cart = zeros(Int, DIMS)
                cart[1] = x
                cart[2] = y
                push!(carts, CartesianIndex(Tuple(cart)))
            end
        end
    end
    return carts
end

const unit=CartesianIndex{DIMS}()
const window = setdiff(collect(-unit:unit),[0*unit])
windowof(p::CartesianIndex)=Set(map(x->x+p, window))

@views function nextlocations(arr)
    nxtloc = copy(arr)
    for p in arr
        union!(nxtloc, windowof(p))
    end
    return nxtloc
end

@views function next(active)
    nextactive=Set{CartesianIndex{DIMS}}()
    nl = nextlocations(active)
    for p ∈ nl
        actneighbrs = length(intersect(active, windowof(p)))
        if (p∈active && 2 ≤ actneighbrs ≤ 3) || (p∉active && actneighbrs == 3)
            push!(nextactive, p)
        end
    end
    return nextactive
end

function main(file, times)
    actives=makeinit(file)
    for i∈1:times
        actives=next(actives)
    end
    return length(actives)
end
println(@time main("input17.txt", 6))
