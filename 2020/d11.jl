@inline @views function isfull(seats,r,c)
    if checkbounds(Bool, seats, r, c)
        seats[r,c]=='#' && return 1
        return 0
    else
        return 0
    end
end

@inline @views function adjacents1(seats, r, c)
    isfull(seats,r-1,c-1)+
    isfull(seats,r-1,c)+
    isfull(seats,r-1,c+1)+
    isfull(seats,r,c-1)+
    isfull(seats,r,c+1)+
    isfull(seats,r+1,c-1)+
    isfull(seats,r+1,c)+
    isfull(seats,r+1,c+1)
end

@views function reshuffle1(seats)
    rs,cs=size(seats)
    next = similar(seats)
    changed=false
    for r∈1:rs,c∈1:cs
        a=adjacents1(seats,r,c)
        if seats[r,c] == 'L' && a==0
            next[r,c] = '#'
            changed=true
        elseif seats[r,c] == '#' && a≥4
            next[r,c] = 'L'
            changed=true
        else
            next[r,c] = seats[r,c]
        end
    end
    return next,changed
end

newseats=reduce(vcat, permutedims.(collect.(readlines("input11.txt"))))
@time while true
    global newseats,moved=reshuffle1(newseats)
    !moved && break
end
println("Final count for Part 1: ", count(==('#'), newseats))

@inline @views function adjacentsdir(seats, r, c, rdir, cdir)
    if checkbounds(Bool, seats, r+rdir, c+cdir)
        if seats[r+rdir,c+cdir] == '#'
            return 1
        elseif seats[r+rdir,c+cdir] == 'L'
            return 0
        else
            return adjacentsdir(seats, r+rdir, c+cdir, rdir, cdir)
        end
    else
        return 0
    end
end

@inline @views function adjacents2(seats, r, c)
    adjacentsdir(seats, r, c, -1, -1)+
    adjacentsdir(seats, r, c, -1,  0)+
    adjacentsdir(seats, r, c, -1, +1)+
    adjacentsdir(seats, r, c,  0, -1)+
    adjacentsdir(seats, r, c,  0, +1)+
    adjacentsdir(seats, r, c,  1, -1)+
    adjacentsdir(seats, r, c,  1,  0)+
    adjacentsdir(seats, r, c,  1,  1)
end

@views function reshuffle2(seats)
    rs,cs=size(seats)
    next = similar(seats)
    changed=false
    for r∈1:rs,c∈1:cs
        a=adjacents2(seats,r,c)
        if seats[r,c] == 'L' && a==0
            next[r,c] = '#'
            changed=true
        elseif seats[r,c] == '#' && a≥5
            next[r,c] = 'L'
            changed=true
        else
            next[r,c] = seats[r,c]
        end
    end
    return next,changed
end

newseats=reduce(vcat, permutedims.(collect.(readlines("input11.txt"))))
@time while true
    global newseats,moved=reshuffle2(newseats)
    !moved && break
end
println("Final count for Part 2: ", count(==('#'), newseats))

