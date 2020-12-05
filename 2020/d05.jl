function decode(s)
    parse(Int,
    replace(replace(s, r"F|L"=>"0"), r"B|R"=>"1"),
    base=2)
end

seats=readlines("input05.txt")|>l->decode.(l)
stmin = seats|>minimum
stmax = seats|>maximum
print("Last: ")
println(stmax)

print("Available: ")
println(setdiff([stmin:stmax;], seats))
