include("../preamble.jl")
#progdir = dirname(abspath(joinpath(".", @__FILE__)))
function getmaxtotal()
    thistotal = 0
    maxcals = zeros(Int, 3)
    for l in eachline("$(progdir)/input01.txt")
        try
            thistotal += parse(Int, l)
        catch e
            i = searchsortedfirst(maxcals, thistotal, rev=true)
            if i < length(maxcals)
                insert!(maxcals, i, thistotal)
                maxcals = maxcals[1:3]
            end
            thistotal = 0
        end
    end
    maxcals
end

#println("Part 1: $(getmaxtotal())")
m = getmaxtotal()
println("Part 1: ", m[1])
println("Part 2: ", sum(m))
