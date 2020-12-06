blks = read("input06.txt",String)|>b->split(b, "\n\n").|>split
anyyes = blks.|>l->reduce(union,l)|>length
println("Sum of questions to which anyone in each group answered \"yes\" = ", sum(anyyes))

allyes = blks.|>l->reduce(intersect,l)|>length
println("Sum of questions to which everyone in each group answered \"yes\" = ", sum(allyes))
