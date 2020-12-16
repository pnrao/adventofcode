using PrettyPrint
blocks = split(read("input16.txt", String), "\n\n")
rules = Dict{String,Array{UnitRange{Int},1}}()
allranges = Set{UnitRange{Int}}()
for line in split(blocks[1], "\n")
    chunks = split(line, r"(: )|( or )|-")
    lims = [parse(Int,x) for x in chunks[2:end]]
    rules[chunks[1]] = [lims[1]:lims[2], lims[3]:lims[4]]
end

for v in values(rules)
    push!(allranges, v[1], v[2])
end

function looksgood(n::Int)
    inrange = false
    for range in allranges
        if n ∈ range
            inrange = true
            break
        end
    end
    return inrange
end

function part1()
    invalid_total = 0
    for m in eachmatch(r"(\d+)", blocks[3])
        n = parse(Int, m[1])
        if !looksgood(n) invalid_total+=n end
    end
    return invalid_total
end

println("Part 1: ", part1())

myticket = [parse(Int,m[1]) for m in eachmatch(r"(\d+)", blocks[2])]

colrulematches = Dict()
rulecolmatches = Dict()
function part2()
    tktstrs = split(blocks[3],"\n")[2:end]
    global nearbytkts = Matrix{Int}(undef,0,length(rules))
    for str in tktstrs
        ints = Vector{Int}()
        allnumsvalid = true
        for m in eachmatch(r"(\d+)", str)
            n = parse(Int, m[1])
            if !looksgood(n) allnumsvalid=false; break end
            append!(ints, n)
        end
        if allnumsvalid && !isempty(ints)
            global nearbytkts = vcat(nearbytkts, ints')
        end
    end
    println(size(nearbytkts))
    for col ∈ 1:length(rules), (name, range)∈rules
        colrulematch = true
        for e in nearbytkts[:,col]
            if e∉range[1] && e∉range[2]
                colrulematch = false
                break
            end
        end
        if colrulematch
            #println("column $col matches rule $name")
            push!(get!(rulecolmatches, name, Set{Int}()), col)
            push!(get!(colrulematches, col, Set{String}()), name)
        end
    end
    #@info "Init" rulecolmatches
    #@info colrulematches
    i=0
    while sum(length.(values(rulecolmatches))) > 20
        for (k,v) ∈ rulecolmatches
            if length(v) == 1
                singl = pop!(copy(v))
                for k2 ∈ keys(rulecolmatches)
                    if k!=k2 #&& v[1] ∈ rulecolmatches[k2]
                        #println("trying to delete $(singl) from $(rulecolmatches[k2])")
                        delete!(rulecolmatches[k2], singl)
                    end
                end
            end
        end
        i+=1
    end
    @info "Settled after $i iterations" rulecolmatches
    i=0
    while sum(length.(values(colrulematches))) > 20
        for (k,v) ∈ colrulematches
            if length(v) == 1
                singl = pop!(copy(v))
                for k2 ∈ keys(colrulematches)
                    if k!=k2 #&& v[1] ∈ rulecolmatches[k2]
                        #println("trying to delete $(singl) from $(rulecolmatches[k2])")
                        delete!(colrulematches[k2], singl)
                    end
                end
            end
        end
        i+=1
    end
    @info "Settled after $i iterations" colrulematches
    departureprod=1
    for (k,v) ∈ rulecolmatches
        if startswith(k, "departure")
            i = pop!(copy(v))
            departureprod*=myticket[i]
        end
    end
    return departureprod
end

part2()
