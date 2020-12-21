### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 754e855c-4299-11eb-321c-1f5b267e7f25
# Given an edge, convert it to an integer
intifyf(arr)=parse(Int,join(arr),base=2)

# ╔═╡ 890f0136-42b7-11eb-0bbf-ffc3c9ab8d02
# Same as intifyf, but read edge backwards
intifyb(arr)=parse(Int,reverse(join(arr)),base=2)

# ╔═╡ b8813e00-4299-11eb-0159-0b1205ca332f
# Make a list of all possible "edge numbers"
intify(mtrx)=[
	intifyf(mtrx[1,:]),
	intifyf(mtrx[:,1]),
	intifyf(mtrx[end,:]),
	intifyf(mtrx[:,end]),
	intifyb(mtrx[1,:]),
	intifyb(mtrx[:,1]),
	intifyb(mtrx[end,:]),
	intifyb(mtrx[:,end]),
]

# ╔═╡ 74971f6c-428e-11eb-31d3-0b5a3154b724
tiles = Dict()

# ╔═╡ 6b291190-42bd-11eb-3e35-35884a47923e
for grp in eachmatch(r"Tile (\d+):\n(.*?)\n\n"s,read("input20.txt", String))
	n = parse(Int, grp[1])
	m = replace(replace(grp[2],"#"=>" 1"),"."=>" 0")
	m = eval(Meta.parse('['*m*']'))
	tiles[n] = m
end

# ╔═╡ 93e878ec-42ab-11eb-242e-45544983869a
function makenhbrs(ts)
	edges = Dict()
	for k in keys(ts)
		edges[k]=intify(ts[k])
	end
	ns = Dict(k=>Set() for k in keys(ts))
	for j in keys(edges)
		for k in keys(edges)
			if j!=k && length(intersect(edges[j], edges[k]))>0
				push!(ns[j], k)
				push!(ns[k], j)
			end
		end
	end
	return ns
end

# ╔═╡ 95f5bfc8-4348-11eb-368c-bf27e4a4a603
nhbrs=makenhbrs(tiles)

# ╔═╡ a4a4c518-42bd-11eb-08ec-03a10e6085a0
cornerpieces = [k for k in keys(nhbrs) if length(nhbrs[k])==2]

# ╔═╡ 46ee1140-42c7-11eb-0529-2504664840fa
@show "Part 1: $(prod(cornerpieces))"

# ╔═╡ Cell order:
# ╠═754e855c-4299-11eb-321c-1f5b267e7f25
# ╠═890f0136-42b7-11eb-0bbf-ffc3c9ab8d02
# ╠═b8813e00-4299-11eb-0159-0b1205ca332f
# ╠═74971f6c-428e-11eb-31d3-0b5a3154b724
# ╠═6b291190-42bd-11eb-3e35-35884a47923e
# ╠═93e878ec-42ab-11eb-242e-45544983869a
# ╠═95f5bfc8-4348-11eb-368c-bf27e4a4a603
# ╠═a4a4c518-42bd-11eb-08ec-03a10e6085a0
# ╠═46ee1140-42c7-11eb-0529-2504664840fa
