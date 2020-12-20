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
	try
	m = eval(Meta.parse('['*m*']'))
	catch
		println(m)
	end
	tiles[n] = m
end

# ╔═╡ 93e878ec-42ab-11eb-242e-45544983869a
edges = Dict()

# ╔═╡ 9b464f1c-42ab-11eb-28ee-2dd7298941e8
for k in keys(tiles)
	edges[k]=intify(tiles[k])
end

# ╔═╡ f22da886-4298-11eb-0cd1-7fe1ab9c1a35
nhbrs = Dict()

# ╔═╡ a661a0ae-42ba-11eb-02ae-db732a0c5bb4
for k in keys(edges)
	nhbrs[k] = Set()
end

# ╔═╡ 41aa3f22-42b8-11eb-1f9e-9528af137ecb
for j in keys(edges)
	for k in keys(edges)
		if j!=k && length(intersect(edges[j], edges[k]))>0
			push!(nhbrs[j], k)
			push!(nhbrs[k], j)
		end
	end
end

# ╔═╡ a4a4c518-42bd-11eb-08ec-03a10e6085a0
cornerpieces = [k for k in keys(nhbrs) if length(nhbrs[k])==2]

# ╔═╡ Cell order:
# ╠═754e855c-4299-11eb-321c-1f5b267e7f25
# ╠═890f0136-42b7-11eb-0bbf-ffc3c9ab8d02
# ╠═b8813e00-4299-11eb-0159-0b1205ca332f
# ╠═74971f6c-428e-11eb-31d3-0b5a3154b724
# ╠═6b291190-42bd-11eb-3e35-35884a47923e
# ╠═93e878ec-42ab-11eb-242e-45544983869a
# ╠═9b464f1c-42ab-11eb-28ee-2dd7298941e8
# ╠═f22da886-4298-11eb-0cd1-7fe1ab9c1a35
# ╠═a661a0ae-42ba-11eb-02ae-db732a0c5bb4
# ╠═41aa3f22-42b8-11eb-1f9e-9528af137ecb
# ╠═a4a4c518-42bd-11eb-08ec-03a10e6085a0
