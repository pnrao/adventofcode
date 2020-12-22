function readinput(file)
    blks = split(read(file, String),"\n\n")
    deck = [[],[]]
    for i in 1:length(blks)
        for l in split(blks[i], '\n')[2:end]
            isempty(l) && continue
            push!(deck[i], parse(Int, l))
        end
    end
    return deck[1], deck[2]
end

function part1(deck1, deck2)
    while !isempty(deck1) && !isempty(deck2)
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
    winner = isempty(deck1) ? deck2 : deck1
    s = sum([i*v for (i,v) in enumerate(reverse(winner))])
    return s
end

function recursivecombat(deck1, deck2, oldrounds=[])
    winner = 0
    round = 0
    while !isempty(deck1) && !isempty(deck2)
        round += 1
        if [deck1,deck2] ∈ oldrounds
            return 1
        else
            push!(oldrounds, deepcopy([deck1,deck2]))
            p1 = popfirst!(deck1)
            p2 = popfirst!(deck2)
            if length(deck1) >= p1 && length(deck2) >= p2
                newdeck = deepcopy([deck1[1:p1],deck2[1:p2]])
                winner = recursivecombat(newdeck, [])
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
