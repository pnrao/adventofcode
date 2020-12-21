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

function findingalg(fdlist)
    food = deepcopy(fdlist)
    ingall = Dict{String,String}()
    allalg = Set()
    for k in 1:length(food)
        union!(allalg, food[k].alg)
    end
    nalg = length(allalg)
    while length(ingall) < nalg
        for i in 1:length(food), j in 1:length(food)
            if isempty(food[j].ing)
                #@info "delete empty"
                deleteat!(food, j)
                break
            elseif length(food[i].ing) == 1 && length(food[i].alg) == 1
                #@info "delete unique map"
                ing = only(food[i].ing)
                alg = only(food[i].alg)
                ingall[ing] = alg
                deleteat!(food, i)
                scrubfoodlist(food, ing, alg)
                break
            elseif i!=j
                commoni = intersect(food[i].ing, food[j].ing)
                commona = intersect(food[i].alg, food[j].alg)
                isempty(commoni) || isempty(commona) && continue
                if length(commoni) == 1 && length(commona) == 1
                    ing = only(commoni)
                    alg = only(commona)
                    ingall[ing] = alg
                    scrubfoodlist(food, ing, alg)
                elseif length(commoni) >= 1 && length(commona) >= 1 &&
                        (ing=commoni, alg=commona) ∉ food
                    push!(food, (ing=commoni, alg=commona))
                end
            end
        end
    end
    return ingall
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
