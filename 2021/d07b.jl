### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 64bbff86-176f-4d34-9b77-2e4c9402bd22
try include("preamble.jl") catch end

# ╔═╡ f91de97c-2839-49d1-b2f5-293986f55f6e
sample=[16,1,2,0,4,2,7,1,2,14]

# ╔═╡ 22c0405c-8ef6-4b7e-bcf6-9ddbf54d6dfa
input = parse.(Int,split(readline("input07.txt"),','))

# ╔═╡ 5b592c20-5a2b-453e-a697-cb36b7f67f04
fuel(list) = pos->sum(map(c->abs(c-pos), list))

# ╔═╡ 8e2d50a9-fa84-436d-bafb-30048277f429
fuel2(list) = pos->sum(map(c->(k=abs(c-pos);k*(k+1)÷2), list))

# ╔═╡ e167b005-5ef0-4367-9519-51121d37c775
findmin(fuel(sample),range(extrema(sample)...))

# ╔═╡ eb3eb637-d8ea-4d1e-ae8d-01a5da10651f
findmin(fuel2(sample), range(extrema(sample)...))

# ╔═╡ 83999af1-66c4-4d35-86a3-66374cb45ef8
findmin(fuel(input),range(extrema(input)...))

# ╔═╡ bfb02a24-442a-4f3b-a300-0828f96ebda9
findmin(fuel2(input),range(extrema(input)...))

# ╔═╡ Cell order:
# ╠═64bbff86-176f-4d34-9b77-2e4c9402bd22
# ╠═f91de97c-2839-49d1-b2f5-293986f55f6e
# ╠═22c0405c-8ef6-4b7e-bcf6-9ddbf54d6dfa
# ╠═5b592c20-5a2b-453e-a697-cb36b7f67f04
# ╠═8e2d50a9-fa84-436d-bafb-30048277f429
# ╠═e167b005-5ef0-4367-9519-51121d37c775
# ╠═eb3eb637-d8ea-4d1e-ae8d-01a5da10651f
# ╠═83999af1-66c4-4d35-86a3-66374cb45ef8
# ╠═bfb02a24-442a-4f3b-a300-0828f96ebda9
