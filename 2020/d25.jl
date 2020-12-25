function transform(subject, loopsize, until=false)
    values = Vector{Int}()
    value = 1
    for times ∈ 1:loopsize
        value *= subject
        value = value%20201227
        until && push!(values,value)
    end
    until && return values
    return value
end

mycpk, mydpk = (readlines("input25.txt").|>l->parse(Int, l))

let biglist = transform(7,20000000,true)
    global cardsecretloopsize = findfirst(==(mycpk), biglist)
    global doorsecretloopsize = findfirst(==(mydpk), biglist)
    @assert mycpk == transform(7,cardsecretloopsize)
    @assert mydpk == transform(7,doorsecretloopsize)
    global encryptionkey   = transform(mycpk, doorsecretloopsize)
    @assert encryptionkey == transform(mydpk, cardsecretloopsize)
end

