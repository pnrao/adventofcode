using PrettyPrint
let round=0
    game =0
    global function maxroundgame(rnd, gm)
        round=max(round,rnd)
        game =max(game, gm)
    end
    global function getmaxroundgame()
        return round, game
    end
end

function readinput(file)
    blks = split(read(file, String),"\n\n")
    deck = [[],[]]
    for i in 1:length(blks)
        for l in split(blks[i], '\n')[2:end]
            isempty(l) && continue
            push!(deck[i], parse(Int, l))
        end
    end
    return deck
end

function part1(decks)
    while !isempty(decks[1]) && !isempty(decks[2])
        p1 = popfirst!(decks[1])
        p2 = popfirst!(decks[2])
        if p1 > p2
            append!(decks[1], [p1, p2])
        else
            append!(decks[2], [p2, p1])
        end
    end
end

function score(decks)
    #@info "== Post-game results =="
    #@info "Player 1's deck: $(join(decks[1],','))"
    #@info "Player 2's deck: $(join(decks[2],','))"
    winner = isempty(decks[1]) ? 2 : 1
    s = sum([i*v for (i,v) in enumerate(reverse(decks[winner]))])
    return s
end

function recursivecombat(decks, oldrounds, game=1)
    winner = 0
    round = 0
    while true
        round += 1
        maxroundgame(round, game)
        #@info "-- Round $round (Game $game) --"
        if decks ∈ oldrounds
            #@info "matched old" decks oldrounds
            return 1
        else
            push!(oldrounds, deepcopy(decks))
            #@info "Player 1's deck: $(join(decks[1],','))"
            #@info "Player 2's deck: $(join(decks[2],','))"
            p1 = popfirst!(decks[1])
            p2 = popfirst!(decks[2])
            #@info "Player 1 plays: $p1"
            #@info "Player 2 plays: $p2"
            if length(decks[1]) >= p1 && length(decks[2]) >= p2
                #@info "Playing a sub-game to determine the winner..."
                newdeck = deepcopy([decks[1][1:p1],decks[2][1:p2]])
                winner = recursivecombat(newdeck, [], game+1)
                #@info "The winner of game $(game+1) is player $(winner)!"
            elseif p1 > p2
                winner = 1
            else
                winner = 2
            end
            #@info "Player $winner wins round $round of game $(game)!"
            if winner == 1
                append!(decks[1], [p1, p2])
                isempty(decks[2]) && return 1
            else
                append!(decks[2], [p2, p1])
                isempty(decks[1]) && return 2
            end
        end
    end
end

decks = readinput("input22.txt")
@time part1(decks)
println("Part 1: ", score(decks))
decks = readinput("input22.txt")
@time recursivecombat(decks, [])
println("Part 2 winner: ", score(decks))
r,g=getmaxroundgame()
println("Maximum recursive depth: $g. Maximum round number: $r")
