⊕(a, b)=a*b
⊗(a,b)=a+b

part1=sum(readlines("input18.txt").|>l->replace(l, '*'=>'⊕').|>Meta.parse.|>eval)
println("Part 1: $part1")

part2=sum(readlines("input18.txt").|>l->replace(replace(l, '*'=>'⊕'),'+'=>'⊗').|>Meta.parse.|>eval)
println("Part 2: $part2")
