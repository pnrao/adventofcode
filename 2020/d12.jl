struct ShipLoc
    n::Int
    e::Int
    o::Char
end

Dirs="ENWS"

function relocate(ol, c, i)
    c=='N' && return ShipLoc(ol.n+i, ol.e  , ol.o)
    c=='S' && return ShipLoc(ol.n-i, ol.e  , ol.o)
    c=='E' && return ShipLoc(ol.n  , ol.e+i, ol.o)
    c=='W' && return ShipLoc(ol.n  , ol.e-i, ol.o)
    c=='F' && return relocate(ol, ol.o, i)
    o = findfirst(ol.o, Dirs)
    angl = i ÷ 90
    c=='L' && return ShipLoc(ol.n, ol.e, Dirs[mod1(o+angl,4)])
    c=='R' && return ShipLoc(ol.n, ol.e, Dirs[mod1(o-angl,4)])
    error("Invalid command $c$i")
end

function scanfile(f)
    loc=ShipLoc(0, 0, 'E')
    for s in eachline(f)
        c = s[1]
        i = parse(Int, s[2:end])
        loc = relocate(loc, c, i)
    end
    @info loc
    return loc
end

function manhattan(l)
    abs(l.n)+abs(l.e)
end

manhattan(scanfile("input12.txt"))
