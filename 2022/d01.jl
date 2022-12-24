include("../preamble.jl")
isdefined(Base, :progdir) || (progdir = dirname(abspath(joinpath(".", @__FILE__))))
function getmaxtotal()
    thistotal = 0
    Nelfs = 3
    maxcals = zeros(Int, Nelfs)
    for l in eachline("$(progdir)/input01.txt")
        try
            thistotal += parse(Int, l)
        catch e
            i = searchsortedfirst(maxcals, thistotal, rev=true)
            if i < Nelfs
                insert!(maxcals, i, thistotal)
                n = length(maxcals)
                if n > Nelfs
                    deleteat!(maxcals, Nelfs+1:n)
                end
            end
            thistotal = 0
        end
    end
    maxcals
end

m = getmaxtotal()
println("Part 1: ", m[1])
println("Part 2: ", sum(m))
