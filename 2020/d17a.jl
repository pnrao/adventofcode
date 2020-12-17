function makeinit(file)
    str=read(file, String)
    carts = Set{CartesianIndex{3}}()
    for (y,s) in enumerate(split(str,"\n"))
        for (x, c) in enumerate(s)
            if c == '#'
                push!(carts, CartesianIndex(x,y,0))
            end
        end
    end
    return carts
end

const unit=CartesianIndex(1,1,1)
function nextextrema(arr)
    e = extrema(arr)
    return (e[1]-unit, e[2]+unit)
end

const window = setdiff(collect(CartesianIndex(-1, -1, -1):
                               CartesianIndex(1, 1, 1)),
                       [CartesianIndex(0, 0, 0)])
windowof(p::CartesianIndex)=Set(map(x->x+p, window))

function next(active)
    nextactive=Set{CartesianIndex{3}}()
    ne = nextextrema(active)
    for p ∈ ne[1]:ne[2]
        actneighbrs = length(intersect(active, windowof(p)))
        if p∈active && 2 ≤ actneighbrs ≤ 3
            push!(nextactive, p)
        elseif p∉active && actneighbrs == 3
            push!(nextactive, p)
        end
    end
    return nextactive
end

actives=makeinit("input17.txt")
for i∈1:6
    global actives=next(actives)
end

println(length(actives))
