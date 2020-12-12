using BenchmarkTools
# Part 1

mutable struct ShipLoc
    sn::Int
    se::Int
    o::Char # orientation, one of E/N/W/S
end

Dirs="ENWS"

function relocate!(sl, c, i)
    c=='N' && (sl.sn+=i; return)
    c=='S' && (sl.sn-=i; return)
    c=='E' && (sl.se+=i; return)
    c=='W' && (sl.se-=i; return)
    c=='F' && (relocate!(sl, sl.o, i); return)
    o = findfirst(sl.o, Dirs)
    angl = i ÷ 90
    c=='L' && (sl.o=Dirs[mod1(o+angl,4)]; return)
    c=='R' && (sl.o=Dirs[mod1(o-angl,4)]; return)
    error("Invalid command $c$i")
end

# Part 2

mutable struct ShipWayLoc
    sn::Int # ship locations
    se::Int
    wn::Int # waypoint locations
    we::Int
end

function waylocate!(swl, c, i)
    c=='N' && (swl.wn+=i; return)
    c=='S' && (swl.wn-=i; return)
    c=='E' && (swl.we+=i; return)
    c=='W' && (swl.we-=i; return)
    c=='F' && (swl.sn+=swl.wn*i; swl.se+=swl.we*i; return)
    c∉"LR" && error("Invalid command $c$i")
    angl = mod((i ÷ 90)*(c=='R' ? -1 : 1), 4)
    wn=swl.wn
    we=swl.we
    angl==1 && (swl.wn= we; swl.we=-wn; return)
    angl==2 && (swl.wn=-wn; swl.we=-we; return)
    angl==3 && (swl.wn=-we; swl.we= wn; return)
end

# Combined

input = readlines("input12.txt").|>s->(s[1],parse(Int, s[2:end]))

function runcmds(cmds, loc, movemethod)
    for cmd in cmds
        movemethod(loc, cmd...)
    end
    return loc
end

function manhattan(l)
    abs(l.sn)+abs(l.se)
end

@btime runcmds(input, part1ship, relocate!) setup=(global part1ship = ShipLoc(0, 0, 'E'))
m=manhattan(part1ship)
println("Part 1 manhattan distance = $m")

@btime runcmds(input, part2ship, waylocate!) setup=(global part2ship=ShipWayLoc(0, 0, 1, 10))
m=manhattan(part2ship)
println("Part 2 manhattan distance = $m")
