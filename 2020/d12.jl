using BenchmarkTools
# Part 1

struct ShipLoc
    sn::Int
    se::Int
    o::Char # one of E/N/W/S
end

Dirs="ENWS"

function relocate(ol, c, i)
    c=='N' && return ShipLoc(ol.sn+i, ol.se  , ol.o)
    c=='S' && return ShipLoc(ol.sn-i, ol.se  , ol.o)
    c=='E' && return ShipLoc(ol.sn  , ol.se+i, ol.o)
    c=='W' && return ShipLoc(ol.sn  , ol.se-i, ol.o)
    c=='F' && return relocate(ol, ol.o, i)
    o = findfirst(ol.o, Dirs)
    angl = i ÷ 90
    c=='L' && return ShipLoc(ol.sn, ol.se, Dirs[mod1(o+angl,4)])
    c=='R' && return ShipLoc(ol.sn, ol.se, Dirs[mod1(o-angl,4)])
    error("Invalid command $c$i")
end

function scanfile1(f)
    loc=ShipLoc(0, 0, 'E')
    for s in eachline(f)
        c = s[1]
        i = parse(Int, s[2:end])
        loc = relocate(loc, c, i)
    end
    #@info loc
    return loc
end

function manhattan(l)
    abs(l.sn)+abs(l.se)
end

part1ship=@btime scanfile1("input12.txt")
m=manhattan(part1ship)
println("Part 1 manhattan distance = $m")


# Part 2

struct ShipWayLoc
    sn::Int
    se::Int
    wn::Int
    we::Int
end

function waylocate(ol, c, i)
    c=='N' && return ShipWayLoc(ol.sn, ol.se, ol.wn+i, ol.we)
    c=='S' && return ShipWayLoc(ol.sn, ol.se, ol.wn-i, ol.we)
    c=='E' && return ShipWayLoc(ol.sn, ol.se, ol.wn  , ol.we+i)
    c=='W' && return ShipWayLoc(ol.sn, ol.se, ol.wn  , ol.we-i)
    c=='F' && return ShipWayLoc(ol.sn+ol.wn*i, ol.se+ol.we*i, ol.wn, ol.we)
    angl = mod((i ÷ 90)*(c=='R' ? -1 : 1), 4)
    angl==1 && return ShipWayLoc(ol.sn, ol.se,  ol.we, -ol.wn)
    angl==2 && return ShipWayLoc(ol.sn, ol.se, -ol.wn, -ol.we)
    angl==3 && return ShipWayLoc(ol.sn, ol.se, -ol.we,  ol.wn)
    error("Invalid command $c$i")
end

function scanfile2(f)
    loc=ShipWayLoc(0, 0, 1, 10)
    for s in eachline(f)
        c = s[1]
        i = parse(Int, s[2:end])
        loc = waylocate(loc, c, i)
    end
    #@info loc
    return loc
end

part2ship=@btime scanfile2("input12.txt")
m=manhattan(part2ship)
println("Part 2 manhattan distance = $m")
