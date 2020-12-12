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

# Combined

function runcmds(cmds, loc, movemethod)
    for cmd in cmds
        loc=movemethod(loc, cmd...)
    end
    #@info loc
    return loc
end

function manhattan(l)
    abs(l.sn)+abs(l.se)
end

input = readlines("input12.txt").|>s->(s[1],parse(Int, s[2:end]))

@btime part1ship=runcmds(input, part1ship, relocate) setup=(global part1ship = ShipLoc(0, 0, 'E'))
m=manhattan(part1ship)
println("Part 1 manhattan distance = $m")

@btime part2ship=runcmds(input, part2ship, waylocate) setup=(global part2ship=ShipWayLoc(0, 0, 1, 10))
m=manhattan(part2ship)
println("Part 2 manhattan distance = $m")
