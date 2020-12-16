let
    blocks = split(read("input16.txt", String), "\n\n")
    rules = Dict{String,Set{Int}}()
    allranges = Set{Int}()
    # Read the rules and ranges
    for line in split(blocks[1], "\n")
        chunks = split(line, r"(: )|( or )|-")
        lims = [parse(Int,x) for x in chunks[2:end]]
        u = union(Set(lims[1]:lims[2]), Set(lims[3]:lims[4]))
        rules[chunks[1]] = u
        union!(allranges, u)
    end
    looksgood(n::Int) = n ∈ allranges

    global function part1()
        invalid_total = 0
        for m in eachmatch(r"(\d+)", blocks[3])
            n = parse(Int, m[1])
            if !looksgood(n) invalid_total+=n end
        end
        return invalid_total
    end

    global function part2()
        myticket = [parse(Int,m[1]) for m in eachmatch(r"(\d+)", blocks[2])]
        nearbytkts = Matrix{Int}(undef,0,length(rules))
        # Make a numbers/tickets (R/C) Matrix
        for str in split(blocks[3],"\n")[2:end]
            ints = Vector{Int}()
            for m in eachmatch(r"(\d+)", str)
                n = parse(Int, m[1])
                if !looksgood(n) break end
                append!(ints, n)
            end
            if length(ints) == length(rules)
                nearbytkts = vcat(nearbytkts, ints')
            end
        end
        # Find out which rules are valid for entire columns
        rulecolmatches = Dict()
        for col ∈ 1:length(rules), (name, range)∈rules
            rulecolmatch = true
            for e in nearbytkts[:,col]
                if e∉range
                    rulecolmatch = false
                    break
                end
            end
            if rulecolmatch
                push!(get!(rulecolmatches, name, Set{Int}()), col)
            end
        end
        # Find out which rule is applicable to only one column,
        # and then delete that rule from all the other columns.
        # Repeat until each rule matches with only one column.
        i=0
        while sum(length.(values(rulecolmatches))) > 20
            for (k,v) ∈ rulecolmatches
                if length(v) == 1
                    s = only(v)
                    for k2 ∈ keys(rulecolmatches)
                        if k!=k2
                            delete!(rulecolmatches[k2], s)
                        end
                    end
                end
            end
            i+=1
        end
        #@info "Settled after $i iterations" rulecolmatches
        departureprod=1
        for (k,v) ∈ rulecolmatches
            if startswith(k, "departure")
                i = only(v)
                departureprod*=myticket[i]
            end
        end
        return departureprod
    end
end

println("Part 1: ", @time part1())
println("Part 2: ", @time part2())
