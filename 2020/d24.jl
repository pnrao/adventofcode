using PrettyPrint
function parsesteps(s)
    steps = []
    i=1
    while i <= length(s)
        if i+1<=length(s) && s[i:i+1] ∈ ["ne","nw", "sw", "se"]
            push!(steps, s[i:i+1])
            i += 2
        else
            push!(steps, s[i:i])
            i += 1
        end
    end
    @assert join(steps) == s
    return steps
end

function steptocoord(step)
    if step == "e"
        return  1.0000001+.0im
    elseif step == "w"
        return -0.9999999+.0im
    elseif step == "ne"
        return (cosd( 60)+im*sind( 60)+.0000001im)
    elseif step == "nw"
        return (cosd(120)+im*sind(120)+.0000001im)
    elseif step == "sw"
        return (cosd(240)+im*sind(240)+.0000001im)
    elseif step == "se"
        return (cosd(300)+im*sind(300)+.0000001im)
    else
        @error "invalid step"
    end
end

function goto(steps)
    pacc = 0.0
    for step in steps
        pacc += steptocoord(step)
    end
    #return Complex{Float16}(pacc) # round it down for comparisons
    return round(pacc, digits=7, base=2)
end

function newgoto(steps)
    pe = count(==( "e"), steps)-count(==( "w"), steps)
    pne= count(==("ne"), steps)-count(==("sw"), steps)
    pnw= count(==("nw"), steps)-count(==("se"), steps)
    p  = pe + pne*(cosd( 60)+im*sind( 60)) +
              pnw*(cosd(120)+im*sind(120))
    return Complex{Float16}(p) # round it down for comparisons
end

dirs = []
for l in eachline("input24.txt")
    push!(dirs, parsesteps(l))
end
tiles = Dict{Complex{Float16},Bool}()
for dir in dirs
    p = newgoto(dir)
    v=get!(tiles, p, true)
    tiles[p] = !v
end
for (i,tile) in enumerate(pairs(tiles))
    println(i,'\t',tile)
end

println("Part 1: ", sum([v==false for v in values(tiles)]))
