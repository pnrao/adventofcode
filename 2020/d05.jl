function decode(s)
    parse(Int,
    replace(replace(s, r"F|L"=>"0"), r"B|R"=>"1"),
    base=2)
end

seats=readlines("input05.txt")|>l->decode.(l)|>sort
println("Last: ", seats[end])

print("Available: ")
println(setdiff([seats[1]:seats[end];], seats))
