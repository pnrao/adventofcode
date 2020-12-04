struct Passport
    byr::Int16
    iyr::Int16
    eyr::Int16
    hgt::String
    hcl::String
    ecl::String
    pid::String
    cid
end

pdb = Array{Passport,1}()

db_blocks = split(read("input04.txt", String), "\n\n")

for blk in db_blocks
    flds = split(blk)
    local byr, iyr, eyr, hgt, hcl, ecl, pid
    local cid = missing
    for f in flds
        k,v = split(f, ":")
        if     k=="byr"
            n=parse(Int16,v)
            if 1920 <= n <= 2002 byr=n end
        elseif k=="iyr"
            n=parse(Int16,v)
            if 2010 <= n <= 2020 iyr=n end
        elseif k=="eyr"
            n=parse(Int16,v)
            if 2020 <= n <= 2030 eyr=n end
        elseif k=="hgt"
            if (endswith(v,"cm") && 150<=parse(Int,v[1:end-2])<=193) ||
               (endswith(v,"in") && 59<=parse(Int,v[1:end-2])<=76)
               hgt=v end
        elseif k=="hcl"
            if length(v)==7 && occursin(r"#[0-9a-f]{6}", v)
                hcl=v end
        elseif k=="ecl"
            if v ∈ ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
            ecl=v end
        elseif k=="pid"
            if length(v)==9 && occursin(r"[0-9]{9}", v)
            pid=v end
        elseif k=="cid" cid=v
        else
            @warn ("unknown field $k")
        end
    end
    try
        p = Passport(byr, iyr, eyr, hgt, hcl, ecl, pid, cid)
        push!(pdb, p)
    catch e
        if isa(e, UndefVarError)
            continue
        end
    end
end
#println(pdb)
println(length(pdb))
