ads = sort(readlines("input10.txt").|>l->parse(Int,l))

pushfirst!(ads,0)
push!(ads,ads[end]+3)
diffs=[ads[i]-ads[i-1] for i ∈ 2:length(ads)]

println("Part 1: ", count(==(1), diffs)*(count(==(3), diffs)))
