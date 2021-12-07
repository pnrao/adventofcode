try include("preamble.jl") catch end
sample=[16,1,2,0,4,2,7,1,2,14]

input = parse.(Int,split(readline("input07.txt"),','))

fuel(list) = pos->sum(map(c->abs(c-pos), list))

fuel2(list) = pos->sum(map(c->(k=abs(c-pos);k*(k+1)÷2), list))

@show findmin(fuel(sample),range(extrema(sample)...))
@show findmin(fuel2(sample), range(extrema(sample)...))
@show findmin(fuel(input),range(extrema(input)...))
@show findmin(fuel2(input),range(extrema(input)...))
