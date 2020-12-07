function scanline(line)
    k,v = split(line, " bags contain ")
    ins=Dict{String, Int}()
    for m ∈ eachmatch(r"(?<num>\d+) (?<colr>\w+ \w+) bags?", v)
        ins[m[:colr]] = parse(Int, m[:num])
    end
    return k,ins
end

function scanfile(f)
    d = Dict{String, Dict}()
    for l in readlines(f)
        k,v = scanline(l)
        d[k] = v
    end
    return d
end

function inbag_here(d, b)
    s = Set()
    for p ∈ d
        if haskey(p.second, b)
            push!(s, p.first)
        end
    end
    return s
end

function inbag_deep(d, colr)
    n = 0
    lall = Set([colr])
    while true
        ln = Set()
        n+=1
        for l in lall
            b=inbag_here(d, l)
            ln=union(ln, b)
        end
        if ln ⊆ lall
            break
        else
            union!(lall, ln)
        end
    end
    @info "Finally, after $n loops"
    return delete!(lall, colr)
end

function hasbag(d, colr)
    n=0
    for p in d[colr]
        n += p.second*(1+hasbag(d, p.first))
    end
    n
end

d = scanfile("input07.txt")
mybag = "shiny gold"
allbags = inbag_deep(d, mybag)
println("number of bags that contain '$mybag': ", length(allbags))
println("number of bags within '$mybag': ", hasbag(d, mybag))
