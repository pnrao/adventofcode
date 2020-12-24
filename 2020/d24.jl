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

const center = (1+im)*1e4
const scale = 1e3
const neighbors=(
    e =Complex{Float32}(scale*( 1.      +.0im)),
    w =Complex{Float32}(scale*(-1.      +.0im)),
    ne=Complex{Float32}(scale*(cosd( 60)+im*sind( 60))),
    nw=Complex{Float32}(scale*(cosd(120)+im*sind(120))),
    sw=Complex{Float32}(scale*(cosd(240)+im*sind(240))),
    se=Complex{Float32}(scale*(cosd(300)+im*sind(300))))

function goto(steps)
    # ∵ crossing the axes gets results like +0.0im != -0.0im
    pe = count(==( "e"), steps)-count(==( "w"), steps)
    pne= count(==("ne"), steps)-count(==("sw"), steps)
    pnw= count(==("nw"), steps)-count(==("se"), steps)
    p  = center*scale + pe*neighbors.e + pne*neighbors.ne +
              pnw*neighbors.nw
    return Complex{Float32}(p) # rounding it down for comparisons
end

function parsefile(file)
    dirs = []
    for l in eachline(file)
        push!(dirs, parsesteps(l))
    end
    tiles = Dict{Complex{Float32},Bool}()
    for dir in dirs
        p = goto(dir)
        v=get!(tiles, p, false)
        tiles[p] = !v
    end
    return tiles
end

function countblacks(tiles)
    # white = false, black = true
    return sum(values(tiles))
end

function nextgen(tiles)
    newtiles = copy(tiles)
    for t in keys(tiles)
        for nbr in neighbors
            if tiles[t]
                get!(newtiles, t+nbr, false)
            end
        end
    end
    for t in keys(newtiles)
        nbrcnt = sum([get(tiles, t+n, false) for n in neighbors])
        originalcolor = get(tiles, t, false)
        if originalcolor && (nbrcnt==0 || nbrcnt>2) # was black
             newtiles[t] = false
        elseif !originalcolor && nbrcnt == 2 # was white
            newtiles[t] = true
        end
    end
    return newtiles
end

function main()
    ts = parsefile("input24.txt")
    part1 = countblacks(ts)
    for i in 1:100
        ts = nextgen(ts)
        #println(i,'\t', length(ts), '\t', countblacks(ts))
    end
    part2 = countblacks(ts)
    pts = collect(keys(ts))
    # fiddle with center and scale if the extrema cross the axes
    # println("x extrema: ", extrema(real(pts)))
    # println("y extrema: ", extrema(imag(pts)))
    return part1, part2
end
p1,p2 = @time main()
println("Part 1: ", p1)
println("Part 2: ", p2)
