function readfoodfile(file)
    food = []
    for l in eachline(file)
        ingredients = Set{String}()
        allergens   = Set{String}()
        isingr = true
        for m in eachmatch(r"\b(\w+)\b", l)
            if m[1] == "contains"
                isingr = false
            elseif isingr
                push!(ingredients, m[1])
            else
                push!(allergens, m[1])
            end
        end
        !isempty(ingredients) && !isempty(allergens) &&
            push!(food, (ing=ingredients, alg=allergens))
    end
    return food
end

function scrubfoodlist(fl, ing, alg)
    for k in 1:length(fl)
        delete!(fl[k].ing, ing)
        delete!(fl[k].alg, alg)
    end
end

@views function findingalg(fdlist)
    food = deepcopy(fdlist)
    ingalg = Dict{String,String}()
    allalg = Set()
    for k in 1:length(food)
        union!(allalg, food[k].alg)
    end
    nalg = length(allalg)
    while length(ingalg) < nalg
        useless = []
        for i in 1:length(food)
            isempty(food[i].ing) && push!(useless, i)
            isempty(food[i].alg) && push!(useless, i)
        end
        sort!(useless)
        unique!(useless)
        deleteat!(food, useless)
        for i in 1:length(food)-1, j in i+1:length(food)
            if length(food[i].ing) == 1 && length(food[i].alg) == 1
                #@info "delete unique map"
                ing = only(food[i].ing)
                alg = only(food[i].alg)
                ingalg[ing] = alg
                deleteat!(food, i)
                scrubfoodlist(food, ing, alg)
                break
            else
                commona = intersect(food[i].alg, food[j].alg)
                isempty(commona) && continue
                commoni = intersect(food[i].ing, food[j].ing)
                isempty(commoni) && continue
                if length(commoni) == 1 && length(commona) == 1
                    ing = only(commoni)
                    alg = only(commona)
                    ingalg[ing] = alg
                    scrubfoodlist(food, ing, alg)
                elseif (ing=commoni, alg=commona) ∉ food
                    #@info "adding" commoni commona
                    push!(food, (ing=commoni, alg=commona))
                end
            end
        end
    end
    #@info length(food)
    return ingalg
end

function main()
    input = "input21.txt"
    food = readfoodfile(input)
    ingalg = @time findingalg(food)
    for k in keys(ingalg)
        scrubfoodlist(food, k, ingalg[k])
    end
    s=sum([length(food[k].ing) for k in 1:length(food)])
    println("Part 1: $s")
    ings=[k for (k,v) in sort(collect(pairs(ingalg)), by=last)]
    println("Part 2: ", join(ings, ','))
end
main()
