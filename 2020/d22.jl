function readinput(file)
    blks = split(read(file, String),"\n\n")
    parseblk(b) = [parse(Int8, l) for l in split(strip(blks[b]), '\n')[2:end]]
    return parseblk(1), parseblk(2)
end

function part1(deck1, deck2)
    while length(deck1)*length(deck2) > 0
        p1 = popfirst!(deck1)
        p2 = popfirst!(deck2)
        if p1 > p2
            append!(deck1, [p1, p2])
        else
            append!(deck2, [p2, p1])
        end
    end
end

function score(deck1, deck2)
    s = sum([i*v for (i,v) in enumerate(reverse(vcat(deck1,deck2)))])
    return s
end

function recursivecombat(deck1, deck2, oldrounds=Set())
    winner = 0
    while length(deck1)*length(deck2) > 0
        if [deck1,deck2] ∈ oldrounds
            return 1
        else
            push!(oldrounds, [copy(deck1),copy(deck2)])
            p1 = popfirst!(deck1)
            p2 = popfirst!(deck2)
            if length(deck1) >= p1 && length(deck2) >= p2
                winner = recursivecombat(copy(deck1[1:p1]),copy(deck2[1:p2]))
            elseif p1 > p2
                winner = 1
            else
                winner = 2
            end
            if winner == 1
                append!(deck1, [p1, p2])
                isempty(deck2) && return 1
            else
                append!(deck2, [p2, p1])
                isempty(deck1) && return 2
            end
        end
    end
end

d1,d2 = readinput("input22.txt")
@time part1(d1, d2)
println("Part 1: ", score(d1, d2))
d1,d2 = readinput("input22.txt")
@time recursivecombat(d1, d2)
println("Part 2 winner: ", score(d1, d2))
